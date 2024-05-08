const std = @import("std");
const SDL = @import("sdl.zig").SDL;
const Input = @import("../../engine/input.zig");
const KeyCode = Input.KeyCode;

pub fn register_key_press(key: SDL.SDL_Keycode) void {
    const key_code = map_sdl_input(key) orelse return;
    Input.press_key(key_code);
}

pub fn register_key_release(key: SDL.SDL_Keycode) void {
    const key_code = map_sdl_input(key) orelse return;
    Input.release_key(key_code);
}

pub fn map_sdl_input(sdl_key_code: SDL.SDL_Keycode) ?KeyCode {
    return switch (sdl_key_code) {
        // basic controls
        SDL.SDLK_KP_7 => KeyCode.one,
        SDL.SDLK_KP_8 => KeyCode.two,
        SDL.SDLK_KP_9 => KeyCode.three,
        SDL.SDLK_KP_4 => KeyCode.four,
        SDL.SDLK_KP_5 => KeyCode.five,
        SDL.SDLK_KP_6 => KeyCode.six,
        SDL.SDLK_KP_1 => KeyCode.seven,
        SDL.SDLK_KP_2 => KeyCode.eight,
        SDL.SDLK_KP_3 => KeyCode.nine,
        SDL.SDLK_KP_0 => KeyCode.star,
        SDL.SDLK_KP_PERIOD => KeyCode.zero,
        SDL.SDLK_KP_ENTER => KeyCode.hash,
        SDL.SDLK_BACKSPACE => KeyCode.c,
        SDL.SDLK_PAGEDOWN, SDL.SDLK_DOWN, SDL.SDLK_LEFT => KeyCode.scroll_left,
        SDL.SDLK_PAGEUP, SDL.SDLK_UP, SDL.SDLK_RIGHT => KeyCode.scroll_right,
        SDL.SDLK_RETURN => KeyCode.navi,
        SDL.SDLK_ESCAPE => KeyCode.power,

        // WSAD for movement
        SDL.SDLK_w => KeyCode.two,
        SDL.SDLK_s => KeyCode.eight,
        SDL.SDLK_a => KeyCode.four,
        SDL.SDLK_d => KeyCode.six,

        // additional binds that don't really make sense but eh
        SDL.SDLK_q => KeyCode.one,
        SDL.SDLK_e => KeyCode.three,
        SDL.SDLK_SPACE => KeyCode.five,
        SDL.SDLK_c => KeyCode.c,

        else => null,
    };
}
