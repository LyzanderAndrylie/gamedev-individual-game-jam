# Individual Game Jam - Game Development 2023/2024

> Godot Version: 4.2.1

## Game Description

![Upside Down Noir Menu](./image/upside_down_noir_menu.png)

**Upside Down Noir** is an immersive and unique gaming experience where players take on the role of Noir, a versatile character capable of defying gravity and harnessing the power of fire. In this game, Noir has the ability to manipulate gravity at will, transitioning between a black form with normal gravity and a white form with inverted gravity. These transformations not only affect gravity but also influence Noir's interactions with the environment.

The goal of **Upside Down Noir** is to navigate through challenging levels filled with black and white platforms. When Noir is in black form, he cannot touch white platforms, and when in white form, he must avoid black platforms. This mechanic adds a layer of strategy and puzzle-solving as players must carefully time gravity changes to progress through the levels.

The main challenge awaits at the end of each level, where Noir faces off against a powerful sorcerer boss. The sorcerer's color, either black or white, determines which form of Noir can deal damage. A white sorcerer can only be defeated by black Noir, while a black sorcerer can only be defeated by white Noir. Players must master the art of gravity manipulation and utilize Noir's fire-shooting ability to overcome these formidable foes and emerge victorious.

**Upside Down Noir** offers a captivating blend of platforming, puzzle-solving, and boss battles, making it an exhilarating adventure for gamers seeking a fresh and innovative experience.

### Game Concept

The concept of **Upside Down Noir** integrates three unique *diversifiers* as follows:

1. Yeet: Noir can harness the power of fire to shoot at sorcerer bosses blocking his path through various levels.
2. Orange is the New Black: Noir can transform into black and white forms, each with distinct abilities.
    - Black Noir moves with normal gravity (gravity pulls downward), can only touch black platforms, and can attack white sorcerers.
    - Conversely, White Noir moves with inverted gravity (gravity pulls upward), can only touch white platforms, and can attack black sorcerers.
3. Tsunomaki Janken: Black Noir can only touch black platforms and defeat white sorcerers. White Noir can only touch white platforms and defeat black sorcerers. Thus, Noir must leverage both forms to overcome their respective weaknesses and utilize their strengths. The strengths and weaknesses of each form are inversely related.

### How to Play

Playing this game is very simple. Let's take a look!

1. When the player starts the game, they will be on the menu screen.
2. The player must press the `Start` button to begin the game.

     ![Upside Down Noir Menu](./image/upside_down_noir_menu.png)

3. If the player is playing for the first time, they will enter a tutorial level explaining the game mechanics.

     ![Upside Down Noir Tutorial Level](./image/level_tutorial.png)

     - Press the `A` key to move left.
     - Press the `D` key to move right.
     - Double-tap `A` or `D` to dash.
     - Press the `W` key or `Space` to jump. Double-tap to double jump.
     - Press the `Q` key to switch Noir's form and manipulate gravity.
     - Press the `Left Click` on the mouse and aim the pointer to shoot.

4. The player will move to the right side of the map to complete the level while facing various challenges.

     ![Progress in Tutorial Level](./image/level_tutorial_progress.png)

5. The player will encounter a boss at the end of the level and must fight with all their might to defeat it.

     ![Boss in Tutorial Level](./image/level_tutorial_boss.png)

     If the player is defeated by the sorcerer boss, they can retry the level.

     ![Game Over in Tutorial Level](./image/level_tutorial_game_over.png)

6. After defeating the boss, the player must collect the *key* at the end of the map to proceed to the next level.

     ![End of Tutorial Level](./image/level_tutorial_end.png)

7. Congratulations! You have completed the tutorial (or replayed the level if you chose the wrong key).

> Tips: Remember the abilities of each Noir form.

### Game Level 1 Screenshots

![Level 1 Start](./image/level1.png)

![Level 1 Progress](./image/level1_progress.png)

![Level 1 End](./image/level1_end.png)

### Source Code Links

- [GitHub](https://github.com/LyzanderAndrylie/gamedev-individual-game-jam)
- [Executable File](https://github.com/LyzanderAndrylie/gamedev-individual-game-jam/tree/main/builds/)

## Asset Sources

1. [Pixel Protagonist](https://penzilla.itch.io/protagonist-character)
2. [Slime](https://craftpix.net/freebies/free-slime-sprite-sheets-pixel-art/)
3. [Background Cloud](https://craftpix.net/freebies/free-sky-with-clouds-background-pixel-art-set/)
4. [Background Cave](https://pixfinity.itch.io/the-dungeon-pack)
5. [Fire Animation](https://brullov.itch.io/fire-animation)
6. [Font](https://managore.itch.io/m6x11)
7. [VFX Starter Pack](https://sangoro.itch.io/vfx-starter-pack)
8. [Pixel Bullet](https://bdragon1727.itch.io/fire-pixel-bullet-16x16)
9. [Effect and Bullet](https://bdragon1727.itch.io/free-effect-and-bullet-16x16)
10. [1 Bit Pixel Art Forest](https://edermunizz.itch.io/1-bit-pixel-art-forest)
11. [Black and White Tiles](https://that-gray-guy.itch.io/simple-black-and-white-tiles)
12. [1 Bit Platformer Pack](https://kenney-assets.itch.io/1-bit-platformer-pack)
13. [1 Bit Keyboard Icons](https://ansdor.itch.io/button-icons)
14. [Sorcerer Villain](https://lionheart963.itch.io/sorcerer-villain)
15. [Game Audio](https://mixkit.co/free-sound-effects/game/)
16. [Jump Audio](https://pixabay.com/sound-effects/search/jump/)

### Cheat

Players can activate cheats by pressing the key combination `Ctrl + Shift + *`.

When cheats are activated, players can freely fly through the game levels. Additionally, players will have unlimited health.

https://github.com/LyzanderAndrylie/gamedev-individual-game-jam/assets/107832263/6314ee75-17b3-4f92-9fad-b8388f76b293

### Polishing

1. Added particle trails when Noir is walking.

     This enhances the game's aesthetics, aligning with the black-and-white (1-bit) theme of *Noir*. Additionally, when players move and manipulate gravity, they can observe beautiful patterns created by Noir's movements. Below is a screenshot example of the added particle trails.

2. Added audio when Noir jumps.

     Proper audio enhances the game's mood and player experience. Therefore, I added audio effects for Noir's jumps.

3. Improved source code.

     This polishing step involved refining the source code to prevent bugs that could affect the player's experience. Additionally, well-structured source code facilitates further development of the *Noir* game.

4. Enhanced full-screen gameplay and sharpened visuals in Godot.

     To improve the player's experience, I adjusted the behavior of the *Noir* game when played in full-screen mode. Furthermore, I optimized the game's image filters to prevent pixelation, enhancing the game's overall look and feel.

5. Added CI/CD workflow with GitHub Actions to automatically build the *Noir* game on Windows platforms.

     To automate the build process, I defined a workflow for GitHub Actions tailored to this purpose.
