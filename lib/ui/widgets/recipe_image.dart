import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RecipeImage extends StatelessWidget {
  final String imageURL;

  RecipeImage(this.imageURL);

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600;
    return AspectRatio(
      aspectRatio: 16.0 / (useMobileLayout ? 9.0 : 4.0),
      child: Hero(
        tag: imageURL,
        child: CachedNetworkImage(
        imageUrl: imageURL,
        placeholder: (context, url) => Center(child: SizedBox(width: 40.0, height: 40.0, child: CircularProgressIndicator())),
        errorWidget: (context, url, error) => Icon(Icons.error),
        fit: BoxFit.cover,
     ),
      )
    );
  }
}

