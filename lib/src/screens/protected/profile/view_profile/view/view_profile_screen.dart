import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:mingly/src/constant/app_urls.dart';

import '../../../../../components/custom_snackbar.dart';
import '../controller/view_profile_controller.dart';

class ViewProfileScreen extends StatelessWidget {
  const ViewProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<ViewProfileController>(
      init: ViewProfileController(),
      builder: (controller) {
        final theme = Theme.of(context);
        final primary = theme.colorScheme.primary;
        final surface = theme.colorScheme.surface;
        final profile = controller.profileModel.value.data;

        return Scaffold(
          backgroundColor: surface,
          appBar: AppBar(
            title: const Text('Profile'),
            backgroundColor: theme.colorScheme.primaryContainer,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header card with avatar and basic info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: Colors.grey.shade800,
                        backgroundImage:
                            (profile?.avatar != null &&
                                profile!.avatar!.isNotEmpty)
                            ? NetworkImage(
                                AppUrls.imageUrlApp + profile.avatar!,
                              )
                            : null,
                        child:
                            (profile?.avatar == null ||
                                profile!.avatar!.isEmpty)
                            ? Icon(Icons.person, color: Colors.white, size: 40)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (profile?.fullName == null ||
                                      profile!.fullName!.isEmpty)
                                  ? 'No name set'
                                  : profile.fullName!,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: primary.withAlpha((255 * 0.12).toInt()),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    _beautifyTier(profile?.membershipStatus),
                                    style: TextStyle(
                                      color: primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  profile?.referralCode != null
                                      ? 'Referral: ${profile!.referralCode}'
                                      : '',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Points',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${profile?.points ?? profile?.currentPoints ?? 0}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primary,
                                  ),
                                  onPressed: () =>
                                      context.push('/edit-profile'),
                                  child: const Text(
                                    'Edit Profile',
                                    style: TextStyle(color: Colors.black),
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

                const SizedBox(height: 16),

                // Points progress card
                Card(
                  color: theme.colorScheme.primaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Progress to next reward',
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                value: (profile?.progress ?? 0.0).clamp(
                                  0.0,
                                  1.0,
                                ),
                                color: primary,
                                backgroundColor: Colors.white12,
                                minHeight: 8,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${((profile?.progress ?? 0.0) * 100).toInt()}%',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Target: ${profile?.targetPoints ?? 0}',
                              style: TextStyle(color: Colors.white70),
                            ),
                            Text(
                              'Current: ${profile?.currentPoints ?? profile?.points ?? 0}',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Contact & address
                Card(
                  color: theme.colorScheme.primaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.phone, color: primary),
                        title: const Text(
                          'Phone',
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          profile?.mobile ?? 'N/A',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                      Divider(color: Colors.white12, height: 1),
                      ListTile(
                        leading: Icon(Icons.location_on, color: primary),
                        title: const Text(
                          'Address',
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          profile?.address ?? 'N/A',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Referral code with copy
                Card(
                  color: theme.colorScheme.primaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Your Referral Code',
                              style: TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              profile?.referralCode ?? '—',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(
                                text: profile?.referralCode == null
                                    ? ""
                                    : profile?.referralCode ?? "",
                              ),
                            );
                            CustomSnackbar.show(
                              context,
                              message:
                                  "Code copied: ${profile?.referralCode ?? ""}",
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

                const SizedBox(height: 24),

                // Actions
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.white12),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () => {}, // Placeholder for sign out action
                        child: const Text(
                          'Sign out',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () => context.push('/membership'),
                        child: const Text(
                          'Membership',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _beautifyTier(String? tier) {
    if (tier == null) return '';
    return tier
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() + w.substring(1) : '')
        .join(' ');
  }
}
