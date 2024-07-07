const Display = @import("display.zig");
const Input = @import("input.zig");

const FontRenderer = @import("text/font_renderer.zig");
const Fonts = @import("text/fonts.zig");

const Rasterizer = @import("rendering/rasterizer.zig");

const Vector3 = @import("math/Vector3.zig");
const Vector2 = @import("math/Vector2.zig");
const Vector2i = @import("math/Vector2i.zig");
const Quaternion = @import("math/Quaternion.zig");

const Camera = @import("rendering/camera.zig");
const Box = @import("../game/elements/box.zig");

var box: Box = .{};

pub fn process() void {
    process_input();

    Display.clear();

    FontRenderer.print("hello world lol", Fonts.classic, 5, 5, true);

    box.transform.rotation = box.transform.rotation.mul(Quaternion.from_euler_angles(0, 11, 0));

    box.transform.position = .{ .x = 0, .y = 0, .z = 5 };
    box.render();
}

fn process_input() void {
    var input: Vector2 = .{ .x = 0, .y = 0 };

    const speed = 0.1;
    const sensitivity = 1.0;

    if (Input.is_key_held(.two)) {
        input.y += 1;
    }
    if (Input.is_key_held(.eight)) {
        input.y -= 1;
    }
    if (Input.is_key_held(.four)) {
        input.x -= 1;
    }
    if (Input.is_key_held(.six)) {
        input.x += 1;
    }

    if (Input.is_key_held(.one)) {
        Camera.transform.position.y += speed;
    }
    if (Input.is_key_held(.three)) {
        Camera.transform.position.y -= speed;
    }

    if (!Input.is_key_held(.five)) {
        const forward = Camera.transform.forward();
        const side = Camera.transform.right();

        const move_delta = forward.scale(speed * input.y).add(side.scale(speed * input.x));
        Camera.transform.position = Camera.transform.position.add(move_delta);
    } else {
        const rotation_delta_pitch = Quaternion.from_euler_angles(input.y * sensitivity, 0, 0);
        const rotation_delta_yaw = Quaternion.from_euler_angles(0, input.x * sensitivity, 0);
        Camera.transform.rotation = rotation_delta_yaw.mul(Camera.transform.rotation).mul(rotation_delta_pitch);
    }
}
