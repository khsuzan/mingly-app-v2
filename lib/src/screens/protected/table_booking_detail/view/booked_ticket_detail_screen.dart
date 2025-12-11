import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../application/booking/model/booking_list.dart';
import '../controller/booked_table_detail_controller.dart';
import '../widgets/booking_header_section.dart';
import '../widgets/order_info_section.dart';
import '../widgets/items_section.dart';
import '../widgets/event_details_section.dart';

class BookedTicketDetailScreen extends StatelessWidget {
  final BookingOrder booking;
  const BookedTicketDetailScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String eventId = booking.event.id.toString();
    final String orderNumber = booking.orderNumber;

    return GetBuilder<BookedDetailController>(
      init: BookedDetailController(
        eventId: eventId,
        orderNumber: orderNumber,
      ),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: theme.colorScheme.surface,
            title: Text(
              'Booking Details',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Obx(() {
              final orderDetail = controller.orderDetail.value;
              final eventDetail = controller.eventDetail.value;
            
              // Show loading if data not loaded
              if (orderDetail.orderNumber == null) {
                return const Center(child: CircularProgressIndicator());
              }
            
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header section with image and event name
                    BookingHeaderSection(orderDetail: orderDetail),
            
                    // Order info with status and pricing
                    OrderInfoSection(orderDetail: orderDetail),
            
                    // Items section with tickets and sessions
                    ItemsSection(orderDetail: orderDetail),
            
                    // Event details section
                    EventDetailsSection(eventDetail: eventDetail),
            
                    const SizedBox(height: kBottomNavigationBarHeight * 1.25),
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
