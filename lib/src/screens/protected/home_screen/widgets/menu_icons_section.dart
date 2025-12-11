import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'menu_icon.dart';

class MenuIconsSection extends StatelessWidget {
  final BuildContext context;

  const MenuIconsSection({required this.context, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MenuIcon(
            svgAsset: 'lib/assets/icons/calendar.svg',
            label: 'Events',
            onTap: () => context.push('/event-list'),
          ),
          MenuIcon(
            svgAsset: 'lib/assets/icons/map.svg',
            label: 'Venues',
            onTap: () => context.push('/venue-list'),
          ),
          MenuIcon(
            svgAsset: 'lib/assets/icons/coupon.svg',
            label: 'Membership',
            onTap: () => context.push('/membership'),
          ),
          MenuIcon(
            svgAsset: 'lib/assets/icons/bottle.svg',
            label: 'My Menu',
            onTap: () => context.push('/my-menu'),
          ),
        ],
      ),
    );
  }
}
