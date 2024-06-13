const Display = @import("display.zig");
const Input = @import("input.zig");

const FontRenderer = @import("text/font_renderer.zig");
const Fonts = @import("text/fonts.zig");

const Rasterizer = @import("rendering/rasterizer.zig");

const Vector3 = @import("math/Vector3.zig");
const Vector2i = @import("math/Vector2i.zig");

var player_pos = Vector2i{ .x = 0, .y = 30 };

pub fn process() void {
    process_input();

    Display.clear();

    Display.set_pixel(@bitCast(player_pos.x), @bitCast(player_pos.y), true);
    FontRenderer.print("This is a test!", Fonts.small, 5, 5, true);

    const triangle: [3]Vector3 = .{
        .{ .x = 2, .y = 20, .z = 0 },
        .{ .x = @floatFromInt(player_pos.x), .y = @floatFromInt(player_pos.y), .z = 0 },
        .{ .x = 40, .y = 30, .z = 0 },
    };

    Rasterizer.rasterize_triangle(triangle, .{
        .thickness = 2,
        .filled = false,
        .screen_set = true,
    });
}

var delay: usize = 0;

fn process_input() void {
    if (delay == 0) {
        delay = 2;
    } else {
        delay -= 1;
        return;
    }

    if (Input.is_key_held(.two)) {
        player_pos.y -= 1;
    }
    if (Input.is_key_held(.eight)) {
        player_pos.y += 1;
    }
    if (Input.is_key_held(.four)) {
        player_pos.x -= 1;
    }
    if (Input.is_key_held(.six)) {
        player_pos.x += 1;
    }
}
