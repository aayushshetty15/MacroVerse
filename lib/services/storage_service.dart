import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/userprofile_model.dart';
import '../models/meal_model.dart';
import '../models/weight_entry_model.dart';

class StorageService {
  static UserProfile? _userProfile;
  static SharedPreferences? _prefs;

  static const String _profileKey = 'user_profile';
  static const String _mealsKey = 'logged_meals';

  static final List<Meal> meals = [];

  static final List<WeightEntry> weightEntries = [];

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    
    // Load profile
    final jsonStr = _prefs?.getString(_profileKey);
    if (jsonStr != null) {
      try {
        _userProfile = UserProfile.fromJson(json.decode(jsonStr) as Map<String, dynamic>);
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing user profile from SharedPreferences: $e');
        }
      }
    }

    // Load meals
    final mealsJsonStr = _prefs?.getString(_mealsKey);
    if (mealsJsonStr != null) {
      try {
        final List<dynamic> decoded = json.decode(mealsJsonStr) as List<dynamic>;
        meals.clear();
        meals.addAll(decoded.map((m) => Meal.fromJson(m as Map<String, dynamic>)));
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing meals from SharedPreferences: $e');
        }
      }
    }
  }

  static Future<void> saveUserProfile(UserProfile profile) async {
    _userProfile = profile;
    await _prefs?.setString(_profileKey, json.encode(profile.toJson()));
  }

  static UserProfile? getUserProfile() {
    return _userProfile;
  }

  static Future<void> addMeal(Meal meal) async {
    meals.add(meal);
    await _saveMealsToPrefs();
  }

  static Future<void> removeMealAt(int index) async {
    if (index >= 0 && index < meals.length) {
      meals.removeAt(index);
      await _saveMealsToPrefs();
    }
  }

  static Future<void> _saveMealsToPrefs() async {
    final list = meals.map((m) => m.toJson()).toList();
    await _prefs?.setString(_mealsKey, json.encode(list));
  }

  static List<Meal> getMeals() {
    return meals;
  }

  static void addWeightEntry(WeightEntry entry) {
    weightEntries.add(entry);
  }

  static List<WeightEntry> getWeightEntries() {
    return weightEntries;
  }

  static Future<void> clearAllData() async {
    _userProfile = null;
    meals.clear();
    weightEntries.clear();
    await _prefs?.remove(_profileKey);
    await _prefs?.remove(_mealsKey);
  }
}