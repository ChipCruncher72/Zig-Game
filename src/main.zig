const std = @import("std");
const sdl3 = @import("sdl3");

const fps = 120;
const window_width = 640;
const window_height = 480;

pub fn main() !void {
    defer sdl3.shutdown();

    const init_flags: sdl3.InitFlags = .{ .video = true };
    try sdl3.init(init_flags);
    defer sdl3.quit(init_flags);

    const window = try sdl3.video.Window.init("The GAME", window_width, window_height, .{
        .resizable = true,
        .vulkan = true,
    });
    defer window.deinit();

    var fps_capper: sdl3.extras.FramerateCapper(f32) = .{ .mode = .{ .limited = fps } };

    var quit = false;
    var full_screened = false;

    while (!quit) {
        _ = fps_capper.delay();

        const surface = try window.getSurface();
        try surface.clear(.{ .r = 0, .g = 0, .b = 0, .a = 255 });
        try window.updateSurface();

        while (sdl3.events.poll()) |event|
            switch (event) {
                .key_down => |k| {
                    if (k.key) |key| if (key == .func11 and !k.repeat) {
                        full_screened = !full_screened;
                        try window.setFullscreen(full_screened);
                    };
                },
                .quit => quit = true,
                .terminating => quit = true,
                else => {},
            };
    }
}
