import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:mingly/src/application/home/model/leader_board_model.dart';
import 'package:mingly/src/constant/app_urls.dart';

import '../controller/leader_board_controller.dart';

class LeaderBoardScreen extends StatelessWidget {
  const LeaderBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetBuilder<LeaderBoardController>(
      init: LeaderBoardController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: theme.colorScheme.surface,
            title: Text(
              'Leaderboard',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () {
                controller.fetchTopSpenders();
                return Future.delayed(const Duration(milliseconds: 800));
              },
              child: Obx(() {
                return _Leaderboard(
                  isLoading: controller.isLoading.value,
                  list: controller.topSpendersList,
                );
              }),
            ),
          ),
        );
      },
    );
  }
}

class _Leaderboard extends StatelessWidget {
  final bool isLoading;
  final List<LeaderBoardModel> list;
  const _Leaderboard({this.isLoading = false, this.list = const []});
  
  Color _rankColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFFFFD700); // gold
      case 1:
        return const Color(0xFFC0C0C0); // silver
      case 2:
        return const Color(0xFFCD7F32); // bronze
      default:
        return Colors.transparent;
    }
  }

  Widget _rankBadge(int index, BuildContext context) {
    final theme = Theme.of(context);
    // only show special badge for top 3
    if (index > 2) {
      return SizedBox(width: 40.w);
    }

    final color = _rankColor(index);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.12),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: EdgeInsets.all(8.r),
          child: Icon(
            Icons.emoji_events,
            color: Colors.white,
            size: 18.sp,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          '${index + 1}',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return CustomScrollView(
        slivers: [
          const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          ),
        ],
      );
    }
    if (list.isEmpty) {
      return CustomScrollView(
        slivers: [
          SliverFillRemaining(
            child: Center(
              child: Text(
                'No data available',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
        ],
      );
    }
    return ListView.builder(
      itemBuilder: (context, index) {
        final item = list[index];
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
                    AppUrls.imageUrlNgrok + item.avatar.toString(),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.network(
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
                      item.fullName.toString(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      '${item.points}',
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withAlpha(128),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              // Right-side badge for top 3
              _rankBadge(index, context),
            ],
          ),
        );
      },
      itemCount: list.length,
    );
  }
}
