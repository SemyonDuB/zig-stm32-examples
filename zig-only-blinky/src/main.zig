const PERIPH_BASE: u32 = 0x40000000;
const APB1PERIPH_BASE: u32 = PERIPH_BASE;
const APB2PERIPH_BASE: u32 = PERIPH_BASE + 0x00010000;
const AHBPERIPH_BASE: u32 = PERIPH_BASE + 0x00020000;

const GPIOC_BASE: u32 = APB2PERIPH_BASE + 0x00001000;

const RCC_BASE: u32 = AHBPERIPH_BASE + 0x00001000;
const RCC: *volatile packed struct {
    CR: u32,
    CFGR: u32,
    CIR: u32,
    APB2RSTR: u32,
    APB1RSTR: u32,
    AHBENR: u32,
    APB2ENR: u32,
    APB1ENR: u32,
    BDCR: u32,
    CSR: u32,
} = @ptrFromInt(RCC_BASE);

const GPIOC: *volatile packed struct {
    CRL: u32,
    CRH: u32,
    IDR: u32,
    ODR: u32,
    BSRR: u32,
    BRR: u32,
    LCKR: u32,
} = @ptrFromInt(GPIOC_BASE);

const RCC_APB2ENR_IOPCEN_Pos: u32 = 4;
const RCC_APB2ENR_IOPCEN_Msk: u32 = 0x1 << RCC_APB2ENR_IOPCEN_Pos;
const RCC_APB2ENR_IOPCEN: u32 = RCC_APB2ENR_IOPCEN_Msk;

const GPIO_CRH_MODE13_Pos: u32 = 20;
const GPIO_CRH_MODE13_Msk: u32 = 0x3 << GPIO_CRH_MODE13_Pos; // 0x00300000
const GPIO_CRH_MODE13: u32 = GPIO_CRH_MODE13_Msk; // MODE13[1:0] bits (Port x mode bits, pin 13)
const GPIO_CRH_MODE13_0: u32 = 0x1 << GPIO_CRH_MODE13_Pos; // 0x00100000
const GPIO_CRH_MODE13_1: u32 = 0x2 << GPIO_CRH_MODE13_Pos; // 0x00200000

const GPIO_ODR_ODR13_Pos: u32 = 13;
const GPIO_ODR_ODR13_Msk: u32 = 0x1 << GPIO_ODR_ODR13_Pos; // 0x00002000
const GPIO_ODR_ODR13: u32 = GPIO_ODR_ODR13_Msk; // Port output data, bit 13

export fn main() void {
    RCC.APB2ENR |= RCC_APB2ENR_IOPCEN;

    GPIOC.CRH |= GPIO_CRH_MODE13_1;

    while (true) {
        GPIOC.ODR ^= GPIO_ODR_ODR13;

        var i: u32 = 0;
        while (i < 500_000) {
            i += 1;
        }
    }
}
