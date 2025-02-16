import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/providers/meals_provider.dart';

enum FilterData {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
}

class FilterNotifier extends StateNotifier<Map<FilterData, bool>> {
  FilterNotifier()
      : super({
          FilterData.glutenFree: false,
          FilterData.lactoseFree: false,
          FilterData.vegetarian: false,
          FilterData.vegan: false
        });

  void setFilters(Map<FilterData, bool> chosenFilters) {
    state = chosenFilters;
  }

  void setFilter(FilterData filter, bool isActive) {
    state = {
      ...state,
      filter: isActive,
    };
  }
}

final filterProvider =
    StateNotifierProvider<FilterNotifier, Map<FilterData, bool>>(
  (ref) => FilterNotifier(),
);

final filterMealsProvilder = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final activeFilters = ref.watch(filterProvider);
  return meals.where((meal) {
    if (activeFilters[FilterData.glutenFree]! && !meal.isGlutenFree) {
      return false;
    }
    if (activeFilters[FilterData.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }
    if (activeFilters[FilterData.vegetarian]! && !meal.isVegetarian) {
      return false;
    }
    if (activeFilters[FilterData.vegan]! && !meal.isVegan) {
      //_selectFilters
      return false;
    }
    return true;
  }).toList();
});
