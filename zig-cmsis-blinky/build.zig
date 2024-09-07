const std = @import("std");

pub fn build(b: *std.Build) !void {
    const elf = b.addExecutable(.{
        .name = "stmexe",
        .root_source_file = b.path("src/main.zig"),
        .target = b.resolveTargetQuery(.{
            .cpu_arch = .thumb,
            .os_tag = .freestanding,
            .abi = .eabi,
            .cpu_model = .{ .explicit = &std.Target.arm.cpu.cortex_m3 },
            .glibc_version = null,
        }),
        .link_libc = false,
        .optimize = b.standardOptimizeOption(.{}),
        .strip = false,
        .single_threaded = true,
        .linkage = .static,
    });

    elf.link_gc_sections = true;
    elf.link_data_sections = true;
    elf.link_function_sections = true;

    elf.setLinkerScript(b.path("STM32F103C6TX_FLASH.ld"));
    elf.addAssemblyFile(b.path("startup_stm32f103c6tx.s"));

    elf.addIncludePath(.{ .cwd_relative = "CMSIS/" });

    elf.entry = .{ .symbol_name = "Reset_Handler" };

    const bin = b.addObjCopy(elf.getEmittedBin(), .{ .format = .bin });
    bin.step.dependOn(&elf.step);
    const binExe = b.addInstallBinFile(bin.getOutput(), "output.bin");
    b.default_step.dependOn(&binExe.step);

    const hex = b.addObjCopy(elf.getEmittedBin(), .{ .format = .hex });
    hex.step.dependOn(&elf.step);
    const hexExe = b.addInstallBinFile(hex.getOutput(), "output.hex");
    b.default_step.dependOn(&hexExe.step);

    b.installArtifact(elf);

    const flash_cmd = b.addSystemCommand(&[_][]const u8{
        "st-flash",
        "--format=ihex",
        "write",
        "zig-out/bin/output.hex",
    });

    flash_cmd.step.dependOn(&hex.step);

    const flash_step = b.step("flash", "Flash the firmware");
    flash_step.dependOn(&flash_cmd.step);
}
