const SDL = @import("sdl.zig").SDL;

const Display = @import("../../engine/display.zig");
const Engine = @import("../../engine/main.zig");

const InputMapping = @import("input_mapping.zig");
const DisplayRendering = @import("display_rendering.zig");

pub const Settings = struct {
    window_name: []const u8,
    render_scale: usize,
    fill_color: SDL.SDL_Color,
    clear_color: SDL.SDL_Color,
};

pub var window: ?*SDL.SDL_Window = null;
pub var renderer: ?*SDL.SDL_Renderer = null;
var is_active = false;

pub var settings: Settings = undefined;

pub fn activate(settingsToApply: Settings) !void {
    settings = settingsToApply;

    try initialize_sdl();
    try create_sdl_window();
    try create_sdl_renderer();

    is_active = true;
}

fn initialize_sdl() !void {
    if (SDL.SDL_Init(SDL.SDL_INIT_VIDEO) != 0) {
        return error.SDLInitializationFailed;
    }
}

fn create_sdl_window() !void {
    window = SDL.SDL_CreateWindow(
        @ptrCast(settings.window_name),
        SDL.SDL_WINDOWPOS_UNDEFINED,
        SDL.SDL_WINDOWPOS_UNDEFINED,
        @intCast(Display.width * settings.render_scale),
        @intCast(Display.height * settings.render_scale),
        SDL.SDL_WINDOW_OPENGL,
    ) orelse {
        deactivate();
        return error.SDLInitializationFailed;
    };
}

fn create_sdl_renderer() !void {
    renderer = SDL.SDL_CreateRenderer(window, -1, 0) orelse {
        deactivate();
        return error.SDLInitializationFailed;
    };
}

pub fn deactivate() void {
    stop();
    if (renderer) |r| SDL.SDL_DestroyRenderer(r);
    if (window) |w| SDL.SDL_DestroyWindow(w);
    SDL.SDL_Quit();
}

pub fn stop() void {
    is_active = false;
}

pub fn start_loop() void {
    while (is_active) {
        process_events();
        update();
        render();

        SDL.SDL_Delay(17);
    }
}

pub fn process_events() void {
    var event: SDL.SDL_Event = undefined;
    while (SDL.SDL_PollEvent(&event) != 0) {
        switch (event.type) {
            SDL.SDL_KEYDOWN => InputMapping.register_key_press(event.key.keysym.sym),
            SDL.SDL_KEYUP => InputMapping.register_key_release(event.key.keysym.sym),
            SDL.SDL_QUIT => stop(),
            else => {},
        }
    }
}

pub fn update() void {
    Engine.process();
}

pub fn render() void {
    DisplayRendering.render_display_pixels();
    SDL.SDL_RenderPresent(renderer);
}
