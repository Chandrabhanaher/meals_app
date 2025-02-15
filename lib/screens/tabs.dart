import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:meals_app/data/meal.dart';
import 'package:meals_app/providers/favorites_provider.dart';
import 'package:meals_app/providers/filter_provider.dart';
import 'package:meals_app/providers/meals_provider.dart';
import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/screens/fliters.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/main_drawer.dart';

const kInitialFilters = {
  FilterData.glutenFree: false,
  FilterData.lactoseFree: false,
  FilterData.vegetarian: false,
  FilterData.vegan: false
};

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedIndex = 0;
  // final List<Meal> _favoritesMeals = [];
  // Map<FilterData, bool> _selectFilters = kInitialFilters;

  // void _showMessage(String message) {
  //   ScaffoldMessenger.of(context).clearSnackBars();
  //   ScaffoldMessenger.of(context)
  //       .showSnackBar(SnackBar(content: Text(message)));
  // }

  // void _toggleMealFavoriteStates(Meal meal) {
  //   final isExisting = _favoritesMeals.contains(meal);

  //   setState(() {
  //     if (isExisting) {
  //       _favoritesMeals.remove(meal);
  //       _showMessage('Meal is no longer a favorite');
  //     } else {
  //       _favoritesMeals.add(meal);
  //       _showMessage('Marked as a favorite');
  //     }
  //   });
  // }

  void _selectedPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      // final result = await Navigator.of(context).push<Map<FilterData, bool>>(
      await Navigator.of(context).push<Map<FilterData, bool>>(
        MaterialPageRoute(
          builder: (ctx) =>
              const FilterScreen(), //currentFilters: _selectFilters
        ),
      );
      // setState(() {
      //   _selectFilters = result ?? kInitialFilters;
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    final meals = ref.watch(mealsProvider);

    final activeFilters = ref.watch(filterProvider);

    final availableMeals = meals.where((meal) {
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

    Widget activePage = CategoriesScreen(
      // onToggleFavorite: _toggleMealFavoriteStates,
      availableMeals: availableMeals,
    );
    String activePageTitle = 'Categories';

    switch (_selectedIndex) {
      case 1:
        final favoriteMeals = ref.watch(favoriteMalesProvider);
        activePage = MealsScreen(
          meal: favoriteMeals,
          // meal: _favoritesMeals,
          // onToggleFavorite: _toggleMealFavoriteStates,
        );
        activePageTitle = 'My Favorites';
        break;
      default:
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(onSelectScreen: _setScreen),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        // onTap: (index) {
        //   _selectedPage(index);
        // },
        onTap: _selectedPage,
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
