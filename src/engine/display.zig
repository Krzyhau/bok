const std = @import("std");

pub const width = 84;
pub const height = 48;

pub const aspect_ratio = @as(comptime_float, @floatFromInt(width)) / @as(comptime_float, @floatFromInt(height));

var pixels = [_]bool{false} ** (width * height);

pub fn fill(value: bool) void {
    @memset(&pixels, value);
}

pub fn clear() void {
    fill(false);
}

pub fn set_pixel(x: usize, y: usize, value: bool) void {
    if (is_within_bounds(x, y)) {
        pixels[coords_to_index(x, y)] = value;
    }
}

pub fn get_pixel(x: usize, y: usize) bool {
    if (is_within_bounds(x, y)) {
        return pixels[coords_to_index(x, y)];
    } else {
        return false;
    }
}

fn coords_to_index(x: usize, y: usize) usize {
    return y * width + x;
}

pub fn is_within_bounds(x: usize, y: usize) bool {
    return x >= 0 and y >= 0 and x < width and y < height;
}

pub fn rect(x: usize, y: usize, rect_width: usize, rect_height: usize) void {
    for (x..(x + rect_width)) |i| {
        for (y..(y + rect_height)) |j| {
            set_pixel(i, j, true);
        }
    }
}
