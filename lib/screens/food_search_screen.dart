import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/food_model.dart';
import 'add_food_screen.dart';
import 'custom_food_creator.dart';

class FoodSearchScreen extends StatefulWidget {
  final String mealType;
  final DateTime? selectedDate;
  const FoodSearchScreen({super.key, required this.mealType, this.selectedDate});

  @override
  State<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends State<FoodSearchScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';
  int _selectedFilter = 0;

  final List<String> _filterLabels = ['Recent', 'Frequent', 'My Meals'];
  final List<IconData> _filterIcons = [
    Icons.history_rounded,
    Icons.star_border_rounded,
    Icons.restaurant_menu_rounded,
  ];

  // Local premium food database (Indian-Specific & Protein-Rich with multiple varieties)
  final List<Food> _foodDb = [
    // ── Egg Options ────────────────────────────────────────
    Food(
      name: 'Hard Boiled Egg (High Protein)',
      servingSize: 100,
      calories: 155,
      protein: 13,
      carbs: 1.1,
      fat: 11,
      imageAsset: 'https://images.unsplash.com/photo-1587486913049-53fc88980cfc?w=300&q=80',
    ),
    Food(
      name: 'Half Boiled Egg (Soft Boiled - Protein Rich)',
      servingSize: 100,
      calories: 143,
      protein: 12.6,
      carbs: 0.8,
      fat: 9.5,
      imageAsset: 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=300&q=80',
    ),
    Food(
      name: 'Egg Bhurji (3 Eggs - Indian Style)',
      servingSize: 150,
      calories: 240,
      protein: 20,
      carbs: 3,
      fat: 16,
      imageAsset: 'https://images.unsplash.com/photo-1608039829572-78524f79c4c7?w=300&q=80',
    ),
    Food(
      name: 'Egg Omelette (Double Egg - Premium)',
      servingSize: 120,
      calories: 180,
      protein: 14,
      carbs: 2,
      fat: 13,
      imageAsset: 'https://images.unsplash.com/photo-1494597564530-871f2b93ac55?w=300&q=80',
    ),
    Food(
      name: 'Egg Masala Curry (Protein Rich)',
      servingSize: 200,
      calories: 220,
      protein: 15,
      carbs: 8,
      fat: 14,
      imageAsset: 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?w=300&q=80',
    ),

    // ── Paneer Options ──────────────────────────────────────
    Food(
      name: 'Paneer Tikka (Tandoori Style)',
      servingSize: 150,
      calories: 278,
      protein: 18,
      carbs: 6,
      fat: 21,
      imageAsset: 'https://images.unsplash.com/photo-1567188040759-fb8a883dc6d8?w=300&q=80',
    ),
    Food(
      name: 'Paneer Bhurji (High Protein)',
      servingSize: 150,
      calories: 298,
      protein: 15,
      carbs: 8,
      fat: 22,
      imageAsset: 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=300&q=80',
    ),
    Food(
      name: 'Low-Fat Palak Paneer (High Protein)',
      servingSize: 200,
      calories: 220,
      protein: 15,
      carbs: 8,
      fat: 14,
      imageAsset: 'https://images.unsplash.com/photo-1601050690597-df056fb4ce78?w=300&q=80',
    ),
    Food(
      name: 'Paneer Butter Masala (Rich Protein)',
      servingSize: 200,
      calories: 380,
      protein: 16,
      carbs: 10,
      fat: 31,
      imageAsset: 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=300&q=80',
    ),

    // ── Chicken Options ─────────────────────────────────────
    Food(
      name: 'Tandoori Chicken (Protein Rich)',
      servingSize: 200,
      calories: 300,
      protein: 38,
      carbs: 4,
      fat: 14,
      imageAsset: 'https://images.unsplash.com/photo-1610057099443-fde8c4d50f91?w=300&q=80',
    ),
    Food(
      name: 'Chicken Biryani (Lean Chicken)',
      servingSize: 350,
      calories: 548,
      protein: 34,
      carbs: 68,
      fat: 16,
      imageAsset: 'https://images.unsplash.com/photo-1633945274405-b6c8069047b0?w=300&q=80',
    ),
    Food(
      name: 'Butter Chicken (Lean Chicken)',
      servingSize: 200,
      calories: 420,
      protein: 30,
      carbs: 12,
      fat: 28,
      imageAsset: 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=300&q=80',
    ),
    Food(
      name: 'Grilled Chicken Breast (Lean Protein)',
      servingSize: 150,
      calories: 240,
      protein: 42,
      carbs: 0,
      fat: 5,
      imageAsset: 'https://images.unsplash.com/photo-1532550907401-a500c9a57435?w=300&q=80',
    ),
    Food(
      name: 'Chicken Masala Curry (Indian Style)',
      servingSize: 200,
      calories: 290,
      protein: 28,
      carbs: 6,
      fat: 16,
      imageAsset: 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?w=300&q=80',
    ),

    // ── Soya Options ────────────────────────────────────────
    Food(
      name: 'Soya Chunks Bhurji (Protein Rich)',
      servingSize: 150,
      calories: 220,
      protein: 24,
      carbs: 18,
      fat: 6,
      imageAsset: 'https://images.unsplash.com/photo-1584269600464-37b1b58a9fe7?w=300&q=80',
    ),
    Food(
      name: 'Soya Chunk Curry (High Protein)',
      servingSize: 200,
      calories: 240,
      protein: 25,
      carbs: 22,
      fat: 8,
      imageAsset: 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=300&q=80',
    ),
    Food(
      name: 'Roasted Soya Chunks (Healthy Snack)',
      servingSize: 50,
      calories: 170,
      protein: 21,
      carbs: 14,
      fat: 3,
      imageAsset: 'https://images.unsplash.com/photo-1511690656952-34342bb7c2f2?w=300&q=80',
    ),

    // ── Fish Options ────────────────────────────────────────
    Food(
      name: 'Fish Tikka (Tandoori Grilled - Protein Rich)',
      servingSize: 150,
      calories: 210,
      protein: 26,
      carbs: 2,
      fat: 10,
      imageAsset: 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=300&q=80',
    ),
    Food(
      name: 'Bengali Fish Curry (Rahu Masala)',
      servingSize: 200,
      calories: 250,
      protein: 22,
      carbs: 5,
      fat: 15,
      imageAsset: 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?w=300&q=80',
    ),

    // ── Dal, Grains & Seeds ────────────────────────────────
    Food(
      name: 'High-Protein Moong Dal Khichdi',
      servingSize: 300,
      calories: 290,
      protein: 13,
      carbs: 48,
      fat: 6,
      imageAsset: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=300&q=80',
    ),
    Food(
      name: 'Dal Tadka (High Protein Lentils)',
      servingSize: 200,
      calories: 160,
      protein: 9.5,
      carbs: 24,
      fat: 3.5,
      imageAsset: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=300&q=80',
    ),
    Food(
      name: 'Chana Masala (Chickpea Curry)',
      servingSize: 200,
      calories: 230,
      protein: 11,
      carbs: 35,
      fat: 5,
      imageAsset: 'https://images.unsplash.com/photo-1585938338392-50a59970d8ee?w=300&q=80',
    ),
    Food(
      name: 'Sattu Protein Drink (High Protein)',
      servingSize: 250,
      calories: 180,
      protein: 14,
      carbs: 24,
      fat: 3,
      imageAsset: 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=300&q=80',
    ),
    Food(
      name: 'Sprouted Moong Salad (High Protein)',
      servingSize: 200,
      calories: 180,
      protein: 14,
      carbs: 26,
      fat: 1.5,
      imageAsset: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=300&q=80',
    ),
    Food(
      name: 'Double-Protein Indian Curd (Dahi)',
      servingSize: 150,
      calories: 120,
      protein: 12,
      carbs: 6,
      fat: 5,
      imageAsset: 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=300&q=80',
    ),
    Food(
      name: 'High-Protein Besan Chilla',
      servingSize: 120,
      calories: 210,
      protein: 12,
      carbs: 28,
      fat: 5,
      imageAsset: 'https://images.unsplash.com/photo-1668236543090-82eba5ee5976?w=300&q=80',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() {
      setState(() {
        _query = _searchCtrl.text;
      });
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Food> get _filteredFoods {
    if (_query.trim().isEmpty) {
      return _foodDb.take(4).toList(); // Show a couple recent ones
    }
    return _foodDb
        .where((f) => f.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final results = _filteredFoods;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildSearchBar(),
                    const SizedBox(height: 16),
                    _buildFilterChips(),
                    const SizedBox(height: 24),
                    
                    // Conditionally render query results or recent lists
                    if (_query.trim().isEmpty) ...[
                      _buildSectionHeader('Recent Foods'),
                      const SizedBox(height: 12),
                      _buildFoodsList(results),
                      const SizedBox(height: 28),
                      _buildSectionHeader('Frequent Meals'),
                      const SizedBox(height: 12),
                      _buildFrequentMealsRow(),
                    ] else ...[
                      _buildSectionHeader('Search Results (${results.length})'),
                      const SizedBox(height: 12),
                      if (results.isEmpty)
                        _buildNoResultsCard()
                      else
                        _buildFoodsList(results),
                    ],
                    
                    const SizedBox(height: 24),
                    _buildCreateCustomFoodShortcut(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Top Bar ──────────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: AppColors.onSurface,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add to ${widget.mealType}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              const Text(
                'Search or create custom entries',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.outline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Search Bar ───────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            const Icon(
              Icons.search_rounded,
              color: AppColors.outline,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _searchCtrl,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurface,
                ),
                decoration: const InputDecoration(
                  hintText: 'Search food, brands, or recipes...',
                  hintStyle: TextStyle(
                    color: AppColors.outlineVariant,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            if (_query.isNotEmpty)
              IconButton(
                onPressed: () => _searchCtrl.clear(),
                icon: const Icon(Icons.close_rounded, color: AppColors.outline, size: 18),
              ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  // ── Filter Chips ─────────────────────────────────────────────────────────
  Widget _buildFilterChips() {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: _filterLabels.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final isSelected = i == _selectedFilter;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryContainer
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.transparent : AppColors.outlineVariant,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primaryContainer.withValues(alpha: 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _filterIcons[i],
                    size: 16,
                    color: isSelected ? Colors.white : AppColors.outline,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _filterLabels[i],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Section Header ───────────────────────────────────────────────────────
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.onSurface,
        ),
      ),
    );
  }

  // ── Foods List ───────────────────────────────────────────────────────────
  Widget _buildFoodsList(List<Food> foods) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: foods.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final f = foods[i];
        return GestureDetector(
          onTap: () async {
            final navigator = Navigator.of(context);
            final logged = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FoodDetailsScreen(
                  food: f,
                  mealType: widget.mealType,
                  selectedDate: widget.selectedDate,
                ),
              ),
            );
            if (logged == true && mounted) {
              navigator.pop(true); // Propagate reload trigger
            }
          },
          child: Container(
            padding: const EdgeInsets.all(14),
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
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: f.imageAsset != null
                      ? Image.network(
                          f.imageAsset!,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => _buildFallbackIcon(),
                        )
                      : _buildFallbackIcon(),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        f.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Serving Size: ${f.servingSize.round()}g',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.outline,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${f.calories.round()}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryContainer,
                      ),
                    ),
                    const Text(
                      'kcal',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.outline,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Frequent Meals Row ───────────────────────────────────────────────────
  Widget _buildFrequentMealsRow() {
    // Show cards referencing pre-populated standard meals
    final frequent = [
      _foodDb[0], // Tandoori Chicken
      _foodDb[1], // Paneer Tikka
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: frequent.map((f) {
          return Expanded(
            child: GestureDetector(
              onTap: () async {
                final navigator = Navigator.of(context);
                final logged = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoodDetailsScreen(
                      food: f,
                      mealType: widget.mealType,
                      selectedDate: widget.selectedDate,
                    ),
                  ),
                );
                if (logged == true && mounted) {
                  navigator.pop(true);
                }
              },
              child: Container(
                margin: EdgeInsets.only(
                  right: f == frequent.last ? 0 : 12,
                ),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 100,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        child: f.imageAsset != null
                            ? Image.network(
                                f.imageAsset!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => _buildFrequentFallback(),
                              )
                            : _buildFrequentFallback(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            f.name,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${f.calories.round()} kcal',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── No Results Card ──────────────────────────────────────────────────────
  Widget _buildNoResultsCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const Icon(Icons.search_off_rounded, color: AppColors.outlineVariant, size: 48),
            const SizedBox(height: 12),
            const Text(
              'No matching food items found',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Try adjusting your keywords or register a custom food entry.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.outline,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                final logged = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomFoodCreatorScreen(
                      mealType: widget.mealType,
                      selectedDate: widget.selectedDate,
                    ),
                  ),
                );
                if (logged == true && mounted) {
                  navigator.pop(true);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryContainer,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text('Create Custom Food'),
            ),
          ],
        ),
      ),
    );
  }

  // ── Create Custom Food Shortcut ──────────────────────────────────────────
  Widget _buildCreateCustomFoodShortcut() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F5FC),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE1E5F2)),
        ),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Can\'t find your food?',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Create and log a custom macro profile.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                final logged = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomFoodCreatorScreen(
                      mealType: widget.mealType,
                      selectedDate: widget.selectedDate,
                    ),
                  ),
                );
                if (logged == true && mounted) {
                  navigator.pop(true);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primaryContainer,
                elevation: 0,
                side: const BorderSide(color: Color(0xFFD1D8EC)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Create Custom'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackIcon() {
    return Container(
      width: 48,
      height: 48,
      color: const Color(0xFFEAF0FF),
      child: const Icon(
        Icons.restaurant_outlined,
        color: AppColors.primaryContainer,
        size: 22,
      ),
    );
  }

  Widget _buildFrequentFallback() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFEAEEFF), Color(0xFFD5E2FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Icon(
        Icons.fastfood_rounded,
        color: AppColors.primaryContainer,
        size: 32,
      ),
    );
  }
}
