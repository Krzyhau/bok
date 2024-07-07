const std = @import("std");

const Quaternion = @This();
const Vector3 = @import("Vector3.zig");
const Matrix = @import("Matrix.zig");

const PI = 3.14159265358979323846;
const DEG_2_RAD = PI / 180.0;
const RAD_2_DEG = 180.0 / PI;

x: f32,
y: f32,
z: f32,
w: f32,

pub fn identity() Quaternion {
    return .{
        .x = 0,
        .y = 0,
        .z = 0,
        .w = 1,
    };
}

pub fn from_axis_angle(axis: Vector3, angle: f32) Quaternion {
    const c = std.math.cos(angle * DEG_2_RAD * 0.5);
    const s = std.math.sin(angle * DEG_2_RAD * 0.5);

    const axis_norm = axis.norm();

    return .{
        .x = axis_norm.x * s,
        .y = axis_norm.y * s,
        .z = axis_norm.z * s,
        .w = c,
    };
}

pub fn from_euler_angles(pitch: f32, yaw: f32, roll: f32) Quaternion {
    const halfRollRad = roll * 0.5 * std.math.pi / 180.0;
    const halfPitchRad = pitch * 0.5 * std.math.pi / 180.0;
    const halfYawRad = yaw * 0.5 * std.math.pi / 180.0;

    const cr = std.math.cos(halfRollRad);
    const sr = std.math.sin(halfRollRad);
    const cp = std.math.cos(halfPitchRad);
    const sp = std.math.sin(halfPitchRad);
    const cy = std.math.cos(halfYawRad);
    const sy = std.math.sin(halfYawRad);

    // euler 312 (z/roll then x/pitch then y/yaw)
    return .{
        .x = cr * sp * cy + sr * cp * sy,
        .y = cr * cp * sy - sr * sp * cy,
        .z = sr * cp * cy - cr * sp * sy,
        .w = cr * cp * cy + sr * sp * sy,
    };
}

pub fn from_euler_vector(euler: Vector3) Quaternion {
    return from_euler_angles(euler.x, euler.y, euler.z);
}

pub fn mul(a: Quaternion, b: Quaternion) Quaternion {
    return .{
        .x = a.w * b.x + a.x * b.w + a.y * b.z - a.z * b.y,
        .y = a.w * b.y + a.y * b.w + a.z * b.x - a.x * b.z,
        .z = a.w * b.z + a.z * b.w + a.x * b.y - a.y * b.x,
        .w = a.w * b.w - a.x * b.x - a.y * b.y - a.z * b.z,
    };
}

pub fn to_euler(q: Quaternion) Vector3 {
    const r11 = 2 * (q.x * q.z + q.w * q.y);
    const r12 = q.w * q.w - q.x * q.x - q.y * q.y + q.z * q.z;
    const r21 = -2 * (q.y * q.z - q.w * q.x);
    const r31 = 2 * (q.x * q.y + q.w * q.z);
    const r32 = q.w * q.w - q.x * q.x + q.y * q.y - q.z * q.z;

    const x = std.math.asin(r21);
    const y = std.math.atan2(r11, r12);
    const z = std.math.atan2(r31, r32);

    return .{ .x = x * RAD_2_DEG, .y = y * RAD_2_DEG, .z = z * RAD_2_DEG };
}

pub fn inverse(q: Quaternion) Quaternion {
    return .{
        .x = -q.x,
        .y = -q.y,
        .z = -q.z,
        .w = q.w,
    };
}

pub fn dot(a: Quaternion, b: Quaternion) f32 {
    return a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w;
}

pub fn lerp(a: Quaternion, b: Quaternion, t: f32) Quaternion {
    return .{
        .x = t * a.x + (1.0 - t) * b.x,
        .y = t * a.y + (1.0 - t) * b.y,
        .z = t * a.z + (1.0 - t) * b.z,
        .w = t * a.w + (1.0 - t) * b.w,
    };
}

pub fn rotate_vector(q: Quaternion, v: Vector3) Vector3 {
    const qInv = inverse(q);
    const qV = Quaternion{ .x = v.x, .y = v.y, .z = v.z, .w = 0 };
    const qVp = q.mul(qV).mul(qInv);

    return .{ .x = qVp.x, .y = qVp.y, .z = qVp.z };
}

pub fn to_matrix(q: Quaternion) Matrix {
    const x2 = q.x + q.x;
    const y2 = q.y + q.y;
    const z2 = q.z + q.z;

    const wx2 = q.w * x2;
    const wy2 = q.w * y2;
    const wz2 = q.w * z2;
    const xx2 = q.x * x2;
    const xy2 = q.x * y2;
    const xz2 = q.x * z2;
    const yy2 = q.y * y2;
    const yz2 = q.y * z2;
    const zz2 = q.z * z2;

    return .{
        .m = .{
            .{ 1 - (yy2 + zz2), xy2 - wz2, xz2 + wy2, 0 },
            .{ xy2 + wz2, 1 - (xx2 + zz2), yz2 - wx2, 0 },
            .{ xz2 - wy2, yz2 + wx2, 1 - (xx2 + yy2), 0 },
            .{ 0, 0, 0, 1 },
        },
    };
}
