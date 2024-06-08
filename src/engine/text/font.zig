const std = @import("std");

pub const Font = struct {
    line_height: usize,
    char_padding: usize,
    characters: [256]Character,

    pub fn init() Font {
        var characters: [256]Character = undefined;
        for (&characters) |*char| {
            char.* = Character.init();
        }

        return .{
            .line_height = 0,
            .char_padding = 0,
            .characters = characters,
        };
    }
};

pub const Character = struct {
    padding_x: usize,
    padding_y: usize,
    width: usize,
    height: usize,
    texture_data: []const bool,

    pub fn init() Character {
        return .{
            .padding_x = 0,
            .padding_y = 0,
            .width = 0,
            .height = 0,
            .texture_data = &[_]bool{},
        };
    }
};
