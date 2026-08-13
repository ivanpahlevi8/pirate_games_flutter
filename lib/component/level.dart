import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pirate_action/component/barrel_component.dart';
import 'package:pirate_action/component/cannon_trap/canon.dart';
import 'package:pirate_action/component/collision_block.dart';
import 'package:pirate_action/component/head_trap/tottem_head.dart';
import 'package:pirate_action/component/left_palm_tree.dart';
import 'package:pirate_action/component/main_player.dart';
import 'package:pirate_action/component/regular_palm_tree.dart';
import 'package:pirate_action/component/right_plam_tree.dart';
import 'package:pirate_action/component/seashell_trap/seashell.dart';
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

            break;
          case "Barrel":
            // get position
            Vector2 getPositionInput = object.position;

            // create barrel object
            BarrelComponent barrelComponent = BarrelComponent(
              inputPosition: getPositionInput,
              inputSize: Vector2(64, 64),
            );

            add(barrelComponent);

            break;
          case "leftPalmTree":
            // get position
            Vector2 getPosition = object.position;
            Vector2 getSize = object.size;

            // create left tree object
            LeftPalmTree leftTreeObject = LeftPalmTree(
              inputPosition: getPosition,
              inputSize: getSize,
            );

            add(leftTreeObject);

            break;
          case "regularPalmTree":
            // get position
            Vector2 getPosition = object.position;
            Vector2 getSize = object.size;

            // create left tree object
            RegularPalmTree regularPalmTree = RegularPalmTree(
              inputPosition: getPosition,
              inputSize: getSize,
            );

            add(regularPalmTree);

            break;
          case "rightPlamTree":
            // get position
            Vector2 getPosition = object.position;
            Vector2 getSize = object.size;

            // create right tree object
            RightPlamTree rightPalmTree = RightPlamTree(
              inputPosition: getPosition,
              inputSize: getSize,
            );

            add(rightPalmTree);

            break;
          case "cannon":
            // get position
            Vector2 getPosition = object.position;
            Vector2 getSize = object.size;

            // create canon object
            Canon cannonObject = Canon(
              inputPosition: getPosition,
              inputSize: getSize,
            );

            add(cannonObject);

            break;
          case "Seashell":
            // get position
            Vector2 getPosition = object.position;
            Vector2 getSize = object.size;

            // create seashell
            Seashell seashell =
                Seashell(inputPosition: getPosition, inputSize: getSize);

            add(seashell);

            break;
          case "tottemHead":
            // get position
            Vector2 getPosition = object.position;

            // get properties
            int getHeadOption =
                object.properties.getValue<int>("headOption") ?? 1;
            int getShapeOption =
                object.properties.getValue<int>("shapeOption") ?? 1;

            // add tottem head
            add(TottemHead(
                inputPosition: getPosition,
                headOption: getHeadOption,
                shapeOption: getShapeOption));

            break;
        }
      }
    }
  }
}
