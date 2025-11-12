# Adding Walking Animation Frames

The walking sprite resources have been created in GameMaker, but they currently only have placeholder frames. You need to add the actual animation frames from the `sprites/spr_character_walking/` directory.

## Animation Frames Location

All frames are in: `sprites/spr_character_walking/`

## Steps to Add Frames in GameMaker

### 1. spr_character_walking_down (6 frames)
1. Open `spr_character_walking_down` in GameMaker
2. Delete the existing placeholder frame
3. Click "Import" and select these files in order:
   - `characterwalking_down1.png`
   - `characterwalking_down2.png`
   - `characterwalking_down3.png`
   - `characterwalking_down4.png`
   - `characterwalking_down5.png`
   - `characterwalking_down6.png`
4. Set sprite properties:
   - Origin: **Middle Center**
   - Playback Speed: **10 FPS**

### 2. spr_character_walking_up (6 frames)
1. Open `spr_character_walking_up` in GameMaker
2. Delete the existing placeholder frame
3. Click "Import" and select these files in order:
   - `characterwalking_up1.png`
   - `characterwalking_up2.png`
   - `characterwalking_up3.png`
   - `characterwalking_up4.png`
   - `characterwalking_up5.png`
   - `characterwalking_up6.png`
4. Set sprite properties:
   - Origin: **Middle Center**
   - Playback Speed: **10 FPS**

### 3. spr_character_walking_right (6 frames)
1. Open `spr_character_walking_right` in GameMaker
2. Delete the existing placeholder frame
3. Click "Import" and select these files in order:
   - `characterwalking_right1.png`
   - `characterwalking_right2.png`
   - `characterwalking_right3.png`
   - `characterwalking_right4.png`
   - `characterwalking_right5.png`
   - `characterwalking_right6.png`
4. Set sprite properties:
   - Origin: **Middle Center**
   - Playback Speed: **10 FPS**

### 4. spr_character_walking_left (6 frames)
1. Open `spr_character_walking_left` in GameMaker
2. Delete the existing placeholder frame
3. Click "Import" and select these files in order:
   - Use the **right** frames and flip them horizontally in GameMaker:
     - `characterwalking_right1.png` (flip horizontal)
     - `characterwalking_right2.png` (flip horizontal)
     - `characterwalking_right3.png` (flip horizontal)
     - `characterwalking_right4.png` (flip horizontal)
     - `characterwalking_right5.png` (flip horizontal)
     - `characterwalking_right6.png` (flip horizontal)
   - OR: Copy the right frames to left filenames, flip them, and import
4. Set sprite properties:
   - Origin: **Middle Center**
   - Playback Speed: **10 FPS**

## Code is Ready!

The player code has been updated to use all 4 walking sprites:
- `spr_character_walking_down` - Walking down
- `spr_character_walking_up` - Walking up
- `spr_character_walking_right` - Walking right
- `spr_character_walking_left` - Walking left (dedicated sprite, not mirrored)

Once you add the frames in GameMaker, the walking animations will work automatically!

## Testing

After adding the frames:
1. Run the game
2. Move with WASD
3. The character should animate in all 4 directions
4. Standing still should show the idle sprite
5. Attacking should override the walking animation
