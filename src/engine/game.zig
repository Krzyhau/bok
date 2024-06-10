const Display = @import("display.zig");
const Input = @import("input.zig");

const FontRenderer = @import("text/font_renderer.zig");
const Fonts = @import("text/fonts.zig");

const Vector2i = @import("math/vector.zig").Vector2i;

var player_pos = Vector2i{ .x = 0, .y = 0 };

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
}
