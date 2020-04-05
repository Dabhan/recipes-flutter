import 'package:duration/duration.dart';
import 'package:flutter/material.dart';

enum RecipeType {
  curry,
  slowcooker,
  chicken,
  porkandlamb,
  beef,
  fish,
  bread,
  desserts,
}

extension RecipeTypeExtension on RecipeType {
  String get name {
    switch (this) {
      
      case RecipeType.curry:
        return "Curry";
        break;
      case RecipeType.slowcooker:
        return "Slow Cooker";
        break;
      case RecipeType.chicken:
        return "Chicken";
        break;
      case RecipeType.porkandlamb:
        return "Pork and Lamb";
        break;
      case RecipeType.beef:
        return "Beef";
        break;
      case RecipeType.fish:
        return "Fish";
        break;
      case RecipeType.bread:
        return "Bread";
        break;
      case RecipeType.desserts:
        return "Desserts";
        break;
    }
  }
IconData get icon {
    switch (this) {
      
      case RecipeType.curry:
        return Icons.restaurant;
        break;
      case RecipeType.slowcooker:
        return Icons.restaurant;
        break;
      case RecipeType.chicken:
        return Icons.restaurant;
        break;
      case RecipeType.porkandlamb:
        return Icons.restaurant;
        break;
      case RecipeType.beef:
        return Icons.restaurant;
        break;
      case RecipeType.fish:
        return Icons.restaurant;
        break;
      case RecipeType.bread:
        return Icons.restaurant;
        break;
      case RecipeType.desserts:
        return Icons.restaurant;
        break;
    }
  }

}

class Recipe {
  final String id;
  final RecipeType type;
  final String name;
  final Duration duration;
  final List<String> ingredients;
  final List<String> preparation;
  final String imageURL;

  const Recipe({
    this.id,
    this.type,
    this.name,
    this.duration,
    this.ingredients,
    this.preparation,
    this.imageURL,
  });

  String get getDurationString => prettyDuration(this.duration);

  Recipe.fromMap(Map<String, dynamic> data, String id)
      : this(
          id: id,
          type: RecipeType.values[data['type']],
          name: data['name'],
          duration: Duration(minutes: data['duration']),
          ingredients: new List<String>.from(data['ingredients']),
          preparation: new List<String>.from(data['preparation']),
          imageURL: data['image'],
        );

}