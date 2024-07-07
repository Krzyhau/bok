const std = @import("std");

const Game = @import("game.zig");
const Input = @import("input.zig");

pub fn init() void {}

pub fn process() void {
    Input.process();
    Game.process();
}
