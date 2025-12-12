import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' show Obx;
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:go_router/go_router.dart';
import 'package:mingly/src/components/custom_dialog.dart';
import 'package:mingly/src/components/helpers.dart';
import 'package:mingly/src/constant/app_urls.dart';
import 'package:mingly/src/screens/protected/home_screen/controller/home_controller.dart';

import '../widgets/featured_carousel_section.dart';
import '../widgets/referral_code_section.dart';
import '../widgets/menu_icons_section.dart';
import '../widgets/featured_venues_section.dart';
import '../widgets/leaderboard_section.dart';
import '../widgets/recommendations_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        // Initialize the callbacks once
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.updateBuildContext(context);
          controller.setProfileCheckCallback((ctx) {
            showProfileUpdateDialog(ctx);
          });
        });

        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: FloatingActionButton(
              backgroundColor: Color(0xFFD1B26F),
              onPressed: () {
                context.push("/ai-chat");
              },
              child: Image.asset(
                "lib/assets/images/bot.png",
                height: 30,
                width: 30,
              ),
            ),
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () {
                controller.fetchHomeData();
                return Future.delayed(const Duration(seconds: 1));
              },
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    elevation: 0,
                    backgroundColor: theme.colorScheme.surface,
                    floating: true,
                    snap: true,
                    pinned: false,
                    toolbarHeight: 70.h,
                    title: null,
                    leadingWidth: 0,
                    surfaceTintColor: theme.colorScheme.surface,
                    flexibleSpace: Container(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Location',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                InkWell(
                                  onTap: () async {
                                    final location = await context.push(
                                      '/country-list',
                                    );
                                    if (location != null) {
                                      controller.setLocation(
                                        location as String,
                                      );
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        'lib/assets/icons/location.svg',
                                        colorFilter: const ColorFilter.mode(
                                          Color(0xFFD1B26F),
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      SizedBox(width: 4.w),
                                      Obx(
                                        () => Text(
                                          controller.userLocation.value.isEmpty
                                              ? 'Tap to select'
                                              : controller.userLocation.value,
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                context.push('/view-profile');
                              },
                              child: CircleAvatar(
                                radius: 20.r,
                                backgroundColor: Colors.grey.shade800,
                                child: ClipOval(
                                  child: Obx(() {
                                    final profileModel =
                                        controller.profile.value;
                                    final avatar = profileModel.data?.avatar;

                                    if (avatar != null && avatar.isNotEmpty) {
                                      debugPrint("profile image $avatar");
                                      // Avatar available
                                      return Image.network(
                                        AppUrls.imageUrlApp + avatar,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return NoImage();
                                            },
                                      );
                                    } else {
                                      // Avatar not available — show fallback asset
                                      return NoImage();
                                    }
                                  }),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Featured Carousel Section
                  SliverToBoxAdapter(
                    child: Obx(() {
                      return FeaturedCarouselSection(
                        featuredItems: controller.featuredItems.toList(),
                        handleFeaturedItemTap: controller.handleFeaturedItemTap,
                      );
                    }),
                  ),
                  // Referral Code Section
                  SliverToBoxAdapter(
                    child: ReferralCodeSection(controller: controller),
                  ),
                  // Menu Icons Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: MenuIconsSection(context: context),
                    ),
                  ),
                  // Featured Venues Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: FeaturedVenuesSection(
                        controller: controller,
                        context: context,
                      ),
                    ),
                  ),
                  // Leaderboard Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: LeaderboardSection(
                        controller: controller,
                        context: context,
                      ),
                    ),
                  ),
                  // Recommendations Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      child: RecommendationsSection(
                        controller: controller,
                        context: context,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Obx(() {
                      return controller.isRefreshing.value
                          ? SizedBox(
                              height: 100.h,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            )
                          : SizedBox();
                    }),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: kBottomNavigationBarHeight * 2),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
