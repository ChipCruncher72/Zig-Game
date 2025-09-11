const std = @import("std");

pub fn build(b: *std.Build) void {
    const debug = b.option(bool, "debug", "Whether or not debugging should be enabled (false by default)") orelse false;
    const dynamic_link = b.option(bool, "dynamic_link", "Whether the executable should link to SDL3 dynamically (false by default)") orelse false;
    const aggressive_optimize = b.option(bool, "aggressive", "Whether the executable should perform aggressive optimizations (false by default)") orelse false;

    const target = b.standardTargetOptions(.{});
    const optimize: std.builtin.OptimizeMode = if (debug) .Debug else if (aggressive_optimize) .ReleaseFast else .ReleaseSafe;

    const exe_mod = b.createModule(.{
        .optimize = optimize,
        .target = target,
        .root_source_file = b.path("src/main.zig"),
    });

    const sdl3 = b.dependency("sdl3", .{
        .target = target,
        .optimize = optimize,

        .c_sdl_preferred_linkage = if (dynamic_link) @as(std.builtin.LinkMode, .dynamic) else .static,
        .c_sdl_strip = if (aggressive_optimize and !debug) true else false,
        .c_sdl_lto = if (debug) @as(std.zig.LtoMode, .none) else if (aggressive_optimize) @as(std.zig.LtoMode, .full) else .thin,
    });

    exe_mod.addImport("sdl3", sdl3.module("sdl3"));

    const exe = b.addExecutable(.{
        .name = "zig_game",
        .root_module = exe_mod,
    });
    exe.lto = if (debug) .none else if (aggressive_optimize) .full else .thin;

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
