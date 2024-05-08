pub const SDL = @cImport({
    @cInclude("SDL2/SDL.h");
});

pub const Settings = struct {
    window_name: []const u8,
    render_scale: c_int,
    fill_color: SDL.SDL_Color,
    clear_color: SDL.SDL_Color,
};

pub const Controller = struct {
    const Self = @This();

    window: ?*SDL.SDL_Window,
    renderer: ?*SDL.SDL_Renderer,
    settings: Settings,

    is_active: bool,

    pub fn init(settings: Settings) !Self {
        try initialize_sdl();
        const window = try create_sdl_window(settings);
        const renderer = try create_sdl_renderer(window);

        return .{
            .window = window,
            .renderer = renderer,
            .settings = settings,
            .is_active = true,
        };
    }

    fn initialize_sdl() !void {
        if (SDL.SDL_Init(SDL.SDL_INIT_VIDEO) != 0) {
            return error.SDLInitializationFailed;
        }
    }

    fn create_sdl_window(settings: Settings) !*SDL.SDL_Window {
        const window_size = get_window_size(settings);

        return SDL.SDL_CreateWindow(
            @ptrCast(settings.window_name),
            SDL.SDL_WINDOWPOS_UNDEFINED,
            SDL.SDL_WINDOWPOS_UNDEFINED,
            window_size.width,
            window_size.height,
            SDL.SDL_WINDOW_OPENGL,
        ) orelse {
            SDL.SDL_Quit();
            return error.SDLInitializationFailed;
        };
    }

    fn get_window_size(settings: Settings) struct { width: c_int, height: c_int } {
        return .{
            .width = 84 * settings.render_scale,
            .height = 48 * settings.render_scale,
        };
    }

    fn create_sdl_renderer(window: *SDL.SDL_Window) !*SDL.SDL_Renderer {
        return SDL.SDL_CreateRenderer(window, -1, 0) orelse {
            SDL.SDL_DestroyWindow(window);
            SDL.SDL_Quit();
            return error.SDLInitializationFailed;
        };
    }

    pub fn stop(self: *Self) void {
        self.is_active = false;
    }

    pub fn deinit(self: *Self) void {
        self.stop();
        if (self.renderer != null) SDL.SDL_DestroyRenderer(self.renderer);
        if (self.window != null) SDL.SDL_DestroyWindow(self.window);
        SDL.SDL_Quit();
    }

    pub fn process_events(self: *Self) void {
        var event: SDL.SDL_Event = undefined;
        while (SDL.SDL_PollEvent(&event) != 0) {
            switch (event.type) {
                SDL.SDL_QUIT => self.stop(),
                else => {},
            }
        }
    }

    pub fn update(_: *Self) void {}

    pub fn render(self: Self) void {
        const window_size = get_window_size(self.settings);

        const rect: SDL.SDL_Rect = .{ .x = 0, .y = 0, .w = window_size.width, .h = window_size.height };

        _ = SDL.SDL_RenderClear(self.renderer);
        const color = self.settings.fill_color;
        _ = SDL.SDL_SetRenderDrawColor(self.renderer, color.r, color.g, color.b, 255);
        _ = SDL.SDL_RenderFillRect(self.renderer, &rect);
        SDL.SDL_RenderPresent(self.renderer);
    }

    pub fn start_loop(self: *Self) void {
        while (self.is_active) {
            self.process_events();
            self.update();
            self.render();

            SDL.SDL_Delay(17);
        }
    }
};
