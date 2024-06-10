const Display = @import("display.zig");
const Input = @import("input.zig");

const FontRenderer = @import("text/font_renderer.zig");
const Fonts = @import("text/fonts.zig");

const Rasterizer = @import("rendering/rasterizer.zig");

const Vector2i = @import("math/Vector2i.zig");

var player_pos = Vector2i{ .x = 0, .y = 30 };

pub fn process() void {
    if (Input.is_key_just_pressed(.two)) {
        player_pos.y -= 1;
    }
    if (Input.is_key_just_pressed(.eight)) {
        player_pos.y += 1;
    }
    if (Input.is_key_just_pressed(.four)) {
        player_pos.x -= 1;
    }
    if (Input.is_key_just_pressed(.six)) {
        player_pos.x += 1;
    }

    Display.clear();

    Display.set_pixel(@bitCast(player_pos.x), @bitCast(player_pos.y), true);
    FontRenderer.print("This is a test!", Fonts.classic, 5, 5, true);

    Rasterizer.rasterize_triangle(
        .{ .x = 2, .y = 20, .z = 0 },
        .{ .x = @floatFromInt(player_pos.x), .y = @floatFromInt(player_pos.y), .z = 0 },
        .{ .x = 40, .y = 17, .z = 0 },
    );
}
