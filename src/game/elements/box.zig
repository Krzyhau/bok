const Vector3 = @import("../../engine/math/Vector3.zig");
const Transform = @import("../../engine/math/Transform.zig");
const Camera = @import("../../engine/rendering/camera.zig");
const Rasterizer = @import("../../engine/rendering/rasterizer.zig");

const Box = @This();

transform: Transform = Transform.identity(),
size: Vector3 = .{ .x = 1, .y = 1, .z = 5 },

pub fn render(self: Box) void {
    const screen_space_vertices = self.get_screen_space_vertices();

    const all_quad_indices = get_quad_indices_to_render();

    for (all_quad_indices) |quad_indices| {
        const vertices = get_vertices_from_indices(screen_space_vertices, quad_indices);
        Rasterizer.rasterize_quad(vertices, .{
            .screen_set = true,
            .thickness = 0.0,
            .filled = true,
        });
    }
}

fn get_screen_space_vertices(self: Box) [8]Vector3 {
    const world_vertices = self.get_world_vertices();

    var screen_space_vertices: [8]Vector3 = undefined;

    for (world_vertices, 0..) |vertex, i| {
        screen_space_vertices[i] = Camera.world_to_screen(vertex);
    }

    return screen_space_vertices;
}

fn get_world_vertices(self: Box) [8]Vector3 {
    const local_vertices = self.get_local_vertices();

    var world_vertices: [8]Vector3 = undefined;

    for (local_vertices, 0..) |vertex, i| {
        world_vertices[i] = self.transform.local_to_world_matrix().transform(vertex);
    }

    return world_vertices;
}

fn get_local_vertices(self: Box) [8]Vector3 {
    return .{
        .{ .x = -self.size.x * 0.5, .y = -self.size.y * 0.5, .z = -self.size.z * 0.5 },
        .{ .x = -self.size.x * 0.5, .y = -self.size.y * 0.5, .z = self.size.z * 0.5 },
        .{ .x = -self.size.x * 0.5, .y = self.size.y * 0.5, .z = -self.size.z * 0.5 },
        .{ .x = -self.size.x * 0.5, .y = self.size.y * 0.5, .z = self.size.z * 0.5 },
        .{ .x = self.size.x * 0.5, .y = -self.size.y * 0.5, .z = -self.size.z * 0.5 },
        .{ .x = self.size.x * 0.5, .y = -self.size.y * 0.5, .z = self.size.z * 0.5 },
        .{ .x = self.size.x * 0.5, .y = self.size.y * 0.5, .z = -self.size.z * 0.5 },
        .{ .x = self.size.x * 0.5, .y = self.size.y * 0.5, .z = self.size.z * 0.5 },
    };
}

fn get_quad_indices_to_render() [6][4]usize {
    return .{
        .{ 0, 1, 3, 2 },
        .{ 1, 5, 7, 3 },
        .{ 5, 4, 6, 7 },
        .{ 0, 4, 6, 2 },
        .{ 0, 4, 5, 1 },
        .{ 2, 3, 7, 6 },
    };
}

fn get_vertices_from_indices(vertices: [8]Vector3, indices: [4]usize) [4]Vector3 {
    var vertices_from_indices: [4]Vector3 = undefined;

    for (vertices_from_indices, 0..) |_, i| {
        vertices_from_indices[i] = vertices[indices[i]];
    }

    return vertices_from_indices;
}
