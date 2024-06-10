const Vector3 = @This();

x: f32,
y: f32,
z: f32,

pub fn init(x: f32, y: f32, z: f32) Vector3 {
    return .{
        .x = x,
        .y = y,
        .z = z,
    };
}

pub fn add(a: Vector3, b: Vector3) Vector3 {
    return .{
        .x = a.x + b.x,
        .y = a.y + b.y,
        .z = a.z + b.z,
    };
}

pub fn sub(a: Vector3, b: Vector3) Vector3 {
    return .{
        .x = a.x - b.x,
        .y = a.y - b.y,
        .z = a.z - b.z,
    };
}

pub fn mul(a: Vector3, b: Vector3) Vector3 {
    return .{
        .x = a.x * b.x,
        .y = a.y * b.y,
        .z = a.z * b.z,
    };
}

pub fn div(a: Vector3, b: Vector3) Vector3 {
    return .{
        .x = a.x / b.x,
        .y = a.y / b.y,
        .z = a.z / b.z,
    };
}

pub fn scale(a: Vector3, s: f32) Vector3 {
    return .{
        .x = a.x * s,
        .y = a.y * s,
        .z = a.z * s,
    };
}

pub fn dot(a: Vector3, b: Vector3) f32 {
    return a.x * b.x + a.y * b.y + a.z * b.z;
}

pub fn cross(a: Vector3, b: Vector3) Vector3 {
    return .{
        .x = a.y * b.z - a.z * b.y,
        .y = a.z * b.x - a.x * b.z,
        .z = a.x * b.y - a.y * b.x,
    };
}

pub fn len(a: Vector3) f32 {
    return @sqrt(a.dot(a));
}

pub fn norm(a: Vector3) Vector3 {
    return a.scale(1.0 / a.len());
}
