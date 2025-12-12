import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../application/home/model/featured_model.dart';
import 'featured_carousel.dart';

class FeaturedCarouselSection extends StatelessWidget {
  final Function(FeaturedModel item, GoRouter router) handleFeaturedItemTap;
  final List<FeaturedModel> featuredItems;

  const FeaturedCarouselSection({
    required this.featuredItems,
    required this.handleFeaturedItemTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FeaturedCarousel(
      items: featuredItems,
      onItemTap: (item, index) {
        handleFeaturedItemTap(item, GoRouter.of(context));
      },
    );
  }
}
