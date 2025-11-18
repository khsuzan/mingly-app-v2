import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mingly/src/components/helpers.dart';
import 'package:mingly/src/constant/app_urls.dart';

import '../../../../application/venue_menu/model/venue_menu_model.dart';
import '../controller/venue_menu_controller.dart';

class VenueMenuScreen extends StatelessWidget {
  final int venueId;
  const VenueMenuScreen({super.key, required this.venueId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = Get.put(_MenuCartController());

    return GetBuilder<VenueMenuController>(
      init: VenueMenuController(venueId: venueId),
      builder: (controller) {
        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: theme.colorScheme.surface,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'Food Menu',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: RefreshIndicator(
                onRefresh: () {
                  controller.fetchVenueMenu();
                  return Future.delayed(Duration(seconds: 1));
                },
                child: Obx(() {
                  if (controller.isVenueMenuLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final list = controller.menuList;
                  if (list.isEmpty) {
                    return const CustomScrollView(
                      slivers: [
                        SliverFillRemaining(
                          child: Center(child: Text('No menu items available')),
                        ),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          itemCount: list.length,
                          separatorBuilder: (_, __) {
                            return const SizedBox(height: 8);
                          },
                          itemBuilder: (context, index) {
                            final item = list[index];
                            final id = item.id ?? index;
                            return _MenuItemRow(
                              menuItem: item,
                              id: id,
                              cart: cart,
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 8),
                      _CheckoutBar(
                        cart: cart,
                        theme: theme,
                        onCheckout: () {
                          controller.checkoutToPayment(context);
                        },
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MenuItemRow extends StatelessWidget {
  final VenueMenuModel menuItem;
  final int id;
  final _MenuCartController cart;
  const _MenuItemRow({
    required this.menuItem,
    required this.id,
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    final image = menuItem.image ?? '';
    final title = menuItem.name ?? '';
    final desc = menuItem.description ?? '';
    final priceStr = menuItem.price ?? '0';
    final price = double.tryParse(priceStr) ?? 0.0;

    return Card(
      color: Colors.grey.shade900,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(8),
                image: image.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage("${AppUrls.imageUrl}$image"),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: image.isEmpty
                  ? const Icon(Icons.fastfood, color: Colors.white54)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (desc.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      desc,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    '\$${price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Color(0xFFD1B26F),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Obx(() {
              final qty = cart.qtyFor(id);
              return Row(
                children: [
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.remove, color: Colors.white),
                      onPressed: qty > 0
                          ? () => cart.changeQty(
                              id,
                              -1,
                              unitPrice: price,
                              title: title,
                            )
                          : null,
                    ),
                  ),
                  SizedBox(
                    width: 36,
                    child: Center(
                      child: Text(
                        qty.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () =>
                          cart.changeQty(id, 1, unitPrice: price, title: title),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _CheckoutBar extends StatelessWidget {
  final _MenuCartController cart;
  final ThemeData theme;
  final Function() onCheckout;
  const _CheckoutBar({
    required this.cart,
    required this.theme,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final subtotal = cart.subtotal;
      final discount = cart.discountAmount;
      final total = cart.total;
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Subtotal',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${subtotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (discount > 0) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Discount -\$${discount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                      const SizedBox(height: 4),
                      Text(
                        'Total \$${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Color(0xFFD1B26F),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 48,
                  child:
                  PrimaryButton(text: 'Checkout', onPressed: onCheckout),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

/// Small Getx controller for local cart state.
class _MenuCartController extends GetxController {
  final RxMap<int, _CartLine> _items = <int, _CartLine>{}.obs;
  final TextEditingController promoController = TextEditingController();
  final RxDouble _discount = 0.0.obs;

  bool get isEmpty => _items.isEmpty;
  int qtyFor(int id) => _items[id]?.qty ?? 0;

  double get subtotal {
    double s = 0.0;
    for (final v in _items.values) {
      s += v.unitPrice * v.qty;
    }
    return s;
  }

  double get discountAmount => _discount.value;
  double get total => (subtotal - discountAmount).clamp(0.0, double.infinity);

  void changeQty(
    int id,
    int delta, {
    required double unitPrice,
    String? title,
  }) {
    final line = _items[id];
    if (line == null) {
      if (delta > 0) {
        _items[id] = _CartLine(
          qty: delta,
          unitPrice: unitPrice,
          title: title ?? '',
        );
      }
    } else {
      final newQty = max(0, line.qty + delta);
      if (newQty == 0) {
        _items.remove(id);
      } else {
        _items[id] = line.copyWith(qty: newQty);
      }
    }
    // RxMap changes notify Obx automatically
  }

  void applyPromo() {
    final code = promoController.text.trim();
    if (code.isEmpty) {
      _discount.value = 0.0;
      return;
    }
    // example: DISCOUNT10 => 10% off
    if (code == 'DISCOUNT10') {
      _discount.value = subtotal * 0.10;
      Get.snackbar(
        'Promo',
        '10% discount applied',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      _discount.value = 0.0;
      Get.snackbar(
        'Promo',
        'Invalid promo code',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// convert to booking payload
  Map<String, dynamic> toBookingPayload({String promo = ''}) {
    return {
      'items': _items.entries
          .map((e) => {'menu_id': e.key, 'quantity': e.value.qty})
          .toList(),
      'promo_code': promo,
    };
  }
}

class _CartLine {
  final int qty;
  final double unitPrice;
  final String title;
  _CartLine({required this.qty, required this.unitPrice, required this.title});
  _CartLine copyWith({int? qty, double? unitPrice, String? title}) => _CartLine(
    qty: qty ?? this.qty,
    unitPrice: unitPrice ?? this.unitPrice,
    title: title ?? this.title,
  );
}
