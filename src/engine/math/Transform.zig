const std = @import("std");

const Transform = @This();

const Vector3 = @import("Vector3.zig");
const Quaternion = @import("Quaternion.zig");
const Matrix = @import("Matrix.zig");

position: Vector3,
rotation: Quaternion,

pub fn identity() Transform {
    return .{
        .position = .{ .x = 0, .y = 0, .z = 0 },
        .rotation = Quaternion.identity(),
    };
}

pub fn local_to_world_matrix(transform: Transform) Matrix {
    const translation = Matrix.translate(transform.position.x, transform.position.y, transform.position.z);
    const rotation = transform.rotation.to_matrix();
    return translation.mul(rotation);
}

pub fn world_to_local_matrix(transform: Transform) Matrix {
    const rotation = transform.rotation.inverse().to_matrix();
    const translation = Matrix.translate(-transform.position.x, -transform.position.y, -transform.position.z);
    return rotation.mul(translation);
}

pub fn forward(transform: Transform) Vector3 {
    return transform.rotation.rotate_vector(.{ .x = 0, .y = 0, .z = 1 });
}

pub fn right(transform: Transform) Vector3 {
    return transform.rotation.rotate_vector(.{ .x = 1, .y = 0, .z = 0 });
}

pub fn up(transform: Transform) Vector3 {
    return transform.rotation.rotate_vector(.{ .x = 0, .y = 1, .z = 0 });
}
