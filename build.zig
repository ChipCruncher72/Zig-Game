const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    var optimize: std.builtin.OptimizeMode = .ReleaseFast;
    if (b.option(bool, "debug", "Whether or not debugging should be enabled (false default)") orelse false) {
        optimize = .Debug;
    }

    const exe_mod = b.createModule(.{
        .optimize = optimize,
        .target = target,
        .root_source_file = b.path("src/main.zig"),
    });

    const sdl3 = b.dependency("sdl3", .{
        .target = target,
        .optimize = optimize,
    });

    exe_mod.addImport("sdl3", sdl3.module("sdl3"));

    const exe = b.addExecutable(.{
        .name = "zig_game",
        .root_module = exe_mod,
    });

    const run_artifact = b.addRunArtifact(exe);

    if (b.args) |args| {
        run_artifact.addArgs(args);
    }

    const build_artifact = b.addInstallArtifact(exe, .{});

    const run = b.step("run", "Executes the program");
    run.dependOn(&run_artifact.step);
    run.dependOn(&build_artifact.step);

    b.installArtifact(exe);
}
