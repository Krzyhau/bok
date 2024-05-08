const std = @import("std");

pub const Display = struct {
    pub const width = 84;
    pub const height = 48;

    pixels: [width * height]bool,

    pub fn init() Display {
        return .{
            .pixels = [_]bool{false} ** (width * height),
        };
    }

    pub fn fill(self: *Display, value: bool) void {
        std.mem.set(bool, &self.pixels, value);
    }

    pub fn clear(self: *Display) void {
        self.fill(false);
    }

    pub fn set_pixel(self: *Display, x: usize, y: usize, value: bool) void {
        if (self.is_within_bounds(x, y)) {
            self.pixels[y * width + x] = value;
        }
    }

    pub fn get_pixel(self: Display, x: usize, y: usize) bool {
        if (self.is_within_bounds(x, y)) {
            return self.pixels[y * width + x];
        } else {
            return false;
        }
    }

    pub fn is_within_bounds(self: Display, x: usize, y: usize) bool {
        return x >= 0 and y >= 0 and x < self.width and y < self.height;
    }

    pub fn rect(self: *Display, x: usize, y: usize, rect_width: usize, rect_height: usize) void {
        for (x..(x + rect_width)) |i| {
            for (y..(y + rect_height)) |j| {
                self.set_pixel(i, j, true);
            }
        }
    }
};
