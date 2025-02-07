import 'package:flutter/material.dart';
import 'package:meals_app/data/meal.dart';
import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/main_drawer.dart';

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

  void _setScreen(String identifier) {
    if (identifier == 'filters') {
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = CategoriesScreen(
      onToggleFavorite: _toggleMealFavoriteStates,
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
