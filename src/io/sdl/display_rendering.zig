const SDL = @import("sdl.zig").SDL;
const Display = @import("../../engine/display.zig");

const Controller = @import("controller.zig");

pub fn render_display_pixels() void {
    for (0..Display.width) |x| {
        for (0..Display.height) |y| {
            const color = switch (Display.get_pixel(x, y)) {
                true => Controller.settings.fill_color,
                false => Controller.settings.clear_color,
            };

            render_pixel_rect(x, y, color);
        }
    }
}

fn render_pixel_rect(x: usize, y: usize, color: SDL.SDL_Color) void {
    const rect: SDL.SDL_Rect = .{
        .x = @intCast(x * Controller.settings.render_scale),
        .y = @intCast(y * Controller.settings.render_scale),
        .w = @intCast(Controller.settings.render_scale),
        .h = @intCast(Controller.settings.render_scale),
    };

    _ = SDL.SDL_SetRenderDrawColor(Controller.renderer, color.r, color.g, color.b, 255);
    _ = SDL.SDL_RenderFillRect(Controller.renderer, &rect);
}
