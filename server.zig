const std = @import("std");
const network = @import("network");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const server_name = "test game server";
    defer allocator.free(server_name);

    try network.init();
    defer network.deinit();
    var socket = try network.Socket.create(.ipv4, .udp);
    defer socket.close();

    const endpoint = network.EndPoint{
        .address = network.Address{
            .ipv4 = network.Address.IPv4.multicast_all,
        },
        .port = 8080,
    };

    std.debug.print("Sending UDP messages to clients via {}\n", .{endpoint});
    while (true) {
        const current_time = std.time.timestamp();
        const timestamp_seconds = @mod(current_time, 86400); // Seconds since midnight

        const hours = @divTrunc(timestamp_seconds, 3600);
        const minutes = @divTrunc(@mod(timestamp_seconds, 3600), 60);
        const seconds = @mod(timestamp_seconds, 60);

        const timestamp = try std.fmt.allocPrint(allocator, "[{d:0>2}:{d:0>2}:{d:0>2}]", .{ hours, minutes, seconds });
        defer allocator.free(timestamp);

        const message = try std.fmt.allocPrint(allocator, "{s} hello from {s}", .{ timestamp, server_name });
        defer allocator.free(message);
        _ = try socket.sendTo(endpoint, message);
        std.debug.print("Sending UDP message...\n", .{});

        std.time.sleep(2 * std.time.ns_per_s);
    }
}
