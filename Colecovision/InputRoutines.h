// Button defines
constexpr byte	JoypadUp	= 0x01;
constexpr byte	JoypadRight	= 0x02;
constexpr byte	JoypadDown	= 0x04;
constexpr byte	JoypadLeft	= 0x08;
constexpr byte	Button1		= 0x10;
constexpr byte	Button2		= 0x20;

// Clear joysticks
extern void clearJoysticks();

// Update joysticks
extern void updateJoysticks();

// Read joystick 1
extern byte readJoystick1();

// Read joystick 2
extern byte readJoystick2();
