class Food {
  final String name;
  final double servingSize; // grams
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final String? imageAsset;

  Food({
    required this.name,
    required this.servingSize,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.imageAsset,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'servingSize': servingSize,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'imageAsset': imageAsset,
    };
  }

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      name: json['name'] as String,
      servingSize: (json['servingSize'] as num).toDouble(),
      calories: (json['calories'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      imageAsset: json['imageAsset'] as String?,
    );
  }
}