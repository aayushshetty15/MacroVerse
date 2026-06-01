import '../models/userprofile_model.dart';
import 'calorie_service.dart';

class MacroService {

  static double carbGoal(UserProfile user) {
    final targetCalories = CalorieService.calculateTargetCalories(user);

    final proteinCalories = CalorieService.proteinGoal(user) * 4;
    final fatCalories = CalorieService.fatGoal(user) * 9;

    final remainingCalories = targetCalories - proteinCalories - fatCalories;

    return remainingCalories / 4;
  }
}