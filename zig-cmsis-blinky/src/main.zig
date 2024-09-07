const cmsis = @cImport({
    @cInclude("stm32f103x6.h");
});

export fn main() void {
    cmsis.RCC.*.APB2ENR |= cmsis.RCC_APB2ENR_IOPCEN;
    cmsis.GPIOC.*.CRH |= cmsis.GPIO_CRH_MODE13_1;

    while (true) {
        cmsis.GPIOC.*.ODR ^= cmsis.GPIO_ODR_ODR13;

        var i: u32 = 0;
        while (i < 100_000) {
            i += 1;
        }
    }
}
