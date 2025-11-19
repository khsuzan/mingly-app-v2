import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mingly/src/components/custom_dialog.dart';
import 'package:mingly/src/components/helpers.dart';
import 'package:mingly/src/constant/app_urls.dart';
import 'package:mingly/src/screens/protected/profile/controller/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: theme.colorScheme.surface,
            automaticallyImplyLeading: false,
            title: Text(
              'Profile',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await controller.fetchProfile();
              return Future.delayed(Duration(milliseconds: 500));
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    // Profile Card
                    Obx(() {
                      return controller.isProfileInfoLoading.value
                          ? Center(child: CircularProgressIndicator())
                          : Card(
                              color: Color(0xFF2E2D2C),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: Color(0xFFFFFAE5),
                                  width: 0.5,
                                ),
                              ),
                              child: Card(
                                color: Color(0xFF2E2D2C),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Row(
                                        children: [
                                          Obx(() {
                                            final image =
                                                controller.profile.value.avatar;
                                            return CircleAvatar(
                                              radius: 28,
                                              backgroundImage: image == null
                                                  ? const AssetImage(
                                                      "lib/assets/images/noimage.png",
                                                    )
                                                  : NetworkImage(
                                                          AppUrls.imageUrlApp +
                                                              controller
                                                                  .profile
                                                                  .value
                                                                  .avatar
                                                                  .toString(),
                                                        )
                                                        as ImageProvider,
                                            );
                                          }),
                                          SizedBox(width: 12),
                                          Expanded(
                                            child: Obx(() {
                                              final name = controller
                                                  .profile
                                                  .value
                                                  .fullName;
                                              return Text(
                                                name ?? "",
                                                style: TextStyle(
                                                  color: const Color(0xFFFFFAE5),
                                                  fontSize: 16,
                                                  fontFamily: 'Lato',
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.75,
                                                ),
                                              );
                                            }),
                                          ),
                                          SizedBox(width: 12),
                                          IconButton(
                                            onPressed: () {
                                              context.push("/edit-profile");
                                            },
                                            icon: Icon(
                                              Icons.edit_note,
                                              color: theme.colorScheme.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                    }),
                    const SizedBox(height: 16),
                    // Membership Status Card
                    Card(
                      color: Color(0xFF2E2D2C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Color(0xFFFFFAE5), width: 0.5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Membership Status',
                              style: TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(() {
                                  return Text(
                                    controller.profile.value.membershipStatus ??
                                        "N/A",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }),
            
                                Obx(() {
                                  return Text(
                                    controller.profile.value.points.toString(),
                                    style: TextStyle(color: Colors.white70),
                                  );
                                }),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: Text(
                                "---------------------------------------------",
                              ),
                            ),
                            Row(
                              children: [
                                Obx(() {
                                  return Text(
                                    '${controller.profile.value.currentPoints} /',
                                    style: TextStyle(
                                      color: const Color(0xFFFFFAE5),
                                      fontSize: 24,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w400,
                                      height: 1.33,
                                    ),
                                  );
                                }),
                                Obx(() {
                                  return Text(
                                    '${controller.profile.value.targetPoints} IDR',
                                    style: TextStyle(
                                      color: const Color(0xFFB1A39E),
                                      fontSize: 12,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w400,
                                      height: 1.33,
                                    ),
                                  );
                                }),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Progress bar
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: 0.33,
                                minHeight: 8,
                                backgroundColor: Colors.white24,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  theme.colorScheme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'Gold',
                                  style: TextStyle(color: Colors.white70),
                                ),
                                Text(
                                  'Platinum',
                                  style: TextStyle(color: Colors.white70),
                                ),
                                Text(
                                  'Priority',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Menu List
                    _ProfileMenuItem(
                      icon: Icons.shopping_bag,
                      title: 'Orders History',
                      onTap: () {
                        context.push("/my-bookings");
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(height: 1, color: Colors.white24),
                    ),
                    _ProfileMenuItem(
                      icon: Icons.leaderboard,
                      title: 'Leaderboard',
                      onTap: () {
                        context.push("/leaderboard");
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(height: 1, color: Colors.white24),
                    ),
            
                    _ProfileMenuItem(
                      icon: Icons.book_online,
                      title: 'My Reservation',
                      onTap: () => context.push("/my-reservations"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(height: 1, color: Colors.white24),
                    ),
                    _ProfileMenuItem(
                      icon: Icons.history,
                      title: 'Point History',
                      onTap: () => context.push("/point-history"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(height: 1, color: Colors.white24),
                    ),
                    _ProfileMenuItem(
                      icon: Icons.card_giftcard,
                      title: 'Promo Code',
                      onTap: () => context.push("/promo-code"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(height: 1, color: Colors.white24),
                    ),
                    _ProfileMenuItem(
                      icon: Icons.logout,
                      title: 'Log Out',
                      onTap: () => showLogoutDialog(context),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailing;
  final Function()? onTap;
  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
        trailing: trailing != null
            ? Text(trailing!, style: const TextStyle(color: Colors.white70))
            : const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 12,
              ),
        onTap: onTap,
      ),
    );
  }
}
