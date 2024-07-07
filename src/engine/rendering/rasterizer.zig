const std = @import("std");

const Display = @import("../display.zig");

const Vector2 = @import("../math/Vector2.zig");
const Vector3 = @import("../math/Vector3.zig");

const Settings = struct {
    thickness: f32 = 0.5,
    filled: bool = true,
    screen_set: bool = true,
};

pub fn rasterize_line(vertices: [2]Vector3, settings: Settings) void {
    rasterize_polygon(2, vertices, settings);
}

pub fn rasterize_triangle(vertices: [3]Vector3, settings: Settings) void {
    rasterize_polygon(3, vertices, settings);
}

pub fn rasterize_quad(vertices: [4]Vector3, settings: Settings) void {
    rasterize_polygon(4, vertices, settings);
}

pub fn rasterize_polygon(comptime N: comptime_int, vertices: [N]Vector3, settings: Settings) void {
    if (is_polygon_behind_screen_space(N, vertices)) return;

    var screen_vertices: [N]Vector2 = undefined;
    inline for (vertices, 0..) |vertex, i| screen_vertices[i] = Vector2{ .x = vertex.x, .y = vertex.y };

    const planes = get_shape_planes(N, screen_vertices);

    const bounds = get_shape_bounds(N, vertices, settings);
    const min_point = Vector2{ .x = @floatFromInt(bounds.min_x), .y = @floatFromInt(bounds.min_y) };

    const width: usize = @intCast(bounds.max_x - bounds.min_x + 1);
    const height: usize = @intCast(bounds.max_y - bounds.min_y + 1);

    var min_point_distances: [N]f32 = undefined;
    inline for (0..N) |i| min_point_distances[i] = point_distance_to_edge_plane(min_point, planes[i]);

    const half_thickness = settings.thickness * 0.5;

    for (0..width) |ix| {
        for (0..height) |iy| {
            const x: f32 = @floatFromInt(ix);
            const y: f32 = @floatFromInt(iy);

            var is_in_inner = true;
            var is_in_outer = true;

            inline for (0..vertices.len) |i| {
                const d = min_point_distances[i] + planes[i].normal.x * x + planes[i].normal.y * y;
                if (d > -half_thickness) is_in_inner = false;
                if (d > half_thickness) is_in_outer = false;
            }

            if (is_in_outer and (settings.filled or !is_in_inner)) {
                const pixel_x: usize = @as(usize, @intCast(bounds.min_x)) + ix;
                const pixel_y: usize = @as(usize, @intCast(bounds.min_y)) + iy;
                Display.set_pixel(pixel_x, pixel_y, settings.screen_set);
            }
        }
    }
}

fn is_polygon_behind_screen_space(comptime N: comptime_int, vertices: [N]Vector3) bool {
    for (vertices) |vertex| {
        if (vertex.z > 0.0) return false;
    }
    return true;
}

fn get_shape_planes(comptime N: comptime_int, screen_vertices: [N]Vector2) [N]PolygonEdgePlane {
    const shape_clockwise = is_shape_clockwise(N, screen_vertices);

    var planes: [N]PolygonEdgePlane = undefined;
    inline for (0..N) |i| {
        planes[i] = get_edge_plane_from_points(screen_vertices[i], screen_vertices[(i + 1) % N], !shape_clockwise);
    }
    return planes;
}

fn is_shape_clockwise(comptime N: comptime_int, screen_vertices: [N]Vector2) bool {
    var sum: f32 = 0.0;
    inline for (0..N) |i| {
        const p1 = screen_vertices[i];
        const p2 = screen_vertices[(i + 1) % N];
        sum += (p2.x - p1.x) * (p2.y + p1.y);
    }
    return sum > 0.0;
}

const PolygonEdgePlane = struct {
    normal: Vector2,
    distance: f32,
};

fn get_edge_plane_from_points(a: Vector2, b: Vector2, reversed: bool) PolygonEdgePlane {
    const dir = a.sub(b).norm();
    const dir_signed = if (reversed) dir.scale(-1.0) else dir;
    const normal = Vector2{ .x = dir_signed.y, .y = -dir_signed.x };
    const distance = normal.dot(a);

    return .{ .normal = normal, .distance = distance };
}

fn point_distance_to_edge_plane(point: Vector2, plane: PolygonEdgePlane) f32 {
    return plane.normal.dot(point) - plane.distance;
}

const ShapeBounds = struct {
    min_x: usize,
    max_x: usize,
    min_y: usize,
    max_y: usize,
};

fn get_shape_bounds(comptime N: comptime_int, vertices: [N]Vector3, settings: Settings) ShapeBounds {
    var min_x_real: f32 = Display.width;
    var max_x_real: f32 = 0.0;
    var min_y_real: f32 = Display.height;
    var max_y_real: f32 = 0.0;

    inline for (0..N) |i| {
        const vertex = vertices[i];
        if (vertex.x < min_x_real) min_x_real = vertex.x;
        if (vertex.x > max_x_real) max_x_real = vertex.x;
        if (vertex.y < min_y_real) min_y_real = vertex.y;
        if (vertex.y > max_y_real) max_y_real = vertex.y;
    }

    const min_x_unclamped: isize = @intFromFloat(@floor(min_x_real - settings.thickness));
    const max_x_unclamped: isize = @intFromFloat(@floor(max_x_real + settings.thickness));
    const min_y_unclamped: isize = @intFromFloat(@ceil(min_y_real - settings.thickness));
    const max_y_unclamped: isize = @intFromFloat(@ceil(max_y_real + settings.thickness));

    const max_x: usize = @intCast(@min(Display.width - 1, max_x_unclamped));
    const min_x: usize = @intCast(@min(@max(0, min_x_unclamped), max_x));
    const max_y: usize = @intCast(@min(Display.height - 1, max_y_unclamped));
    const min_y: usize = @intCast(@min(@max(0, min_y_unclamped), max_y));

    return .{
        .min_x = min_x,
        .max_x = max_x,
        .min_y = min_y,
        .max_y = max_y,
    };
}
