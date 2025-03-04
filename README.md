# Proof of Concept UDP Zig Server

A simple UDP server that broadcasts timestamped messages using Zig.

## Quick Start

1. Build the project:
```bash
zig build
```

2. Run the server:
```bash
zig build run
```

3. Listen for messages (in another terminal):
```bash
nc -ul 8080
```
or
```bash
socat UDP-LISTEN:8080,fork STDOUT
```

The server sends timestamped messages every 2 seconds to port 8080.
