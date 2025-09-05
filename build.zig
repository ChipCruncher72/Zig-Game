const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    var optimize: std.builtin.OptimizeMode = .ReleaseFast;
    if (b.option(bool, "debug", "Whether or not debugging should be enabled (false by default)") orelse false) {
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

    if (target.result.os.tag == .windows) {
        exe.subsystem = .Windows;
    }

    b.installArtifact(exe);

    const install_artifact = b.addInstallArtifact(exe, .{});
    const run_artifact = b.addRunArtifact(exe);

    if (b.args) |args| {
        run_artifact.addArgs(args);
    }

    const run = b.step("run", "Compiles and executes the program");
    run.dependOn(&install_artifact.step);
    run.dependOn(&run_artifact.step);
}
