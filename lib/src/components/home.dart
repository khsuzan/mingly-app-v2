import 'package:avatar_stack/animated_avatar_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constant/app_urls.dart';
import 'helpers.dart';

class VenueCardSmall extends StatelessWidget {
  final String? image;
  final String title;
  final String location;
  const VenueCardSmall({
    super.key,
    required this.image,
    required this.title,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120.w,
              height: 90.h,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: (image == null || image!.isEmpty)
                    ? const NoImage()
                    : Image.network(image!, fit: BoxFit.cover),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(location, style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventCardBig extends StatelessWidget {
  final Function()? onTap;
  final String? imageUrl;
  final String? name;
  const EventCardBig({super.key, this.onTap, this.imageUrl, this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: () async {
          if (onTap != null) {
            onTap!();
          }
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
                  height: 160,
                  child: imageUrl == null || imageUrl!.isEmpty
                      ? Image.network(
                          "https://www.directmobilityonline.co.uk/assets/img/noimage.png",
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          AppUrls.imageUrl + imageUrl!,
                          fit: BoxFit.contain,
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name ?? '',
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

class EventCardSmall extends StatelessWidget {
  final String? image;
  final String title;
  final String location;
  const EventCardSmall({
    super.key,
    required this.image,
    required this.title,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120.w,
              height: 90.h,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: (image == null || image!.isEmpty)
                    ? const NoImage()
                    : Image.network(
                        AppUrls.imageUrl + image!,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(location, style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
