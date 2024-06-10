const Vector2i = @This();

x: isize,
y: isize,

pub fn init(x: isize, y: isize) Vector2i {
    return .{
        .x = x,
        .y = y,
    };
}

pub fn add(a: Vector2i, b: Vector2i) Vector2i {
    return .{
        .x = a.x + b.x,
        .y = a.y + b.y,
    };
}

pub fn sub(a: Vector2i, b: Vector2i) Vector2i {
    return .{
        .x = a.x - b.x,
        .y = a.y - b.y,
    };
}

pub fn mul(a: Vector2i, b: Vector2i) Vector2i {
    return .{
        .x = a.x * b.x,
        .y = a.y * b.y,
    };
}

pub fn div(a: Vector2i, b: Vector2i) Vector2i {
    return .{
        .x = a.x / b.x,
        .y = a.y / b.y,
    };
}

pub fn scale(a: Vector2i, s: isize) Vector2i {
    return .{
        .x = a.x * s,
        .y = a.y * s,
    };
}

pub fn dot(a: Vector2i, b: Vector2i) isize {
    return a.x * b.x + a.y * b.y;
}

pub fn len(a: Vector2i) isize {
    return @sqrt(a.dot(a));
}

pub fn norm(a: Vector2i) Vector2i {
    return a.scale(1.0 / a.len());
}
