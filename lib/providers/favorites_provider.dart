import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/meal.dart';

class FavoriteMalesNotifier extends StateNotifier<List<Meal>> {
  FavoriteMalesNotifier() : super([]);

  bool toggleMaelFavoriteStatus(Meal meal) {
    final mealIsFavorite = state.contains(meal);
    if (mealIsFavorite) {
      state = state.where((m) => m.id != meal.id).toList();
      return false;
    } else {
      state = [...state, meal];
      return true;
    }
  }
}

final favoriteMalesProvider =
    StateNotifierProvider<FavoriteMalesNotifier, List<Meal>>(
  (ref) => FavoriteMalesNotifier(),
);
