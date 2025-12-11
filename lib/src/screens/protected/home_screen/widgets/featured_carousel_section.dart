import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mingly/src/screens/protected/home_screen/controller/home_controller.dart';
import 'featured_carousel.dart';

class FeaturedCarouselSection extends StatelessWidget {
  final HomeController controller;
  final BuildContext context;

  const FeaturedCarouselSection({
    required this.controller,
    required this.context,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FeaturedCarousel(
      items: controller.featuredItems,
      onItemTap: (item, index) {
        controller.handleFeaturedItemTap(item, GoRouter.of(context));
      },
    );
  }
}
