import 'package:duration/duration.dart';
import 'package:flutter/material.dart';

enum RecipeType {
  curry,
  slowcooker,
  chicken,
  beef,
  fish,
  vegetarian,
  porkandlamb,
  dough,
  sides,
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
      case RecipeType.dough:
        return "Dough";
        break;
      case RecipeType.desserts:
        return "Desserts";
        break;
      case RecipeType.vegetarian:
        return "Vegetarian";
        break;
      case RecipeType.sides:
        return "Sides/Snacks";
      default:
        throw Exception("Unknown type");
    }
  }

  String get typeName {
    return this.toString().substring("RecipeType.".length);
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
      case RecipeType.dough:
        return Icons.restaurant;
        break;
      case RecipeType.desserts:
        return Icons.restaurant;
        break;
      case RecipeType.vegetarian:
        return Icons.restaurant;
        break;
      case RecipeType.sides:
        return Icons.restaurant;
      default:
        throw Exception("Unknown type");
    }
  }
}

class Recipe {
  final String id;
  final List<RecipeType> types;
  final String name;
  final Duration duration;
  final int serves;
  final List<String> ingredients;
  final List<String> preparation;
  final String imageURL;

  const Recipe({
    this.id,
    this.types,
    this.name,
    this.duration,
    this.serves,
    this.ingredients,
    this.preparation,
    this.imageURL,
  });

  String get getDurationString => prettyDuration(this.duration);

  Recipe.fromMap(Map<String, dynamic> data, String id)
      : this(
          id: id,
          types: (data['types'] as List<dynamic>)
              .map((e) => typeFromString(e))
              .toList(),
          name: data['name'],
          duration: Duration(minutes: data['duration']),
          serves: data['serves'],
          ingredients: new List<String>.from(data['ingredients']),
          preparation: new List<String>.from(data['preparation']),
          imageURL: data['image'],
        );

  static RecipeType typeFromString(String typeString) {
    switch (typeString) {
      case "curry":
        return RecipeType.curry;

      case "slowcooker":
        return RecipeType.slowcooker;

      case "chicken":
        return RecipeType.chicken;

      case "beef":
        return RecipeType.beef;

      case "fish":
        return RecipeType.fish;

      case "vegetarian":
        return RecipeType.vegetarian;

      case "porkandlamb":
        return RecipeType.porkandlamb;

      case "dough":
        return RecipeType.dough;

      case "desserts":
        return RecipeType.desserts;
      case "sides":
        return RecipeType.sides;
      default:
        throw Exception("unknown recipe type");
    }
  }
}
