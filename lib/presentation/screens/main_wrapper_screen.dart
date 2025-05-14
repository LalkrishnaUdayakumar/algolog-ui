import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../presentation/providers/auth_provider.dart'; // For user data
import '../../presentation/providers/attendance_provider.dart';
import '../../presentation/providers/leave_provider.dart';
import '../../presentation/providers/user_provider.dart';
import 'home/home_screen.dart';
import 'leave/leave_list_screen.dart';
import 'profile/profile_screen.dart';
import '../../app_router.dart'; // For FAB action

class MainWrapperScreen extends StatefulWidget {
  const MainWrapperScreen({super.key});

  @override
  State<MainWrapperScreen> createState() => _MainWrapperScreenState();
}

class _MainWrapperScreenState extends State<MainWrapperScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    LeaveListScreen(), // Assuming "Tasks" is replaced by "Leaves" or handled inside Home/Profile
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // Fetch initial data for the logged-in user when this screen is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.currentUser != null) {
        final userId = authProvider.currentUser!.id;
        Provider.of<UserProvider>(context, listen: false)
            .fetchUserDetails(userId);
        Provider.of<AttendanceProvider>(context, listen: false)
            .fetchTodayAttendance(userId);
        Provider.of<LeaveProvider>(context, listen: false).fetchLeaves(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determine if FAB should be shown (e.g., only on LeaveListScreen)
    bool showFab = _selectedIndex == 1; // Index of LeaveListScreen

    return Scaffold(
      body: IndexedStack(
        // Use IndexedStack to preserve state of screens
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Leaves',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: showFab
          ? FloatingActionButton(
              onPressed: () {
                // Navigate to Leave Request Screen
                Navigator.of(context).pushNamed(AppRouter.leaveRequestRoute);
              },
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add, color: AppColors.white),
            )
          : null,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked, // Adjust if needed
    );
  }
}


// In MainWrapperScreen build method:
// bottomNavigationBar: CustomBottomNavBar(
//   currentIndex: _selectedIndex,
//   onTap: _onItemTapped,
// ),