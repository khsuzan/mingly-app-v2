import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mingly/src/screens/protected/favourite/controller/favourite_controller.dart';

import '../../../../components/home.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GetBuilder<FavouriteController>(
      init: FavouriteController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: theme.colorScheme.surface,
            automaticallyImplyLeading: false,
            title: Text(
              'Favourites',
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
                controller.getFavouriteList();
                return Future.delayed(Duration(milliseconds: 800));
              },
              child: Obx(() {
                if (controller.isLoading.value) {
                  return CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ],
                  );
                }

                if (controller.favouriteList.isEmpty) {
                  return CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Text(
                            'No favourites yet',
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: controller.favouriteList.length,
                  itemBuilder: (context, index) {
                    final fav = controller.favouriteList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: InkWell(
                        onTap: () => context.push('/event-detail', extra: fav),
                        child: EventCardSmall(
                          title: fav.eventName.toString(),
                          location:
                              "${fav.venue?.name.toString()}, ${fav.venue?.city.toString()}",
                          image: fav.images?.firstOrNull?.imageUrl ?? "",
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
