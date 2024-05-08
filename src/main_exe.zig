const std = @import("std");
const SDLIO = @import("io/sdl_io.zig");

const nokia_width = 84;
const nokia_height = 48;

pub fn main() !void {
    var sdl_io = SDLIO.Controller.init(.{
        .window_name = "BOK (SDL simulation)",
        .render_scale = 8,
        .fill_color = .{ .r = 67, .g = 82, .b = 61 },
        .clear_color = .{ .r = 199, .g = 240, .b = 216 },
    }) catch {
        std.debug.print("Unable to initialize SDL I/O: {s}", .{SDLIO.SDL.SDL_GetError()});
        return;
    };

    defer sdl_io.deinit();

    while (sdl_io.is_active) {
        sdl_io.process_events();
        sdl_io.update();
        sdl_io.render();

        SDLIO.SDL.SDL_Delay(17);
    }
}
