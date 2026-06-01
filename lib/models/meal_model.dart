import 'food_model.dart';

class Meal {
  final String mealType; // Breakfast, Lunch, Dinner, Snack
  final List<Food> foods;
  final DateTime date;

  Meal({
    required this.mealType,
    required this.foods,
    required this.date,
  });

  double get totalCalories {
    return foods.fold(0.0, (sum, food) => sum + food.calories);
  }

  double get totalProtein {
    return foods.fold(0.0, (sum, food) => sum + food.protein);
  }

  double get totalCarbs {
    return foods.fold(0.0, (sum, food) => sum + food.carbs);
  }

  double get totalFat {
    return foods.fold(0.0, (sum, food) => sum + food.fat);
  }

  Map<String, dynamic> toJson() {
    return {
      'mealType': mealType,
      'foods': foods.map((f) => f.toJson()).toList(),
      'date': date.toIso8601String(),
    };
  }

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      mealType: json['mealType'] as String,
      foods: (json['foods'] as List<dynamic>)
          .map((f) => Food.fromJson(f as Map<String, dynamic>))
          .toList(),
      date: DateTime.parse(json['date'] as String),
    );
  }
}