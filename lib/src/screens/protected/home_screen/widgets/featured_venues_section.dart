import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:mingly/src/components/home.dart';
import 'package:mingly/src/screens/protected/home_screen/controller/home_controller.dart';
import 'section_header.dart';

class FeaturedVenuesSection extends StatelessWidget {
  final HomeController controller;
  final BuildContext context;

  const FeaturedVenuesSection({
    required this.controller,
    required this.context,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          if (controller.featuredVenues.isNotEmpty) {
            return SectionHeader(
              title: 'Featured Venues',
              onSeeAll: () => context.push('/venue-list'),
            );
          }
          return const SizedBox();
        }),
        Obx(() {
          if (controller.featuredVenues.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: List.generate(
                  controller.featuredVenues.length,
                  (index) {
                    final image = controller.featuredVenues[index].images?.firstOrNull;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: InkWell(
                        onTap: () => context.push(
                          "/venue-detail",
                          extra: controller.featuredVenues[index],
                        ),
                        child: VenueCardSmall(
                          image: image?.imageUrl,
                          title: controller.featuredVenues[index].name!,
                          location:
                              '${controller.featuredVenues[index].address}\n${controller.featuredVenues[index].city}, ${controller.featuredVenues[index].country}',
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }
          return const SizedBox();
        }),
      ],
    );
  }
}
