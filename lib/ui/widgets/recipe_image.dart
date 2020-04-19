import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class RecipeImage extends StatelessWidget {
  final String imageURL;
  final bool detail;

  RecipeImage(this.imageURL, {this.detail = false});

  static double aspectRatio(BuildContext context, bool detail) {
    var shortestSide = MediaQuery.of(context).size.width;
    final bool useMobileLayout = shortestSide < 600;
    
    return 16.0 / (useMobileLayout ? 9.0 : detail ? 4.0 : 9.0);
  }

  @override
  Widget build(BuildContext context) {
    
    final double ratio = RecipeImage.aspectRatio(context, detail);
    return AspectRatio(
        aspectRatio: ratio,
        child: Hero(
          tag: imageURL,
          child: kIsWeb
              ? FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: imageURL,
                  fit: BoxFit.cover,
                )
              : CachedNetworkImage(
                  imageUrl: imageURL,
                  placeholder: (context, url) => Center(
                      child: SizedBox(
                          width: 40.0,
                          height: 40.0,
                          child: CircularProgressIndicator())),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
        ));
  }
}
