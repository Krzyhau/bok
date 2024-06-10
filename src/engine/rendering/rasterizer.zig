const std = @import("std");

const Display = @import("../display.zig");

const Vector2 = @import("../math/Vector2.zig");
const Vector3 = @import("../math/Vector3.zig");

pub fn rasterize_triangle(a: Vector3, b: Vector3, c: Vector3) void {
    const screen_a = Vector2{ .x = a.x, .y = a.y };
    const screen_b = Vector2{ .x = b.x, .y = b.y };
    const screen_c = Vector2{ .x = c.x, .y = c.y };

    const dir_1 = screen_b.sub(screen_a).norm();
    const dir_2 = screen_c.sub(screen_b).norm();
    const dir_3 = screen_a.sub(screen_c).norm();

    const normal_1 = Vector2{ .x = dir_1.y, .y = -dir_1.x };
    const normal_2 = Vector2{ .x = dir_2.y, .y = -dir_2.x };
    const normal_3 = Vector2{ .x = dir_3.y, .y = -dir_3.x };

    const d1 = normal_1.dot(screen_a);
    const d2 = normal_2.dot(screen_b);
    const d3 = normal_3.dot(screen_c);

    const min_x: isize = @intFromFloat(@floor(@min(screen_a.x, @min(screen_b.x, screen_c.x))));
    const max_x: isize = @intFromFloat(@floor(@max(screen_a.x, @max(screen_b.x, screen_c.x))));
    const min_y: isize = @intFromFloat(@ceil(@min(screen_a.y, @min(screen_b.y, screen_c.y))));
    const max_y: isize = @intFromFloat(@ceil(@max(screen_a.y, @max(screen_b.y, screen_c.y))));

    const min_point = Vector2{ .x = @floatFromInt(min_x), .y = @floatFromInt(min_y) };

    const min_point_d_1 = normal_1.dot(min_point) - d1;
    const min_point_d_2 = normal_2.dot(min_point) - d2;
    const min_point_d_3 = normal_3.dot(min_point) - d3;

    const width: usize = @bitCast(max_x - min_x + 1);
    const height: usize = @bitCast(max_y - min_y + 1);

    for (0..width) |ix| {
        for (0..height) |iy| {
            const x: f32 = @floatFromInt(ix);
            const y: f32 = @floatFromInt(iy);

            const d_1 = min_point_d_1 + normal_1.x * x + normal_1.y * y;
            const d_2 = min_point_d_2 + normal_2.x * x + normal_2.y * y;
            const d_3 = min_point_d_3 + normal_3.x * x + normal_3.y * y;

            const is_inside = d_1 >= 0 and d_2 >= 0 and d_3 >= 0;
            if (is_inside) {
                const pixel_x: usize = @as(usize, @bitCast(min_x)) + ix;
                const pixel_y: usize = @as(usize, @bitCast(min_y)) + iy;
                Display.set_pixel(pixel_x, pixel_y, true);
            }
        }
    }
}
