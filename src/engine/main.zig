const Game = @import("game.zig");
const Input = @import("input.zig");

pub fn process() void {
    Input.process();
    Game.process();
}
