const Display = @import("../display.zig");
const Font = @import("font.zig").Font;
const Character = @import("font.zig").Character;

pub fn print(text: []const u8, font: Font, x: usize, y: usize, fill: bool) void {
    var current_x = x;
    var current_y = y;

    for (text) |char| {
        if (char == '\n') {
            current_y += font.line_height;
            current_x = x;
            continue;
        }

        const character = font.characters[char];

        render_character(character, current_x, current_y, fill);

        current_x += character.padding_x + character.width + font.char_padding;
    }
}

fn render_character(character: Character, x: usize, y: usize, fill: bool) void {
    if (character.texture_data.len == 0) {
        Display.set_pixel(10, 10, true);
        return;
    }

    for (0..character.height) |c_y| {
        for (0..character.width) |c_x| {
            if (character.texture_data[c_y * character.width + c_x]) {
                Display.set_pixel(x + character.padding_x + c_x, y + character.padding_y + c_y, fill);
            }
        }
    }
}
