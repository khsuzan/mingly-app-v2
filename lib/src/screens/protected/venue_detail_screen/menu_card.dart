// flutter_menu_model_and_list.dart
// Contains: MenuItem model, sample data, MenuCard widget and MenuListScreen

import 'package:flutter/material.dart';
import 'package:mingly/src/application/venue_menu/model/venue_menu_model.dart';
import 'package:mingly/src/constant/app_urls.dart'; // add `intl: ^0.18.0` (or latest) to pubspec.yaml

/// Reusable MenuCard widget
class MenuCardVenue extends StatelessWidget {
  final VenueMenuModel item;
  final VoidCallback? onTap;

  const MenuCardVenue({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    // final priceText = NumberFormat.simpleCurrency(
    //   locale: Localizations.localeOf(context).toString(),
    // ).format(item.price);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: SizedBox(
          height: 110,
          child: Row(
            children: [
              // Image section
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: Image.network(
                  AppUrls.imageUrl + item.image!,
                  width: 110,
                  height: 110,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 110,
                    height: 110,
                    color: Colors.grey[500],
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),

              // Content section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item.name!,
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          // Quantity badge
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[500],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Qty ${item.quantity}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 2),

                      // Description
                      Text(
                        item.description!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const Spacer(),

                      // Price and button row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            double.parse(item.price!).toStringAsFixed(2),
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          // ElevatedButton(
                          //   onPressed: () {
                          //     // Default action: show a simple snackbar. Replace with your logic.
                          //     ScaffoldMessenger.of(context).showSnackBar(
                          //       SnackBar(content: Text('Added ${item.name}')),
                          //     );
                          //   },
                          //   child: const Text('Add'),
                          //   style: ElevatedButton.styleFrom(
                          //     backgroundColor: Colors.grey[800],
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(8),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
