import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../controller/country_list_controller.dart';

class CountryListScreen extends StatelessWidget {
  const CountryListScreen({super.key});

  Future<void> _showCityPicker(
    BuildContext context,
    CountryListController controller,
    String country,
  ) async {
    final cities = controller.countryCityMap[country] ?? [];
    final theme = Theme.of(context);
    final city = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Select City', style: theme.textTheme.titleLarge),
              ),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: cities.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    color: theme.dividerColor.withAlpha(20),
                  ),
                  itemBuilder: (ctx, i) => ListTile(
                    title: Text(cities[i]),
                    onTap: () => context.pop(cities[i]),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    if (city != null && context.mounted) {
      Navigator.of(context).pop(city);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetBuilder<CountryListController>(
      init: CountryListController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: theme.colorScheme.surface,
                elevation: 0,
                title: Text(
                  'Select Country',
                  style: TextStyle(color: theme.colorScheme.primary),
                ),
                centerTitle: true,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search country',
                      prefixIcon: Icon(
                        Icons.search,
                        color: theme.colorScheme.primary,
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surfaceContainerHighest,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 12,
                      ),
                    ),
                    onChanged: controller.onSearch,
                  ),
                ),
              ),
              Obx(() {
                if (controller.loading.value) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate((ctx, i) {
                    final country = controller.filteredCountries[i];
                    return ListTile(
                      title: Text(country),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () =>
                          _showCityPicker(context, controller, country),
                    );
                  }, childCount: controller.filteredCountries.length),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
