const std = @import("std");

const Input = struct {
    const Self = @This();

    const KeyCode = enum {
        none,
        one,
        two,
        three,
        four,
        five,
        six,
        seven,
        eight,
        nine,
        star,
        zero,
        hash,
        c,
        scroll_left,
        scroll_right,
        navi,
        power,
    };

    key_states: [KeyCode]bool,
    last_key_states: [KeyCode]bool,

    key_press_buffer: [KeyCode]bool,
    key_release_buffer: [KeyCode]bool,

    pub fn init() Self {
        return .{
            .key_states = [KeyCode]bool{false},
            .key_states_buffer = [KeyCode]bool{false},
        };
    }

    pub fn press_key(self: *Self, key: KeyCode) void {
        self.key_press_buffer[key] = true;
    }

    pub fn release_key(self: *Self, key: KeyCode) void {
        self.key_release_buffer[key] = true;
    }

    pub fn is_key_just_pressed(self: Self, key: KeyCode) bool {
        return self.key_states[key] and !self.last_key_states[key];
    }

    pub fn is_key_held(self: Self, key: KeyCode) bool {
        return self.key_states[key];
    }

    pub fn is_key_just_released(self: Self, key: KeyCode) bool {
        return !self.key_states[key] and self.last_key_states[key];
    }

    pub fn process(self: *Self) void {
        self.update_last_key_states();
        self.process_buffers();
        self.clear_buffers();
    }

    fn update_last_key_states(self: *Self) void {
        const dest = &self.last_key_states;
        const source = &self.key_states;
        std.mem.copy(bool, dest, source);
    }

    fn process_buffers(self: *Self) void {
        inline for (@typeInfo(KeyCode).Enum.fields) |key| {
            if (self.key_press_buffer[key]) {
                self.key_states[key] = true;
            }
            if (self.key_release_buffer[key]) {
                self.key_states[key] = false;
            }
        }
    }

    fn clear_buffers(self: *Self) void {
        std.mem.set(bool, &self.key_press_buffer, false);
        std.mem.set(bool, &self.key_release_buffer, false);
    }
};
