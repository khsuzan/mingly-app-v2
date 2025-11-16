import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mingly/src/components/custom_loading_dialog.dart';
import 'package:mingly/src/components/custom_snackbar.dart';
import 'package:mingly/src/components/helpers.dart';
import 'package:mingly/src/screens/protected/booking_summary/widget/custom_confirm_dialog.dart';
import 'package:mingly/src/screens/protected/event_list_screen/events_provider.dart';
import 'package:mingly/src/screens/protected/my_menu/bottle_provider.dart';
import 'package:mingly/src/screens/protected/payment/payment_stripe_table.dart';
import 'package:mingly/src/screens/protected/venue_list_screen/venue_provider.dart';
import 'package:provider/provider.dart';

class BookingSummary extends StatelessWidget {
  const BookingSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final eventProvider = context.watch<EventsProvider>();
    final venueProvider = context.watch<VenueProvider>();
    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Color(0xFF1A1A1A),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Booking Summary',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white, size: 24),
            onPressed: () {
              // Refresh action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Section
            _buildStatusSection(),

            SizedBox(height: 24),

            // User Info Section
            _buildUserInfoSection(),

            SizedBox(height: 24),

            // Event Section
            // _buildEventSection(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(eventProvider.selectEventModel.eventName.toString()),
                SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.event, color: Colors.white),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fri, 26 Jan 2024',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Open gate at ${formatDate(eventProvider.eventDetailsModel.sessionStartTime.toString())}',
                          style: TextStyle(
                            color: const Color(0xFFB1A39E),
                            fontSize: 12,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w400,
                            height: 1.33,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.credit_card, color: Colors.white),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mastercard',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Tylor Howell',
                          style: TextStyle(
                            color: const Color(0xFFB1A39E),
                            fontSize: 12,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w400,
                            height: 1.33,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.event_rounded, color: Colors.white),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Outlet', style: TextStyle(color: Colors.white)),
                        Text(
                          '${eventProvider.eventDetailsModel.city}\nCity - Country',
                          style: TextStyle(
                            color: const Color(0xFFB1A39E),
                            fontSize: 12,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w400,
                            height: 1.33,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            // SizedBox(height: 24),

            // Guest Section
            // _buildGuestSection(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  'Booking Details',
                  style: TextStyle(
                    color: const Color(0xFFFFFAE5),
                    fontSize: 14,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w500,
                    height: 1.43,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    SvgPicture.asset("lib/assets/icons/Table.svg"),
                    SizedBox(width: 10),
                    Text(
                      'Table',
                      style: TextStyle(
                        color: const Color(0xFFFFFAE5),
                        fontSize: 14,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w500,
                        height: 1.43,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),

            Container(
              width: double.infinity,
              decoration: const BoxDecoration(color: Color(0xFF2E2D2C)),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14.0,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("No :"),
                        Text("${eventProvider.tableBooking.seatId}"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [Text("Full Payment :"), Text("\$15.00")],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Minimum Charge :"),
                        Text("\$20.00"),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [Text("Tax :"), Text("\$3.00")],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Price Per Tax :"),
                        Text("\$10.00"),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),
            Row(
              children: [
                SvgPicture.asset("lib/assets/icons/Menu.svg"),
                SizedBox(width: 10),
                Text(
                  'Menu',
                  style: TextStyle(
                    color: const Color(0xFFFFFAE5),
                    fontSize: 14,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w500,
                    height: 1.43,
                  ),
                ),
              ],
            ),

            Container(
              width: double.infinity,

              decoration: BoxDecoration(color: const Color(0xFF2E2D2C)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14.0,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        eventProvider.menuList.length,
                        (index) => Column(
                          children: [
                            MenuItemCard(
                              menuName: venueProvider.getMenuName(
                                eventProvider.menuList[index].id!,
                              ),
                              price:
                                  "\$${venueProvider.getMenuPrice(eventProvider.menuList[index].id!)}",
                              quantity: "2",
                              subtotal:
                                  "\$${venueProvider.getMenuPrice(eventProvider.menuList[index].id!)}",
                            ),
                            if (index != eventProvider.menuList.length - 1)
                              Divider(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // SizedBox(height: 24),
            //
            // Promo Code Section
            // _buildPromoCodeSection(),
            SizedBox(height: 24),

            // Total Summary Section
            _buildTotalSummarySection(),

            SizedBox(height: 32),

            // Full Payment Button
            InkWell(
              onTap: () async {
                LoadingDialog.show(context);
                
                final status = await eventProvider.buyTableTicketEvent(
                  eventProvider.tableBooking.toJson(),
                  eventProvider.selectEventModel.id.toString(),
                );
                LoadingDialog.hide(context);

                if (status["success"] == true &&
                    status["checkout_url"] != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StripePaymentWebViewTable(
                        url: status["checkout_url"],
                      ),
                    ),
                  ).then((e) {
                    showCustomConfirmDialogEventTicket(
                      context,
                      eventProvider.selectedTickets.length.toString(),
                      "table booking successfully",
                    );
                  });
                } else {
                  CustomSnackbar.show(
                    context,
                    message: "Getting some error",
                    backgroundColor: Colors.red,
                  );
                }
              },
              child: _buildPaymentButton(),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

Widget _buildStatusSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Status - Pending',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 4),
      Text(
        'Your payment is being processed by the system.',
        style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
      ),
    ],
  );
}

Widget _buildUserInfoSection() {
  return _buildInfoCard([
    _buildInfoRow(Icons.person, 'Tyler Howell', 'Booker (VIP)', null),
    _buildInfoRow(Icons.phone, '1 234567890', null, null),
    _buildInfoRow(Icons.email, 'tyler.howell@gmail.com', null, null),
  ]);
}

Widget _buildPromoCodeSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Promo Code',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade600),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.local_offer,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Enter promo code',
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 12),
          Container(
            height: 48,
            padding: EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white),
            ),
            child: Center(
              child: Text(
                'Apply',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

Widget _buildTotalSummarySection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildInfoCard([
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Promo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 1,
                fontWeight: FontWeight.w200,
              ),
            ),
            Text(
              '-',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w200,
              ),
            ),
          ],
        ),
        _buildPriceRow('Subtotal', '', '\$15.00'),
        SizedBox(height: 8),
        Divider(color: Colors.grey.shade600, height: 1),
        SizedBox(height: 8),
        _buildPriceRow('Grand Total', '', '\$15.00', isTotal: true),
      ]),
    ],
  );
}

