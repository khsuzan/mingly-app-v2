import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingly/src/screens/protected/home_screen/home_screen.dart';
import 'package:mingly/src/screens/protected/my_reservation_screen/my_reservation_screen.dart';
import 'package:mingly/src/screens/protected/notification_screen/notification_screen.dart';
import 'package:mingly/src/screens/protected/profile_screen/view/profile_screen.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final Widget? child;
  const CustomBottomNavigationBar({super.key, this.child  });

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;

  final List<_NavItem> _items = [
    _NavItem('Home', 'home', '/home'),
    _NavItem('Reservations', 'reservation', '/my-reservation'),
    _NavItem('Favourite', 'favourite', '/favourite'),
    _NavItem('Notification', 'notification', '/notification'),
    _NavItem('Profile', 'profile', '/profile'),
  ];

  
  final List<Widget> _pages = [
    const HomeScreen(),
     MyReservationScreen(),
    MyReservationScreen(),
   NotificationScreen(),
   ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(child: Stack(
        children: [
          // Display the current page (passed in from the shell route)
          widget.child ?? _pages[_selectedIndex],
        Positioned(child: Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: kBottomNavigationBarHeight * 1.5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final isSelected = _selectedIndex == index;
              final iconPath = isSelected
                  ? 'lib/assets/icons/${item.asset}_selected.svg'
                  : 'lib/assets/icons/${item.asset}.svg';
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      iconPath,
                      width: 36.w,
                      semanticsLabel: item.label,
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    ))
        ],
      )),
    );

    
  }
}

class _NavItem {
  final String label;
  final String asset;
  String? path;
   _NavItem(this.label, this.asset, this.path);
}
