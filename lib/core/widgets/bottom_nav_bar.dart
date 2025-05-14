import 'package:flutter/material.dart';
import '../constants/app_colors.dart'; // Assuming AppColors is in core/constants

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Uses the BottomNavigationBarThemeData from main.dart
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon:
              Icon(Icons.calendar_today_outlined), // Or tasks icon from design
          activeIcon: Icon(Icons.calendar_today),
          label: 'Leaves', // Or 'Tasks'
        ),
        // The design has FAB in the middle, but your request skips "Services".
        // If "Tasks" is a separate tab:
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.task_alt_outlined),
        //   activeIcon: Icon(Icons.task_alt),
        //   label: 'Tasks',
        // ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: currentIndex,
      onTap: onTap,
      // type: BottomNavigationBarType.fixed, // Already set in theme
      // selectedItemColor: AppColors.primary, // Already set in theme
      // unselectedItemColor: AppColors.greyText, // Already set in theme
    );
  }
}
