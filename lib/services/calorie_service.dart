import '../models/userprofile_model.dart';

class CalorieService {
  // Maintenance Calories (Mifflin-St Jeor)
  static double calculateMaintenanceCalories(UserProfile user) {
    double bmr;

    if (user.gender.toLowerCase() == 'male') {
      bmr =
          (10 * user.weight) +
          (6.25 * user.height) -
          (5 * user.age) +
          5;
    } else {
      bmr =
          (10 * user.weight) +
          (6.25 * user.height) -
          (5 * user.age) -
          161;
    }

    double activityMultiplier = switch (user.activityLevel) {
      'Sedentary' => 1.2,
      'Lightly Active' => 1.375,
      'Moderately Active' => 1.55,
      'Very Active' => 1.725,
      _ => 1.2,
    };

    return bmr * activityMultiplier;
  }

  // Goal Calories
  static double calculateTargetCalories(UserProfile user) {
    double maintenance = calculateMaintenanceCalories(user);

    switch (user.goal) {
      case 'Lose Weight':
        return maintenance - 500;

      case 'Gain Weight':
        return maintenance + 300;

      default:
        return maintenance;
    }
  }

  // Protein (g)
  static double proteinGoal(UserProfile user) {
    return user.weight * 2.0;
  }

  // Fat (g)
  static double fatGoal(UserProfile user) {
    return user.weight * 0.8;
  }
}