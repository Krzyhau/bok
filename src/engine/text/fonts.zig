const load = @import("font_reader.zig").FontReader.read;

pub const classic = load("classic");
pub const small = load("small");
