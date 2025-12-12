import 'package:flutter/material.dart';

class SliverCategoryHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  SliverCategoryHeaderDelegate({required this.child});


  static const double _height = 44;
  @override
  double get minExtent => _height;
  @override
  double get maxExtent => _height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
  // Always return a widget with fixed height matching minExtent/maxExtent
  return SizedBox(height: _height, child: child);
  }

  @override
  bool shouldRebuild(covariant SliverCategoryHeaderDelegate oldDelegate) {
    return false;
  }
}