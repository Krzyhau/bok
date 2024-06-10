fn Vector(comptime N: u8, comptime T: type) type {
    return struct {
        const Self = @This();

        inline fn data(self: Self) [N]T {
            return (union { self: Self, array: [N]T }{ .self = self }).array;
        }

        pub fn add(a: Self, b: Self) Self {
            var result: Self = undefined;
            inline for (N) |i| result.data()[i] = a.data()[i] + b.data()[i];
            return result;
        }

        pub fn sub(a: Self, b: Self) Self {
            var result: Self = undefined;
            inline for (N) |i| result.data()[i] = a.data()[i] - b.data()[i];
            return result;
        }

        pub fn mul(a: Self, b: Self) Self {
            var result: Self = undefined;
            inline for (N) |i| result.data()[i] = a.data()[i] * b.data()[i];
            return result;
        }

        pub fn div(a: Self, b: Self) Self {
            var result: Self = undefined;
            inline for (N) |i| result.data()[i] = a.data()[i] / b.data()[i];
            return result;
        }

        pub fn scale(a: Self, s: T) Self {
            var result: Self = undefined;
            inline for (N) |i| result.data()[i] = a.data()[i] * s;
            return result;
        }

        pub fn dot(a: Self, b: Self) T {
            var result: T = 0;
            inline for (N) |i| result += a.data()[i] * b.data()[i];
            return result;
        }

        pub fn len(a: Self) T {
            return @sqrt(a.dot(a));
        }

        pub fn norm(a: Self) Self {
            return a.scale(1.0 / a.len());
        }
    };
}

pub const Vector2 = struct {
    x: f32 = 0,
    y: f32 = 0,

    usingnamespace Vector(2, f32);
};

pub const Vector3 = struct {
    x: f32 = 0,
    y: f32 = 0,
    z: f32 = 0,

    usingnamespace Vector(3, f32);
};

pub const Vector2i = struct {
    x: isize = 0,
    y: isize = 0,

    usingnamespace Vector(2, isize);
};

pub const Vector3i = struct {
    x: isize = 0,
    y: isize = 0,
    z: isize = 0,

    usingnamespace Vector(3, isize);
};
