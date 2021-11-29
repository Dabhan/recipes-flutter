import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:recipes/model/recipe.dart';

class RecipeTitle extends StatelessWidget {
  final Recipe recipe;
  final double padding;

  RecipeTitle(this.recipe, this.padding);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        // Default value for crossAxisAlignment is CrossAxisAlignment.center.
        // We want to align title and description of recipes left:
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            recipe.name,
            style: Theme.of(context).textTheme.headline3,
          ),
          // Empty space:
          SizedBox(height: 10.0),
          Row(
            children: [
              Icon(Icons.timer, size: 20.0),
              SizedBox(width: 5.0),
              AutoSizeText(
                recipe.getDurationString,
                maxLines: 1,
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.people, size: 20.0),
              SizedBox(width: 5.0),
              AutoSizeText(
                "${recipe.serves}",
                maxLines: 1,
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
