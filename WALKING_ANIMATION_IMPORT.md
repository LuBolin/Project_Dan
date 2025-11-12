# Walking Animation Import Instructions

The walking animation assets have been imported into the `sprites/` directory and the player code has been updated to use them. However, you need to create the sprite resources in GameMaker Studio 2.

## Sprite Files Location

The animation frames are located in:
- `sprites/spr_character_walking/`
  - `characterwalking_down1.png` through `characterwalking_down6.png` (6 frames)
  - `characterwalking_right1.png` through `characterwalking_right6.png` (6 frames)
  - `characterwalking_up1.png` through `characterwalking_up6.png` (6 frames)

## GameMaker Import Steps

### 1. Create Sprite: spr_character_walking_down
1. In GameMaker, right-click on the "Player" folder under Sprites
2. Select "Create Sprite"
3. Name it `spr_character_walking_down`
4. Import frames (in order):
   - `sprites/spr_character_walking/characterwalking_down1.png`
   - `sprites/spr_character_walking/characterwalking_down2.png`
   - `sprites/spr_character_walking/characterwalking_down3.png`
   - `sprites/spr_character_walking/characterwalking_down4.png`
   - `sprites/spr_character_walking/characterwalking_down5.png`
   - `sprites/spr_character_walking/characterwalking_down6.png`
5. Set sprite properties:
   - Size: 64x64 (match existing character sprites)
   - Origin: Middle Center
   - Collision: Precise (or match existing player sprites)
   - Playback Speed: 10-15 FPS (adjust to taste)

### 2. Create Sprite: spr_character_walking_right
1. Right-click on the "Player" folder under Sprites
2. Select "Create Sprite"
3. Name it `spr_character_walking_right`
4. Import frames (in order):
   - `sprites/spr_character_walking/characterwalking_right1.png`
   - `sprites/spr_character_walking/characterwalking_right2.png`
   - `sprites/spr_character_walking/characterwalking_right3.png`
   - `sprites/spr_character_walking/characterwalking_right4.png`
   - `sprites/spr_character_walking/characterwalking_right5.png`
   - `sprites/spr_character_walking/characterwalking_right6.png`
5. Set sprite properties:
   - Size: 64x64
   - Origin: Middle Center
   - Collision: Precise
   - Playback Speed: 10-15 FPS

### 3. Create Sprite: spr_character_walking_up
1. Right-click on the "Player" folder under Sprites
2. Select "Create Sprite"
3. Name it `spr_character_walking_up`
4. Import frames (in order):
   - `sprites/spr_character_walking/characterwalking_up1.png`
   - `sprites/spr_character_walking/characterwalking_up2.png`
   - `sprites/spr_character_walking/characterwalking_up3.png`
   - `sprites/spr_character_walking/characterwalking_up4.png`
   - `sprites/spr_character_walking/characterwalking_up5.png`
   - `sprites/spr_character_walking/characterwalking_up6.png`
5. Set sprite properties:
   - Size: 64x64
   - Origin: Middle Center
   - Collision: Precise
   - Playback Speed: 10-15 FPS

## Code Changes Made

The following files have been updated to use the walking animations:

### `objects/obj_player/Create_0.gml`
Added sprite variables:
```gml
spr_walk_right = spr_character_walking_right;
spr_walk_up = spr_character_walking_up;
spr_walk_down = spr_character_walking_down;
```

Added animation state:
```gml
is_moving = false;
walk_animation_speed = 0.2;
```

### `objects/obj_player/Step_0.gml`
Updated sprite logic to include walking animations:
- When player is moving: plays walking animation
- When player is idle: shows still/idle sprite
- When player is attacking: plays attack animation (overrides walking)

The walking animation automatically mirrors the right sprite for left-facing movement using `image_xscale = -abs(image_xscale)`.

## Animation Behavior

- **Idle**: Shows still sprites (down, up, or right facing)
- **Walking**: Plays walking animation in the direction of movement
- **Attacking**: Plays attack animation (takes priority over walking)
- **Left movement**: Uses mirrored right walking sprite

## Testing

Once the sprites are imported in GameMaker:
1. Run the game
2. Move the character with WASD
3. You should see the walking animation play when moving
4. The animation should stop and show the idle sprite when standing still
5. Attack animations should still work normally

## Troubleshooting

If the sprites don't appear:
- Make sure the sprite names exactly match: `spr_character_walking_down`, `spr_character_walking_right`, `spr_character_walking_up`
- Verify the sprites are in the correct folder structure
- Check that the sprite dimensions match (64x64)
- Ensure the origin point is set to Middle Center

If the animation is too fast or slow:
- Adjust the playback speed in the sprite properties in GameMaker
- Or modify `walk_animation_speed` in `obj_player/Create_0.gml`
