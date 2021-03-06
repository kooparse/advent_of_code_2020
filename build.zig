const std = @import("std");
const Builder = std.build.Builder;

pub fn build(b: *Builder) void {
    const mode = b.standardReleaseOptions();

    {
        var exe = b.addExecutable("adventofcode_2020", "src/10.zig");
        exe.install();

        const play = b.step("run", "Run current puzzle");
        const run = exe.run();
        run.step.dependOn(b.getInstallStep());

        play.dependOn(&run.step);
    }
}
