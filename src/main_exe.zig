const std = @import("std");
const SDL = @import("io/sdl/sdl.zig").SDL;
const SDLController = @import("io/sdl/controller.zig");

pub fn main() !void {
    try setup_and_activate();
    defer SDLController.deactivate();

    SDLController.start_loop();
}

pub fn setup_and_activate() !void {
    SDLController.settings = .{
        .window_name = "BOK (SDL simulation)",
        .render_scale = 10,
        .fill_color = .{ .r = 67, .g = 82, .b = 61 },
        .clear_color = .{ .r = 199, .g = 240, .b = 216 },
    };

    SDLController.activate() catch {
        std.debug.print("Unable to initialize SDL I/O: {s}", .{SDL.SDL_GetError()});
        return error.SDLInitializationFailed;
    };
}
