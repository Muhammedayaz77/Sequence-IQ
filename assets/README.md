# Sequence IQ — Game Asset Library

This folder contains the reusable visual system and approved visual references for Sequence IQ V1.

## Final visual source of truth

The project owner's current 12-screen mockup is now **FINAL and approved**. It is the authoritative visual reference until the owner explicitly requests a replacement or a change to a specific screen.

Final screens:
1. Splash Screen
2. Home Screen
3. Difficulty Select
4. Level Map (Easy)
5. Gameplay Screen
6. Level Complete
7. Game Over
8. Settings
9. Shop
10. Achievements
11. Stats
12. Coming Soon

See `FINAL_DESIGN_STATUS.md` and `FINAL_SCREEN_ASSET_MANIFEST.md` for the final design decision and screen-by-screen graphics mapping.

## Critical asset rule

Never crop individual production assets from the composite mock-screen. Cropping reduces quality and is not an acceptable production workflow.

Production backgrounds, buttons, icons, panels, illustrations and other graphics must exist as their own native/high-quality assets. Reusable assets should be stored once and referenced by all screens that use them.

## Final-design rule

Once a screen is explicitly finalized by the project owner, its visual design is locked. Do not alter, redesign, substitute, modernize, rearrange, or otherwise change that screen without explicit owner approval.

Web, iOS, and Android must reproduce the approved final design consistently while remaining technically independent implementations.

## Asset groups
- `backgrounds/` — native reusable screen backgrounds
- `buttons/` — native reusable game/navigation buttons
- `icons/` — native reusable icons
- `panels/` — native reusable UI panels
- `mock-screens/` — visual references and final-design documentation only

## Image-generation permission

Do not generate new project images unless the project owner explicitly requests image generation/editing in that request. A code implementation, debugging, testing, repository maintenance, or design-integration request by itself is not permission to generate additional images.
