const std = @import("std");
const SDL_IO = @import("io/sdl_io.zig");

pub fn main() !void {
    var sdl_io = try create_sdl_io_controller();
    sdl_io.start_loop();
    sdl_io.deinit();
}

pub fn create_sdl_io_controller() !SDL_IO.Controller {
    return SDL_IO.Controller.init(.{
        .window_name = "BOK (SDL simulation)",
        .render_scale = 10,
        .fill_color = .{ .r = 67, .g = 82, .b = 61 },
        .clear_color = .{ .r = 199, .g = 240, .b = 216 },
    }) catch {
        std.debug.print("Unable to initialize SDL I/O: {s}", .{SDL_IO.SDL.SDL_GetError()});
        return error.SDLInitializationFailed;
    };
}
