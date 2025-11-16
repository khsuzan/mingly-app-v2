import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends StatefulWidget {
  final Widget? child;
  const LandingPage({super.key, this.child});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;

  final List<_NavItem> _items = [
    _NavItem('Home', 'home', '/home'),
    _NavItem('My Bookings', 'mybookings', '/my-bookings'),
    _NavItem('Favourites', 'favourite', '/my-favorites'),
    _NavItem('Notification', 'notification', '/notification'),
    _NavItem('Profile', 'profile', '/profile'),
  ];

  void _onItemTapped(int index, BuildContext context) {
    setState(() => _selectedIndex = index);
    context.go(_items[index].path!); // 🔹 use go() instead of push()
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Current screen passed by ShellRoute
            widget.child ?? const SizedBox.shrink(),

            // Bottom Navigation
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
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
                  child: Container(
                    color: Colors.black,
                    height: kBottomNavigationBarHeight * 1.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(_items.length, (index) {
                        final item = _items[index];
                        final isSelected = _selectedIndex == index;
                        final iconPath = isSelected
                            ? 'lib/assets/icons/${item.asset}_selected.svg'
                            : 'lib/assets/icons/${item.asset}.svg';

                        return GestureDetector(
                          onTap: () => _onItemTapped(index, context),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                iconPath,

                                semanticsLabel: item.label,
                              ),
                             
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final String asset;
  final String? path;
  _NavItem(this.label, this.asset, this.path);
}
