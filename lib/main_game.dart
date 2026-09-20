import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:pirate_action/component/level.dart';
import 'package:pirate_action/component/main_player/main_player.dart';

class MainGame extends FlameGame
    with HasCollisionDetection, DragCallbacks, TapCallbacks {
  //final Player playerMask = Player(characterName: "Mask Dude");
  final MainPlayer player = MainPlayer();

  CameraComponent? cam;
  Level? currentLevel;

  late JoystickComponent joystickComponent;

  // create hud button component
  late HudButtonComponent jumpButtonComponent;

  late HudButtonComponent attackButtonComponent;

  // create collected diamon
  final ValueNotifier<int> collectedBlueDiamond = ValueNotifier(0);
  final ValueNotifier<int> collectedRedDiamond = ValueNotifier(0);
  final ValueNotifier<int> collectedGreenDiamond = ValueNotifier(0);

  // craete health
  final ValueNotifier<int> healthValue = ValueNotifier(100);

  // function to update collected diamon
  void updateCollectedDiamond(String diamonColor) {
    switch (diamonColor) {
      case "Red":
        collectedRedDiamond.value++;
        break;
      case "Blue":
        collectedBlueDiamond.value++;
        break;
      case "Green":
        collectedGreenDiamond.value++;
        break;
    }
  }

  // create collected coin
  final ValueNotifier<int> collectedGoldCoin = ValueNotifier(0);
  final ValueNotifier<int> collectedSilverCoin = ValueNotifier(0);

  void updateCollectedCoin(String coinColor) {
    switch (coinColor) {
      case "Gold":
        collectedGoldCoin.value++;
        break;
      case "Silver":
        collectedSilverCoin.value++;
        break;
    }
  }

  @override
  Color backgroundColor() => const Color(0xFF211F30);

  // create level list
  List<String> levelList = ["level-01", "level-02"];
  int selectedLevel = 1;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    await images.loadAllImages();

    _loadWorld();

    // load all controller
    _loadJoyStick();
    _loadJumpButton();
    _loadAttackButton();
  }

  @override
  void update(double dt) {
    // handle joystick input
    _handleJoyStick();

    final double minX = 810.0;

    // Hardcode the target Y to the exact center of the map heights
    final double targetY = selectedLevel == 0 ? 378.0 : 368.0;

    final double camX = player.x.clamp(minX, double.infinity);

    // Do not let camY move based on player.y anymore for level 1
    final double camY = targetY;

    cam!.viewfinder.position = Vector2(camX, camY);

    super.update(dt);
  }

  // create function to load on ship
  void loadOnShip() {
    // set overlay
    overlays.add("Loading");

    // rmeove all overlay
    overlays.removeAll(["Diamond", "Coin", "Health"]);

    // set game freeze
    paused = true;

    // add some delay
    Future.delayed(Duration(milliseconds: 1000), () {
      // update selected level
      selectedLevel += 1;

      // reload world
      _loadWorld();

      // RELOAD CONTROLLER
      _loadJoyStick();
      _loadJumpButton();
      _loadAttackButton();

      // remove loading overlay
      overlays.remove("Loading");

      // add all overlay
      overlays.addAll(["Diamond", "Coin", "Health"]);

      // set game to run again
      paused = false;
    });
  }

  // functon to load world
  void _loadWorld() {
    // 1. Safely remove the OLD camera and level if they exist in the tree
    if (player.parent != null) {
      player.removeFromParent();
    }

    if (currentLevel != null) {
      currentLevel!.removeAll(
          currentLevel!.children); // Clears old enemies, backgrounds, etc.
      currentLevel!.removeFromParent();
    }

    cam?.removeFromParent();

    // first level
    player.position = Vector2(selectedLevel == 0 ? 3400 : 200, 540);
    currentLevel = Level(levelTitle: levelList[selectedLevel], player: player);

    // cam = CameraComponent(
    //   world: level
    // );

    final double deviceAspectRatio = size.x / size.y;
    final double targetHeight = selectedLevel == 0 ? 340.0 : 736.0;
    final double targetWidth = targetHeight * deviceAspectRatio;

    cam = CameraComponent.withFixedResolution(
      width: targetWidth,
      height: targetHeight,
      world: currentLevel,
    );

    if (selectedLevel == 0) {
      cam!.viewfinder.zoom = 1;
    } else {
      cam!.viewfinder.zoom = 1;
    }

    // 1. CHANGE THIS TO CENTER
    cam!.viewfinder.anchor = Anchor.center;

    if (selectedLevel == 1) {
      // Push the camera target down (e.g., from 350 to 420) so the bottom platform fits
      cam!.viewfinder.position = Vector2(800, 500);
    } else {
      cam!.viewfinder.position = Vector2(800, 340);
    }

    // cam.viewfinder.anchor = Anchor.center;
    // cam.follow(playerMask);

    addAll([cam!, currentLevel!]);
  }

  // function to load joystick
  void _loadJoyStick() {
    joystickComponent = JoystickComponent(
      priority: 100,
      knob: SpriteComponent(
        sprite: Sprite(images.fromCache('hud/knob (1).png')),
        size: Vector2(46, 46),
      ),
      background: SpriteComponent(
        sprite: Sprite(images.fromCache('hud/knob_background (1).png')),
        size: Vector2(92, 92),
      ),
      margin: const EdgeInsets.only(left: 10, bottom: 10),
    );

    cam!.viewport.add(joystickComponent);
    //add(joystickComponent);
  }

  // fucntion to load jump button
  void _loadJumpButton() {
    jumpButtonComponent = HudButtonComponent(
      button: SpriteComponent(
        sprite: Sprite(images.fromCache('hud/unpress_jump_button.png')),
        size: Vector2(96, 182),
      ),
      buttonDown: SpriteComponent(
        sprite: Sprite(images.fromCache('hud/press_jump_button.png')),
        size: Vector2(96, 182),
      ),
      onPressed: () {
        player.jumpButtonClicked();
      },
      onReleased: () {},
      margin: const EdgeInsets.only(right: 20, bottom: 10),
      priority: 100,
    );

    cam!.viewport.add(jumpButtonComponent);
  }

  // function to load attaack button
  void _loadAttackButton() {
    attackButtonComponent = HudButtonComponent(
      button: SpriteComponent(
        sprite: Sprite(images.fromCache('hud/unpress_attack_button.png')),
        size: Vector2(64, 64),
      ),
      buttonDown: SpriteComponent(
        sprite: Sprite(images.fromCache('hud/press_attack_button.png')),
        size: Vector2(96, 96),
      ),
      onPressed: () {
        player.attackButtonClicke();
      },
      onReleased: () {},
      margin: const EdgeInsets.only(right: 100, bottom: 1),
      priority: 100,
    );

    cam!.viewport.add(attackButtonComponent);
  }

  void _handleJoyStick() {
    switch (joystickComponent.direction) {
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
      case JoystickDirection.left:
        if (!player.isAttack) {
          player.playerDirectionMove = -1;
        }

        break;
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
      case JoystickDirection.right:
        if (!player.isAttack) {
          player.playerDirectionMove = 1;
        }
        break;
      case JoystickDirection.up:
      default:
        player.playerDirectionMove = 0;
        break;
    }
  }
}
