import 'package:flutter/material.dart';
import 'package:mingly/src/constant/app_urls.dart';
import 'package:mingly/src/screens/protected/profile_screen/profile_provider.dart';
import 'package:provider/provider.dart';


class ViewProfileScreen extends StatelessWidget {
  const ViewProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final profile = profileProvider.profileModel.data!;

    return Scaffold(
      backgroundColor: const Color(0xFF1F1E1C),
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: const Color(0xFF2E2D2C),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Image
            CircleAvatar(
              radius: 50,
              backgroundColor: const Color(0xFF3A3937),
              backgroundImage: profile.avatar != null
                  ? NetworkImage(AppUrls.imageUrlNgrok + profile.avatar!)
                  : null,
              child: profile.avatar == null
                  ? const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 35,
                    )
                  : null,
            ),
            const SizedBox(height: 20),

            // Name
            ListTile(
              leading: const Icon(Icons.person, color: Color(0xFFFFFAE5)),
              title: const Text('Full Name', style: TextStyle(color: Color(0xFFFAE7E7))),
              subtitle: Text(
                profile.fullName == "" ? "N/A" : profile.fullName.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 8),

            // Phone
            ListTile(
              leading: const Icon(Icons.phone, color: Color(0xFFFFFAE5)),
              title: const Text('Phone Number', style: TextStyle(color: Color(0xFFFAE7E7))),
              subtitle: Text(
                profile.mobile ?? "N/A",
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 8),

            // Country
            ListTile(
              leading: const Icon(Icons.location_on, color: Color(0xFFFFFAE5)),
              title: const Text('Country', style: TextStyle(color: Color(0xFFFAE7E7))),
              subtitle: Text(
                profile.address ?? "N/A",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
