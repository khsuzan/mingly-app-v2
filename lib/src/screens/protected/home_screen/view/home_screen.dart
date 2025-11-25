import 'package:avatar_stack/animated_avatar_stack.dart'
    show AnimatedAvatarStack;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' show Obx;
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:go_router/go_router.dart';
import 'package:mingly/src/components/custom_snackbar.dart';
import 'package:mingly/src/components/helpers.dart';
import 'package:mingly/src/constant/app_urls.dart';
import 'package:mingly/src/screens/protected/home_screen/controller/home_controller.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../application/events/model/events_model.dart';
import '../../../../application/home/model/featured_model.dart';
import '../../../../application/home/model/leader_board_model.dart';
import '../../../../components/home.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
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
                                Row(
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
                                        controller
                                                .profile
                                                .value
                                                .data
                                                ?.address ??
                                            'Tap to select',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(color: Colors.white),
                                      ),
                                    ),
                                  ],
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
                  SliverToBoxAdapter(
                    child: Obx(() {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top image
                          CarouselSlider.builder(
                            itemCount: controller.featuredItems.length,
                            options: CarouselOptions(
                              height: 0.26.sh,
                              enlargeCenterPage: true,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 5),
                              viewportFraction: 0.8,
                              enlargeFactor: 0.2,
                            ),
                            itemBuilder: (context, index, realIndex) {
                              return GestureDetector(
                                onTap: () {
                                  final data = controller.featuredItems[index];
                                  if (data.imageableType == "venues" &&
                                      data.imageable?.runtimeType.toString() ==
                                          "ImageableVenue") {
                                    context.push(
                                      "/venue-detail",
                                      extra:
                                          (controller
                                                      .featuredItems[index]
                                                      .imageable
                                                  as ImageableVenue?)
                                              ?.toVenuesModel(),
                                    );
                                  } else if (data.imageableType == "eevents" &&
                                      data.imageable?.runtimeType.toString() ==
                                          "ImageableEvent") {
                                    context.push(
                                      "/event-detail",
                                      extra:
                                          (controller
                                                      .featuredItems[index]
                                                      .imageable
                                                  as ImageableEvent?)
                                              ?.toEventsModel(),
                                    );
                                  }
                                },
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 0,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              AppUrls.imageUrl +
                                                  controller
                                                      .featuredItems[index]
                                                      .imageUrl
                                                      .toString(),
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Padding(
                                        padding: EdgeInsets.all(16.0.w),
                                        child: Text(
                                          controller.featuredItems[index].title
                                              .toString(),
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                color: Colors.white,
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          // Referral code
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 8,
                            ).copyWith(top: 16),
                            child: Container(
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 8,
                              ),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Your Referral Code',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: theme.colorScheme.primary,
                                            ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Obx(() {
                                        final refferel =
                                            controller.profile.value.data ==
                                                null
                                            ? "N/A"
                                            : controller
                                                      .profile
                                                      .value
                                                      .data!
                                                      .referralCode ??
                                                  "N/A";
                                        return Text(
                                          refferel,
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        );
                                      }),
                                    ],
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () {
                                      Clipboard.setData(
                                        ClipboardData(text: 'XUYB895EW'),
                                      );
                                      CustomSnackbar.show(
                                        context,
                                        message: "Code copied: 'XUYB895EW'",
                                      );
                                    },
                                    child: SvgPicture.asset(
                                      'lib/assets/icons/copy.svg',
                                      colorFilter: const ColorFilter.mode(
                                        Color(0xFFD1B26F),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Menu icons
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _MenuIcon(
                                  svgAsset: 'lib/assets/icons/calendar.svg',
                                  label: 'Events',
                                  onTap: () {
                                    context.push('/event-list');
                                  },
                                ),
                                _MenuIcon(
                                  svgAsset: 'lib/assets/icons/map.svg',
                                  label: 'Venues',
                                  onTap: () {
                                    context.push('/venue-list');
                                  },
                                ),
                                _MenuIcon(
                                  svgAsset: 'lib/assets/icons/coupon.svg',
                                  label: 'Membership',
                                  onTap: () => context.push('/membership'),
                                ),
                                _MenuIcon(
                                  onTap: () => context.push('/my-menu'),
                                  svgAsset: 'lib/assets/icons/bottle.svg',
                                  label: 'My Menu',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Featured Venues
                          Obx(() {
                            if (controller.featuredVenues.isNotEmpty) {
                              return _SectionHeader(
                                title: 'Featured Venues',
                                onSeeAll: () {
                                  context.push('/venue-list');
                                },
                              );
                            }
                            return SizedBox();
                          }),
                          Obx(() {
                            if (controller.featuredVenues.isNotEmpty) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                ),
                                child: Column(
                                  children: List.generate(
                                    controller.featuredVenues.length,
                                    (index) {
                                      final image = controller
                                          .featuredVenues[index]
                                          .images
                                          ?.firstOrNull;
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8.0,
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            context.push(
                                              "/venue-detail",
                                              extra: controller
                                                  .featuredVenues[index],
                                            );
                                          },
                                          child: VenueCardSmall(
                                            image: image == null
                                                ? null
                                                : "${AppUrls.imageUrl}${image.imageUrl!}",
                                            title: controller
                                                .featuredVenues[index]
                                                .name!,
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
                            return SizedBox();
                          }),
                          SizedBox(height: 12.h),
                          // Popular Events
                          Obx(() {
                            if (controller.popularEvents.isEmpty) {
                              return SizedBox();
                            }
                            return _SectionHeader(title: 'Popular Events');
                          }),
                          Obx(() {
                            if (controller.popularEvents.isEmpty) {
                              return SizedBox();
                            }
                            return PopularEvents(
                              events: controller.popularEvents,
                            );
                          }),
                          Obx(() {
                            if (controller.popularEvents.isNotEmpty) {
                              return const SizedBox(height: 24);
                            }
                            return SizedBox();
                          }),
                          // Top 10 spenders
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Leaderboard',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontSize: 13.sp,
                                  ),
                                ),
                                Text(
                                  'Top 10 spenders',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Obx(() {
                            if (controller.topSpendersList.length >= 3) {
                              return _Leaderboard(
                                data: controller.topSpendersList,
                              );
                            }
                            return _LeaderboardPlaceholder(
                              count: controller.topSpendersList.length,
                              onInvite: () {
                                SharePlus.instance.share(
                                  ShareParams(
                                    text:
                                        'Discover great local events, venues and exclusive offers with Mingly!\n\nFind and book tables, earn rewards, and get personalised recommendations.\n\nDownload the app: https://mingly.org',
                                  ),
                                );
                              }, // or any callback
                              onHowToEarn: () => context.push('/membership'),
                            );
                          }),
                          // Recommendations
                          Obx(() {
                            if (controller.recommendationEvents.isEmpty) {
                              return SizedBox();
                            }
                            return _SectionHeader(
                              title: 'Recommendations for you',
                              isSeeAll: false,
                            );
                          }),
                          Obx(() {
                            if (controller.recommendationEvents.isEmpty) {
                              return SizedBox();
                            }
                            return Column(
                              children: List.generate(
                                controller.recommendationEvents.length,
                                (index) {
                                  final image = controller
                                      .recommendationEvents[index]
                                      .images
                                      ?.firstOrNull
                                      ?.imageUrl;
                                  return InkWell(
                                    onTap: () => context.push('/venue-detail'),
                                    child: _RecommendationCard(
                                      image: image != null
                                          ? "${AppUrls.imageUrl}$image"
                                          : 'https://via.placeholder.com/150', // fallback image
                                      title: controller
                                          .recommendationEvents[index]
                                          .eventName!,
                                      location:
                                          controller
                                              .recommendationEvents[index]
                                              .venue!
                                              .city ??
                                          "",
                                      tag: 'Gold member',
                                      onTap: () {
                                        context.push(
                                          "/event-detail",
                                          extra: controller
                                              .recommendationEvents[index],
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            );
                          }),
                          const SizedBox(height: 32),
                        ],
                      );
                    }),
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

class PopularEvents extends StatelessWidget {
  final List<EventsModel> events;
  const PopularEvents({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return events.isEmpty
        ? SizedBox()
        : Column(
            children: List.generate(events.length, (index) {
              final event = events[index];
              final image = event.images?.firstOrNull;
              return EventCardBig(
                imageUrl: image == null
                    ? null
                    : "${AppUrls.imageUrl}${image.imageUrl!}",
                name: event.eventName,
                onTap: () {
                  context.push("/event-detail", extra: event);
                },
              );
            }),
          );
  }
}

class _MenuIcon extends StatelessWidget {
  final String svgAsset;
  final String label;
  final VoidCallback? onTap;
  const _MenuIcon({required this.svgAsset, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          CircleAvatar(
            radius: 28.r,
            backgroundColor: Colors.grey.shade900,
            child: SvgPicture.asset(
              svgAsset,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
              width: 28.h,
              height: 28.h,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final bool isSeeAll;
  final Function()? onSeeAll;
  const _SectionHeader({
    required this.title,
    this.isSeeAll = true,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w900,
              fontSize: 15.sp,
            ),
          ),
          if (isSeeAll)
            InkWell(
              onTap: onSeeAll,
              child: Text(
                'See All',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 13.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Leaderboard extends StatelessWidget {
  final List<LeaderBoardModel> data;

  const _Leaderboard({required this.data});

  @override
  Widget build(BuildContext context) {
    // final homeProivder = context.watch<HomeProivder>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              data.isEmpty
                  ? SizedBox()
                  : Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            Text(
                              '2',
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withAlpha(128),
                              ),
                            ),
                            CircleAvatar(
                              radius: 36.h,
                              backgroundColor: Colors.grey.shade800,
                              child: ClipOval(
                                child: Image.network(
                                  AppUrls.imageUrlApp +
                                      data[1].avatar.toString(),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Image.network(
                                        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                                        fit: BoxFit.cover,
                                      ),
                                ),
                              ),
                            ),
                            Text(
                              (data[1].fullName?.trim().isEmpty ?? true)
                                  ? 'Unknown'
                                  : data[1].fullName!.trim(),
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withAlpha(182),
                                fontSize: 13.sp,
                              ),
                            ),
                            Text(
                              data[1].points.toString(),
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withAlpha(136),
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text(
                        '1',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp,
                        ),
                      ),
                      CircleAvatar(
                        radius: 40.h,
                        backgroundColor: Colors.grey.shade800,
                        child: ClipOval(
                          child: Image.network(
                            (data.isNotEmpty && data[0].avatar != null)
                                ? AppUrls.imageUrlApp + data[0].avatar!
                                : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.network(
                                  'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                                  fit: BoxFit.cover,
                                ),
                          ),
                        ),
                      ),

                      Text(
                        (data[0].fullName?.trim().isEmpty ?? true)
                            ? 'Unknown'
                            : data[0].fullName!.trim(),
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha(182),
                          fontSize: 13.sp,
                        ),
                      ),
                      Text(
                        data.isEmpty ? " N/A" : data[0].points.toString(),
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha(136),
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    children: [
                      Text(
                        '3',
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha(128),
                        ),
                      ),
                      CircleAvatar(
                        radius: 40.h,
                        backgroundColor: Colors.grey.shade800,
                        child: ClipOval(
                          child: Image.network(
                            (data[2].avatar != null)
                                ? AppUrls.imageUrlApp + data[2].avatar!
                                : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.network(
                                  'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                                  fit: BoxFit.cover,
                                ),
                          ),
                        ),
                      ),
                      Text(
                        (data[2].fullName?.trim().isEmpty ?? true)
                            ? 'Unknown'
                            : data[2].fullName!.trim(),
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha(182),
                          fontSize: 13.sp,
                        ),
                      ),
                      Text(
                        data.isEmpty ? "N/A" : data[2].points.toString(),
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha(136),
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.w),
          Divider(
            indent: 0,
            height: 1,
            color: Theme.of(context).colorScheme.onSurface.withAlpha(64),
          ),
          SizedBox(height: 10.w),
          // List of spenders
          ...List.generate(data.length, (index) {
            if (index != 0 && index != 1 && index != 2) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Row(
                  children: [
                    SizedBox(
                      width: 22.w,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 13.sp,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    CircleAvatar(
                      radius: 28.h,
                      backgroundColor: Colors.grey.shade800,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.network(
                          AppUrls.imageUrlApp + data[index].avatar.toString(),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.network(
                                'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                                fit: BoxFit.cover,
                              ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            data[index].fullName.toString(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            '${data[index].points}',
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withAlpha(128),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return SizedBox();
            }
          }),
        ],
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final String title;
  final String location;
  final String tag;
  final String? image;
  final Function()? onTap;
  const _RecommendationCard({
    required this.title,
    required this.location,
    required this.tag,
    required this.image,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: () async {
          onTap?.call();
        },
        child: Card(
          color: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12.r)),
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 140,
                  child: image != null
                      ? Image.network(
                          "https://www.directmobilityonline.co.uk/assets/img/noimage.png",
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          AppUrls.imageUrl + image!,
                          fit: BoxFit.contain,

                          errorBuilder: (context, error, stackTrace) {
                            if (error is NetworkImageLoadException &&
                                error.statusCode == 404) {
                              if (kDebugMode) {
                                print(
                                  "image error " + error.statusCode.toString(),
                                );
                              }
                              return Container(
                                width: 120,
                                height: 120,
                                color: Colors.grey[500],
                                child: const Icon(Icons.image_not_supported),
                              );
                            } else {
                              return Container(
                                width: 120,
                                height: 120,
                                color: Colors.grey[500],
                                child: const Icon(Icons.image_not_supported),
                              );
                            }
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title.toString(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'THU 26 May, 09:00 - FRI 27 May, 10:00',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            flex: 30,
                            child: AnimatedAvatarStack(
                              height: 30.w,
                              infoWidgetBuilder: (surplus, context) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(50.r),
                                  ),
                                  child: Center(
                                    child: Text(
                                      surplus > 0 ? '+$surplus' : '',
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onPrimary,
                                        fontSize: 12.sp,
                                        height: 1,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              avatars: [
                                for (var n = 0; n < 10; n++)
                                  NetworkImage(
                                    'https://i.pravatar.cc/150?img=$n',
                                  ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 30,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary
                                      .withAlpha((255 * 0.1).toInt()),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  'Free',
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LeaderboardPlaceholder extends StatelessWidget {
  final int count;
  final VoidCallback? onInvite;
  final VoidCallback? onHowToEarn;

  const _LeaderboardPlaceholder({
    this.count = 0,
    this.onInvite,
    this.onHowToEarn,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    final surface = theme.colorScheme.primaryContainer;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Card(
        color: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Top row: three placeholder avatars with ranks
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  final rank = i + 1;
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Container(
                          width: i == 1
                              ? 72
                              : 56, // winner slightly larger in center
                          height: i == 1 ? 72 : 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white24),
                            color: Colors.grey.shade800,
                          ),
                          child: Center(
                            child: Text(
                              rank.toString(),
                              style: TextStyle(
                                color: Colors.white54,
                                fontWeight: FontWeight.bold,
                                fontSize: i == 1 ? 20 : 16,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                          width: 76,
                          child: Text(
                            rank == 1 ? '—' : (rank == 2 ? '—' : '—'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),

              const SizedBox(height: 12),

              // Main text
              Text(
                count == 0
                    ? 'No top spenders yet'
                    : 'Not enough data to show the leaderboard',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Be the first to earn points at your favourite venues. Invite friends or make purchases to climb the leaderboard.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),

              const SizedBox(height: 14),

              // CTAs
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: onInvite,
                    icon: const Icon(Icons.person_add, color: Colors.black),
                    label: const Text(
                      'Invite',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.white12),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: onHowToEarn,
                    child: const Text('How to earn'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
