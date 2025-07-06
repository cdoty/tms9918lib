// Enable IRQ
extern void enableIRQ();

// Disable IRQ
extern void disableIRQ();

// Init random seed
extern void initRandSeed();

// Get randon value
extern byte rand();

// Enable sprite magnification
extern void enableSpriteMagnification(byte _enable);

// Expanded RAM available
extern byte expandedRAMAvailable();

// Set start numeric char
extern void setStartNumericChar(byte _start);

// Convert value to Ascii
extern void convertValueToAscii(word _score, ptr<byte> _pString);