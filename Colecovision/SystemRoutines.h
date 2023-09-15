// Turn on screen
extern void turnOnScreen();

// Turn off screen
extern void turnOffScreen();

// Transfer to VRAM
extern void tranferToVRAM(ptr<byte> _source, word _dest, word _size);

// Enable IRQ
extern void enableIRQ();

// Disable IRQ
extern void disableIRQ();

// Clear timer
extern void clearTimer();

// Wait for timer or button press
extern void waitForTimerOrButtonPress(byte _delay, byte _button);
