import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:mingly/src/screens/protected/home_screen/controller/home_controller.dart';
import 'section_header.dart';
import 'recommendation_card.dart';

class RecommendationsSection extends StatelessWidget {
  final HomeController controller;
  final BuildContext context;

  const RecommendationsSection({
    required this.controller,
    required this.context,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      if (controller.userLocation.value.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Divider(
                  color: theme.colorScheme.primary.withAlpha(51),
                  thickness: 1,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Select your location to view recommendations',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD1B26F),
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () async {
                    final location = await context.push('/country-list');
                    if (location != null) {
                      controller.setLocation(location as String);
                    }
                  },
                  icon: const Icon(
                    Icons.location_on,
                    color: Colors.black,
                  ),
                  label: const Text(
                    'Select Location',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      if (controller.recommendationEvents.isEmpty) {
        return const SizedBox();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Recommendations for you',
            isSeeAll: false,
          ),
          Column(
            children: List.generate(
              controller.recommendationEvents.length,
              (index) {
                final image = controller.recommendationEvents[index].images?.firstOrNull?.imageUrl;
                final location = controller.recommendationEvents[index].venue!.address ??
                    controller.recommendationEvents[index].venue!.city ??
                    "";
                return RecommendationCard(
                  image: image,
                  title: controller.recommendationEvents[index].eventName!,
                  location: location,
                  tag: 'Gold member',
                  onTap: () {
                    context.push(
                      "/event-detail",
                      extra: controller.recommendationEvents[index],
                    );
                  },
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
