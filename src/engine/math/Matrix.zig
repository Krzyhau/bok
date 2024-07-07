const std = @import("std");

const Vector3 = @import("Vector3.zig");

const Matrix = @This();

m: [4][4]f32,

pub fn identity() Matrix {
    return .{
        .m = .{
            .{ 1, 0, 0, 0 },
            .{ 0, 1, 0, 0 },
            .{ 0, 0, 1, 0 },
            .{ 0, 0, 0, 1 },
        },
    };
}

pub fn translate(x: f32, y: f32, z: f32) Matrix {
    return .{
        .m = .{
            .{ 1, 0, 0, x },
            .{ 0, 1, 0, y },
            .{ 0, 0, 1, z },
            .{ 0, 0, 0, 1 },
        },
    };
}

pub fn scale(x: f32, y: f32, z: f32) Matrix {
    return .{
        .m = .{
            .{ x, 0, 0, 0 },
            .{ 0, y, 0, 0 },
            .{ 0, 0, z, 0 },
            .{ 0, 0, 0, 1 },
        },
    };
}

pub fn rotate_axis(axis: Vector3, angle: f32) Matrix {
    const x = axis.x;
    const y = axis.y;
    const z = axis.z;

    const c = std.math.cos(angle);
    const s = std.math.sin(angle);

    return .{
        .m = .{
            .{ x * x * (1 - c) + c, x * y * (1 - c) - z * s, x * z * (1 - c) + y * s, 0 },
            .{ y * x * (1 - c) + z * s, y * y * (1 - c) + c, y * z * (1 - c) - x * s, 0 },
            .{ z * x * (1 - c) - y * s, z * y * (1 - c) + x * s, z * z * (1 - c) + c, 0 },
            .{ 0, 0, 0, 1 },
        },
    };
}

pub fn mul(a: Matrix, b: Matrix) Matrix {
    var result: Matrix = undefined;
    inline for (0..4) |i| {
        inline for (0..4) |j| {
            result.m[i][j] =
                a.m[i][0] * b.m[0][j] +
                a.m[i][1] * b.m[1][j] +
                a.m[i][2] * b.m[2][j] +
                a.m[i][3] * b.m[3][j];
        }
    }
    return result;
}

pub fn transform(m: Matrix, v: Vector3) Vector3 {
    return .{
        .x = m.m[0][0] * v.x + m.m[0][1] * v.y + m.m[0][2] * v.z + m.m[0][3],
        .y = m.m[1][0] * v.x + m.m[1][1] * v.y + m.m[1][2] * v.z + m.m[1][3],
        .z = m.m[2][0] * v.x + m.m[2][1] * v.y + m.m[2][2] * v.z + m.m[2][3],
    };
}
