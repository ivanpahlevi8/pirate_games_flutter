import 'package:flame/components.dart';
import 'package:pirate_action/main_game.dart';

class RegularPalmTree extends SpriteAnimationComponent
    with HasGameReference<MainGame> {
  final Vector2 inputPosition;
  final Vector2 inputSize;

  RegularPalmTree({required this.inputPosition, required this.inputSize})
      : super(position: inputPosition, size: inputSize);

  @override
  onLoad() {
    // get all images for animation
    List<String> allImages = [
      "Treasure Hunters/Palm Tree Island/Sprites/Back Palm Trees/Back Palm Tree Regular 01.png",
      "Treasure Hunters/Palm Tree Island/Sprites/Back Palm Trees/Back Palm Tree Regular 02.png",
      "Treasure Hunters/Palm Tree Island/Sprites/Back Palm Trees/Back Palm Tree Regular 03.png",
      "Treasure Hunters/Palm Tree Island/Sprites/Back Palm Trees/Back Palm Tree Regular 04.png",
    ];

    // load all images into sprite
    final loadedImages = allImages.map((image) {
      // get image
      final getImage = game.images.fromCache(image);

      // return sprite
      return Sprite(getImage);
    }).toList();

    // create animation
    animation = SpriteAnimation.spriteList(loadedImages, stepTime: 0.05);

    super.onLoad();
  }
}
