class UserProfile {
  final String name;
  final int age;
  final String gender;
  final double height;
  final double weight;
  final double targetWeight;
  final String goal;
  final String activityLevel;

  UserProfile({
    required this.name,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    required this.targetWeight,
    required this.goal,
    required this.activityLevel,
  });

  UserProfile copyWith({
    String? name,
    int? age,
    String? gender,
    double? height,
    double? weight,
    double? targetWeight,
    String? goal,
    String? activityLevel,
  }) {
    return UserProfile(
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      targetWeight: targetWeight ?? this.targetWeight,
      goal: goal ?? this.goal,
      activityLevel: activityLevel ?? this.activityLevel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'gender': gender,
      'height': height,
      'weight': weight,
      'targetWeight': targetWeight,
      'goal': goal,
      'activityLevel': activityLevel,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String,
      age: json['age'] as int,
      gender: json['gender'] as String,
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      targetWeight: (json['targetWeight'] as num).toDouble(),
      goal: json['goal'] as String,
      activityLevel: json['activityLevel'] as String,
    );
  }
}