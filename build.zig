const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Fetch zig-network from GitHub
    const network_dep = b.dependency("network", .{
        .target = target,
        .optimize = optimize,
    });

    // Get the network module from the dependency
    const network_module = network_dep.module("network");

    // Create the server executable
    const server = b.addExecutable(.{
        .name = "game_server",
        .root_source_file = b.path("server.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Add the network module to the server
    server.root_module.addImport("network", network_module);

    // Install the server binary
    b.installArtifact(server);

    // Add a run step
    const run_cmd = b.addRunArtifact(server);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the game server");
    run_step.dependOn(&run_cmd.step);
}
