import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/food_model.dart';
import '../models/meal_model.dart';
import '../services/storage_service.dart';

class CustomFoodCreatorScreen extends StatefulWidget {
  final String mealType;
  final DateTime? selectedDate;
  const CustomFoodCreatorScreen({super.key, required this.mealType, this.selectedDate});

  @override
  State<CustomFoodCreatorScreen> createState() => _CustomFoodCreatorScreenState();
}

class _CustomFoodCreatorScreenState extends State<CustomFoodCreatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _servingCtrl = TextEditingController(text: '100');
  final _caloriesCtrl = TextEditingController();
  final _proteinCtrl = TextEditingController();
  final _carbsCtrl = TextEditingController();
  final _fatCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _servingCtrl.dispose();
    _caloriesCtrl.dispose();
    _proteinCtrl.dispose();
    _carbsCtrl.dispose();
    _fatCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameCtrl.text.trim();
    final serving = double.tryParse(_servingCtrl.text) ?? 100.0;
    final calories = double.tryParse(_caloriesCtrl.text) ?? 0.0;
    final protein = double.tryParse(_proteinCtrl.text) ?? 0.0;
    final carbs = double.tryParse(_carbsCtrl.text) ?? 0.0;
    final fat = double.tryParse(_fatCtrl.text) ?? 0.0;

    final food = Food(
      name: name,
      servingSize: serving,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
    );

    final meal = Meal(
      mealType: widget.mealType,
      foods: [food],
      date: widget.selectedDate ?? DateTime.now(),
    );

    await StorageService.addMeal(meal);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logged "$name" to ${widget.mealType}!'),
          backgroundColor: AppColors.tertiaryContainer,
        ),
      );
      Navigator.of(context).pop(true); // Return success
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.arrow_back_rounded, color: AppColors.onSurface),
        ),
        title: Text(
          'Create Custom Food',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CUSTOM FOOD MACROS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.outline,
                    letterSpacing: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Name
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Food Name',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _nameCtrl,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.onSurface),
                        decoration: InputDecoration(
                          hintText: 'e.g. Grandma\'s Apple Pie',
                          hintStyle: const TextStyle(color: AppColors.outlineVariant, fontWeight: FontWeight.w400),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.outlineVariant)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Please enter a name';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Serving & Calories Row
                Row(
                  children: [
                    Expanded(
                      child: _buildCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Serving (g)',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.onSurfaceVariant),
                            ),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _servingCtrl,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.onSurface),
                              decoration: InputDecoration(
                                hintText: '100',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.outlineVariant)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              ),
                              validator: (v) {
                                if (v == null || double.tryParse(v) == null || double.parse(v) <= 0) return 'Invalid';
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Calories (kcal)',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.onSurfaceVariant),
                            ),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _caloriesCtrl,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primaryContainer),
                              decoration: InputDecoration(
                                hintText: '0',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.outlineVariant)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              ),
                              validator: (v) {
                                if (v == null || double.tryParse(v) == null || double.parse(v) < 0) return 'Invalid';
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Protein, Carbs, Fat macro row
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'MACRONUTRIENTS (grams)',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.outline, letterSpacing: 1.1),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _macroInputField(
                              label: 'Protein (g)',
                              controller: _proteinCtrl,
                              color: AppColors.teal,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _macroInputField(
                              label: 'Carbs (g)',
                              controller: _carbsCtrl,
                              color: AppColors.amber,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _macroInputField(
                              label: 'Fat (g)',
                              controller: _fatCtrl,
                              color: AppColors.blue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Log Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryContainer,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Save & Log Food',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _macroInputField({
    required String label,
    required TextEditingController controller,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.onSurface),
          decoration: InputDecoration(
            hintText: '0',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.outlineVariant)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          ),
          validator: (v) {
            if (v == null || double.tryParse(v) == null || double.parse(v) < 0) return 'Invalid';
            return null;
          },
        ),
      ],
    );
  }
}
