const std = @import("std");
const Transform = @import("../math/Transform.zig");
const Vector3 = @import("../math/Vector3.zig");
const Matrix = @import("../math/Matrix.zig");
const Display = @import("../display.zig");

const PI = 3.14159265358979323846;
const DEG_2_RAD = PI / 180.0;
const RAD_2_DEG = 180.0 / PI;

pub var transform: Transform = Transform.identity();
pub var field_of_view: f32 = 90.0;

pub fn world_to_screen(point: Vector3) Vector3 {
    const camera_space_point = transform.world_to_local_matrix().transform(point);

    const z = @max(camera_space_point.z, 0.001);
    const screen_delta = get_screen_space_dimensions();

    const normalized_screen_space_point: Vector3 = .{
        .x = camera_space_point.x / (z * screen_delta.x),
        .y = camera_space_point.y / (z * screen_delta.y),
        .z = 0.0,
    };

    return .{
        .x = (normalized_screen_space_point.x + 1.0) / 2.0 * Display.width,
        .y = (normalized_screen_space_point.y + 1.0) / 2.0 * Display.height,
        .z = camera_space_point.z,
    };
}

pub fn screen_to_world(point: Vector3) Vector3 {
    const normalized_screen_space_point = .{
        .x = (point.x / Display.width) * 2.0 - 1.0,
        .y = (point.y / Display.height) * 2.0 - 1.0,
        .z = 0.0,
    };

    const screen_delta = get_screen_space_dimensions();

    const camera_space_point: Vector3 = .{
        .x = normalized_screen_space_point.x * (point.z * screen_delta.x),
        .y = normalized_screen_space_point.y * (point.z * screen_delta.y),
        .z = point.z,
    };

    return transform.local_to_world_matrix().mul(camera_space_point);
}

fn get_screen_space_dimensions() Vector3 {
    const horizontal_delta = std.math.tan((field_of_view / 2.0) * DEG_2_RAD);
    const vertical_delta = horizontal_delta / Display.aspect_ratio;

    return .{
        .x = horizontal_delta,
        .y = vertical_delta,
        .z = 0.0,
    };
}
