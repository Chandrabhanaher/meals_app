import 'package:flutter_riverpod/flutter_riverpod.dart';

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
