// Clear sprites
extern void clearSprites();

// Update sprites during the next VBlank
extern void updateSprites();

// Select sprite
extern void selectSprite(byte _index);

// Set sprite position
extern void setSpritePosition(byte _x, byte _y);

// Set sprite tile
extern void setSpriteTile(byte _tile);

// Set sprite color
extern void setSpriteColor(byte _color);

// Set sprite tile and color
extern void setSpriteTileAndColor(byte _tile, byte _color);