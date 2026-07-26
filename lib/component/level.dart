import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pirate_action/component/collision_block.dart';
import 'package:pirate_action/component/main_player.dart';
import 'package:pirate_action/component/sword_component.dart';
import 'package:pirate_action/main_game.dart';

class Level extends World with HasGameReference<MainGame> {
  //final Player player;
  final String levelTitle;
  final MainPlayer player;

  Level({required this.levelTitle, required this.player});

  // create tiled component
  late TiledComponent level;

  // list of all collision object
  List<CollisionBlock> allCollisionBlocks = [];

  @override
  FutureOr<void> onLoad() async {
    // load tiled component from assets
    level = await TiledComponent.load("$levelTitle.tmx", Vector2.all(32));

    //debugMode = true;

    _loadCollisionObject();

    _loadAllObjects();

    add(level);

    add(player);

    return super.onLoad();
  }

  void _loadCollisionObject() {
    // get object from tiled
    final getCollisionObject = level.tileMap.getLayer<ObjectGroup>(
      "Collisions",
    );

    if (getCollisionObject != null) {
      // loop through all object
      for (final object in getCollisionObject.objects) {
        // check object class
        switch (object.class_) {
          case "Platform":
            // get posiiton and size
            Vector2 getPosition = object.position;
            Vector2 getSize = object.size;

            // create collision object
            final collisionPlatform = CollisionBlock(
              positionInput: getPosition,
              sizeInput: getSize,
              isPlatform: true,
            );

            // add to level
            add(collisionPlatform);

            // add to list
            allCollisionBlocks.add(collisionPlatform);

            break;
          default:
            // get posiiton and size
            Vector2 getPosition = object.position;
            Vector2 getSize = object.size;

            // create collision object
            final collisionObject = CollisionBlock(
              positionInput: getPosition,
              sizeInput: getSize,
              isPlatform: false,
            );

            add(collisionObject);

            // add to list
            allCollisionBlocks.add(collisionObject);

            break;
        }
      }

      // assign list block to player class
      player.allCollisionBlock = allCollisionBlocks;
    }
  }

  // function to load all objects
  void _loadAllObjects() {
    // get object layer from tiles
    final getObjectTiles = level.tileMap.getLayer<ObjectGroup>("Spawn");

    if (getObjectTiles != null) {
      // loop through all objects
      for (final object in getObjectTiles.objects) {
        // check on object class name
        switch (object.class_) {
          case "Sword":
            // get position from object
            Vector2 getPosition = object.position;

            // create sword object
            SwordComponent swordComponent = SwordComponent(
              inputPosition: getPosition,
              inputSize: Vector2(56, 56),
            );

            // add to level
            add(swordComponent);
        }
      }
    }
  }
}
