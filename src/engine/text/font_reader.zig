const std = @import("std");

const Font = @import("font.zig").Font;
const Character = @import("font.zig").Character;

const CharacterRecord = struct {
    char: u8,
    data: Character,
};

pub const FontReader = struct {
    const Self = @This();

    data: []const u8,
    pos: usize,

    pub fn read(font_name: []const u8) Font {
        const data = @embedFile(get_full_font_path(font_name));

        var font_reader: Self = .{
            .data = data,
            .pos = 0,
        };

        return font_reader.read_font();
    }

    fn get_full_font_path(comptime font_name: []const u8) []const u8 {
        return "fonts/" ++ font_name ++ ".txt";
    }

    fn read_font(self: *Self) Font {
        const line_height = self.read_number(',');
        const char_padding = self.read_number('\n');
        self.skip_to('\n');

        var font = Font.init();
        font.line_height = line_height;
        font.char_padding = char_padding;

        while (self.pos < self.data.len) {
            const character = self.read_character();

            font.characters[character.char] = character.data;
        }

        return font;
    }

    fn read_character(self: *Self) CharacterRecord {
        const char = self.read_u8_char();
        self.skip_to(',');

        const padding_x = self.read_number(',');
        const padding_y = self.read_number(',');
        const width = self.read_number(',');
        const height = self.read_number('\n');
        const texture_data = self.read_texture_data(width, height);
        self.skip_to('\n');

        const character: Character = .{
            .padding_x = padding_x,
            .padding_y = padding_y,
            .width = width,
            .height = height,
            .texture_data = &texture_data,
        };

        return .{
            .char = char,
            .data = character,
        };
    }

    fn read_texture_data(self: *Self, comptime width: usize, comptime height: usize) [width * height]bool {
        var texture_data: [width * height]bool = undefined;
        for (0..height) |y| {
            for (0..width) |x| {
                const char = self.read_u8_char();

                texture_data[y * width + x] = char != ' ';
            }
            self.skip_to('\n');
        }
        return texture_data;
    }

    fn read_u8_char(self: *Self) u8 {
        const character = self.data[self.pos];
        self.pos += 1;
        return character;
    }

    fn read_number(self: *Self, post_separator: u8) usize {
        @setEvalBranchQuota(100000);
        const index_of_separator = std.mem.indexOfScalarPos(u8, self.data, self.pos, post_separator) orelse unreachable;
        const number_str = self.data[self.pos..index_of_separator];
        const number = std.fmt.parseInt(usize, number_str, 10) catch 0;
        self.pos = index_of_separator + 1;
        return number;
    }

    fn skip_to(self: *Self, character: u8) void {
        @setEvalBranchQuota(100000);

        const skip_to_index = std.mem.indexOfScalarPos(u8, self.data, self.pos, character) orelse unreachable;
        self.pos = skip_to_index + 1;
    }
};
