const Display = @import("display.zig");
const Input = @import("input.zig");

const FontRenderer = @import("text/font_renderer.zig");
const Fonts = @import("text/fonts.zig");

const Vector3 = @import("math/vector.zig").Vector3;

var player_pos = Vector3.init(0, 0, 0);

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

    const x: isize = @intFromFloat(player_pos.x);
    const y: isize = @intFromFloat(player_pos.y);

    Display.set_pixel(@bitCast(x), @bitCast(y), true);
    FontRenderer.print("This is a test!", Fonts.classic, 5, 5, true);
}
