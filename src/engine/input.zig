const std = @import("std");

pub const KeyCode = enum {
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

pub const KeyStateSet = std.enums.EnumSet(KeyCode);

var key_states = KeyStateSet.initEmpty();
var last_key_states = KeyStateSet.initEmpty();

var key_press_buffer = KeyStateSet.initEmpty();
var key_release_buffer = KeyStateSet.initEmpty();

pub fn press_key(key: KeyCode) void {
    key_press_buffer.insert(key);
}

pub fn release_key(key: KeyCode) void {
    key_release_buffer.insert(key);
}

pub fn is_key_just_pressed(key: KeyCode) bool {
    return key_states.contains(key) and !last_key_states.contains(key);
}

pub fn is_key_held(key: KeyCode) bool {
    return key_states.contains(key);
}

pub fn is_key_just_released(key: KeyCode) bool {
    return !key_states.contains(key) and last_key_states.contains(key);
}

pub fn process() void {
    update_last_key_states();
    process_buffers();
    clear_buffers();
}

fn update_last_key_states() void {
    last_key_states = key_states;
}

fn process_buffers() void {
    key_states = key_states
        .unionWith(key_press_buffer)
        .differenceWith(key_release_buffer);
}

fn clear_buffers() void {
    key_press_buffer = KeyStateSet.initEmpty();
    key_release_buffer = KeyStateSet.initEmpty();
}
