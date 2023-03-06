const std = @import("std");
const mem = std.mem;
const os = std.os;

pub fn main() !void {
    const sock_timeout = os.timeval {
        .tv_sec = 10,
        .tv_usec = 0,
    };
    const sock_addr = os.sockaddr.in {
        .family = os.AF.INET,
        .addr = 0xC0A80001,
        .port = comptime mem.nativeToBig(u16, 25565),
    };
    const sock_fd = try os.socket(os.AF.INET, os.SOCK.STREAM | os.SOCK.NONBLOCK, 0);
    errdefer os.closeSocket(sock_fd);
    try os.setsockopt(sock_fd, os.SOL.SOCKET, os.SO.RCVTIMEO, comptime &mem.toBytes(sock_timeout));
    try os.setsockopt(sock_fd, os.SOL.SOCKET, os.SO.SNDTIMEO, comptime &mem.toBytes(sock_timeout));
    try os.connect(sock_fd, @ptrCast(*const os.sockaddr, &sock_addr), @sizeOf(os.sockaddr.in));
//    catch |err| switch (err) {
//        error.ConnectionPending => {
//            return err;
//        },
//        else => return err,
//    };
}

/// TODO: Clean this up.
pub fn panic(msg: []const u8, _: ?*std.builtin.StackTrace, _: ?usize) noreturn {
    _ = os.write(os.STDERR_FILENO, msg) catch unreachable;
    os.exit(1);
}