Widget _buildPaymentButton() {
  return Container(
    width: double.infinity,

    decoration: BoxDecoration(
      color: Colors.white,
      // borderRadius: BorderRadius.circular(12),
      // border: Border.all(color: Colors.white),
    ),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Full Payment                    \$15.00',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
  );
}

Widget _buildInfoCard(List<Widget> children) {
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Color(0xFF2A2A2A),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    ),
  );
}

Widget _buildInfoRow(
  IconData? icon,
  String title,
  String? subtitle,
  String? trailing,
) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: Colors.grey.shade400, size: 20),
          SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (subtitle != null) ...[
                SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null)
          Text(
            trailing,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    ),
  );
}

Widget _buildSectionHeader(String title) {
  return Padding(
    padding: EdgeInsets.only(bottom: 8),
    child: Text(
      title,
      style: TextStyle(
        color: Colors.grey.shade300,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

Widget _buildPriceRow(
  String title,
  String subtitle,
  String price, {
  bool isTotal = false,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title.isNotEmpty)
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isTotal ? 16 : 14,
                    fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              if (subtitle.isNotEmpty) ...[
                SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
        if (price.isNotEmpty)
          Text(
            price,
            style: TextStyle(
              color: Colors.white,
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            ),
          ),
      ],
    ),
  );
}

class MenuItemCard extends StatelessWidget {
  final String menuName;
  final String price;
  final String quantity;
  final String subtotal;

  const MenuItemCard({
    super.key,
    required this.menuName,
    required this.price,
    required this.quantity,
    required this.subtotal,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$menuName",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 4),
        _buildRow("Price :", price),
        _buildRow("Quantity :", quantity),
        _buildRow("Subtotal :", subtotal),
      ],
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
