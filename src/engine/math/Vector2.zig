const Vector2 = @This();

x: f32,
y: f32,

pub fn init(x: f32, y: f32) Vector2 {
    return .{
        .x = x,
        .y = y,
    };
}

pub fn add(a: Vector2, b: Vector2) Vector2 {
    return .{
        .x = a.x + b.x,
        .y = a.y + b.y,
    };
}

pub fn sub(a: Vector2, b: Vector2) Vector2 {
    return .{
        .x = a.x - b.x,
        .y = a.y - b.y,
    };
}

pub fn mul(a: Vector2, b: Vector2) Vector2 {
    return .{
        .x = a.x * b.x,
        .y = a.y * b.y,
    };
}

pub fn div(a: Vector2, b: Vector2) Vector2 {
    return .{
        .x = a.x / b.x,
        .y = a.y / b.y,
    };
}

pub fn scale(a: Vector2, s: f32) Vector2 {
    return .{
        .x = a.x * s,
        .y = a.y * s,
    };
}

pub fn dot(a: Vector2, b: Vector2) f32 {
    return a.x * b.x + a.y * b.y;
}

pub fn len(a: Vector2) f32 {
    return @sqrt(a.dot(a));
}

pub fn norm(a: Vector2) Vector2 {
    const length = a.len();
    if (length == 0.0) return .{ .x = 0, .y = 0 };
    return a.scale(1.0 / length);
}
