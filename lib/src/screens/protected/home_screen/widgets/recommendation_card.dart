import 'package:avatar_stack/animated_avatar_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingly/src/components/helpers.dart';
import 'package:mingly/src/constant/app_urls.dart';

class RecommendationCard extends StatelessWidget {
  final String title;
  final String location;
  final String tag;
  final String? image;
  final Function()? onTap;

  const RecommendationCard({super.key, 
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
                  child: Image.network(
                    AppUrls.imageUrl + (image ?? ""),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return NoImage();
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
                        location,
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
                          Expanded(flex: 30, child: SizedBox()),
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
