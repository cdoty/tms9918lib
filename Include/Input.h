// Clear joysticks
extern void clearJoysticks();

// Update joysticks
extern void updateJoysticks();

// Update keyboard. Not supported on all systems. Need to include UpdateKeyboard.s in makefile.
extern void updateKeyboard();

// Read joystick 1
extern byte readJoystick1();

// Read joystick 2
extern byte readJoystick2();
