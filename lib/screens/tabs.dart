import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/data/meal.dart';
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

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedIndex = 0;
  final List<Meal> _favoritesMeals = [];
  Map<FilterData, bool> _selectFilters = kInitialFilters;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _toggleMealFavoriteStates(Meal meal) {
    final isExisting = _favoritesMeals.contains(meal);

    setState(() {
      if (isExisting) {
        _favoritesMeals.remove(meal);
        _showMessage('Meal is no longer a favorite');
      } else {
        _favoritesMeals.add(meal);
        _showMessage('Marked as a favorite');
      }
    });
  }

  void _selectedPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      final result = await Navigator.of(context).push<Map<FilterData, bool>>(
        MaterialPageRoute(
          builder: (ctx) => FilterScreen(currentFilters: _selectFilters),
        ),
      );
      setState(() {
        _selectFilters = result ?? kInitialFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = dummyMeals.where((meal) {
      if (_selectFilters[FilterData.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (_selectFilters[FilterData.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (_selectFilters[FilterData.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if (_selectFilters[FilterData.vegan]! && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();

    Widget activePage = CategoriesScreen(
      onToggleFavorite: _toggleMealFavoriteStates,
      availableMeals: availableMeals,
    );
    String activePageTitle = 'Categories';

    switch (_selectedIndex) {
      case 1:
        activePage = MealsScreen(
          meal: _favoritesMeals,
          onToggleFavorite: _toggleMealFavoriteStates,
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
