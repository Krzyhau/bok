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
        self.pixels[y * width + x] = value;
    }

    pub fn get_pixel(self: *Display, x: usize, y: usize) bool {
        return self.pixels[y * width + x];
    }

    pub fn rect(self: *Display, x: usize, y: usize, rect_width: usize, rect_height: usize) void {
        for (x..(x + rect_width)) |i| {
            for (y..(y + rect_height)) |j| {
                self.set_pixel(i, j, true);
            }
        }
    }
};
