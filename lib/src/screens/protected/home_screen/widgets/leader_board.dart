import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../application/home/model/leader_board_model.dart';
import '../../../../constant/app_urls.dart';

class Leaderboard extends StatelessWidget {
  final List<LeaderBoardModel> data;

  const Leaderboard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TopThreeLeaderboard(data: data),
          SizedBox(height: 10.w),
          Divider(
            indent: 0,
            height: 1,
            color: Theme.of(context).colorScheme.onSurface.withAlpha(64),
          ),
          SizedBox(height: 10.w),
          _LeaderboardList(data: data),
        ],
      ),
    );
  }
}

class _TopThreeLeaderboard extends StatelessWidget {
  final List<LeaderBoardModel> data;

  const _TopThreeLeaderboard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Rank 2
        data.isEmpty
            ? SizedBox()
            : Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _RankAvatar(
                    rank: 2,
                    data: data[1],
                    radius: 36.h,
                    isCenter: false,
                  ),
                ),
              ),
        // Rank 1
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.center,
            child: _RankAvatar(
              rank: 1,
              data: data.isNotEmpty ? data[0] : null,
              radius: 40.h,
              isCenter: true,
            ),
          ),
        ),
        // Rank 3
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.centerRight,
            child: _RankAvatar(
              rank: 3,
              data: data.length > 2 ? data[2] : null,
              radius: 40.h,
              isCenter: false,
            ),
          ),
        ),
      ],
    );
  }
}

class _RankAvatar extends StatelessWidget {
  final int rank;
  final LeaderBoardModel? data;
  final double radius;
  final bool isCenter;

  const _RankAvatar({
    required this.rank,
    required this.data,
    required this.radius,
    required this.isCenter,
  });

  String _getDisplayName() => (data?.fullName?.trim().isEmpty ?? true)
      ? 'Unknown'
      : data!.fullName!.trim();

  String _getAvatarUrl() {
    if (data?.avatar == null || data!.avatar!.isEmpty) {
      return 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png';
    }
    return AppUrls.imageUrlApp + data!.avatar!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          rank.toString(),
          style: TextStyle(
            color: isCenter
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context).colorScheme.onSurface.withAlpha(128),
            fontWeight: isCenter ? FontWeight.bold : FontWeight.normal,
            fontSize: isCenter ? 15.sp : 12.sp,
          ),
        ),
        SizedBox(height: 8.h),
        CircleAvatar(
          radius: radius,
          backgroundColor: Colors.grey.shade800,
          child: ClipOval(
            child: Image.network(
              _getAvatarUrl(),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.network(
                'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                fit: BoxFit.cover,
              ),
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        SizedBox(
          width: 76.w,
          child: Text(
            _getDisplayName(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(182),
              fontSize: 13.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          data?.points.toString() ?? 'N/A',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(136),
            fontSize: 11.sp,
          ),
        ),
      ],
    );
  }
}

class _LeaderboardList extends StatelessWidget {
  final List<LeaderBoardModel> data;

  const _LeaderboardList({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(data.length, (index) {
        if (index != 0 && index != 1 && index != 2) {
          return _LeaderboardListItem(rank: index + 1, data: data[index]);
        }
        return SizedBox();
      }),
    );
  }
}

class _LeaderboardListItem extends StatelessWidget {
  final int rank;
  final LeaderBoardModel data;

  const _LeaderboardListItem({required this.rank, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          SizedBox(
            width: 22.w,
            child: Text(
              '$rank',
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
                AppUrls.imageUrlApp + data.avatar.toString(),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.network(
                  'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                  fit: BoxFit.cover,
                ),
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  data.fullName.toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  '${data.points}',
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
  }
}
