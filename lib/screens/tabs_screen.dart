import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/screens/category__screen.dart';
import 'package:meals_app/screens/meals_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});
  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  final List<Meal> _favoriteMeals = [];
  void _showInfoMessage({
    required String message,
    required Color color,
    required Meal meal,
    required IconData icon,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 5,
        // action: SnackBarAction(
        //   label: 'Undo',
        //   onPressed: () {
        //     ScaffoldMessenger.of(context).clearSnackBars();
        //     final mealIndex = _favoriteMeals.indexOf(meal);
        //     _favoriteMeals.insert(mealIndex, meal);
        //   },
        // ),
      ),
    );
  }

  void _toggleMealFavoriteStatus(Meal meal) {
    final isExisting = _favoriteMeals.contains(meal);

    setState(() {
      if (isExisting) {
        _favoriteMeals.remove(meal);
        _showInfoMessage(
          icon: Icons.clear,
          message: '${meal.title} is removed from favorites',
          color: Colors.red,
          meal: meal,
        );
      } else {
        _favoriteMeals.add(meal);
        _showInfoMessage(
          icon: Icons.check,
          message: '${meal.title} has been added to favorites.',
          color: Colors.green,
          meal: meal,
        );
      }
    });
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = CategoryScreen(
      onToggleFavorite: _toggleMealFavoriteStatus,
    );
    var activePageTitle = 'Categories';
    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: _favoriteMeals,
        onToggleFavorite: _toggleMealFavoriteStatus,
      );
      activePageTitle = 'Favorites';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal_outlined),
            label: 'Category',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorite'),
        ],
        onTap: _selectPage,
      ),
    );
  }
}
