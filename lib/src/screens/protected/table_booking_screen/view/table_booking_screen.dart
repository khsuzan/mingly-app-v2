import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mingly/src/application/events/model/events_model.dart';

import '../../../../application/booking/ticket_booking.dart';
import '../../../../application/events/model/event_details_model.dart';
import '../../../../components/custom_snackbar.dart';
import '../../../../components/helpers.dart';
import '../../../../constant/app_urls.dart';
import '../controller/table_booking_controller.dart';

class TableBookingScreen extends StatelessWidget {
  final TableBookingInfoArg info;
  const TableBookingScreen({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final event = info.event;
    final session = info.session;
    final selectedDate = info.selectedDate ?? 'TBD';

    return GetBuilder<TableBookingController>(
      init: TableBookingController(argument: info),
      builder: (controller) => Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: theme.colorScheme.surface,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "Book Table",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  // Event Header
                  Text(
                    event.eventName.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Session Details Card
                  Obx(
                    () => _buildSessionDetailsCard(
                      controller.bookingArgs.value.session,
                      controller.bookingArgs.value.selectedDate ?? 'TBD',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Change Session Button
                  _buildChangeSessionButton(context, controller),
                  const SizedBox(height: 16),

                  // Seating Plan
                  _buildSeatingPlan(controller),
                  const SizedBox(height: 16),

                  // Book Preferred Slot
                  const Text(
                    'Select Your Table',
                    style: TextStyle(
                      color: Color(0xFFD1B26F),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(() {
                    if (controller.filteredList.isEmpty) {
                      return Center(
                        child: Text(
                          'No tables available',
                          style: TextStyle(color: Colors.white70),
                        ),
                      );
                    }
                    final selectedTables = controller.selectedTables;
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ...List.generate(controller.filteredList.length, (
                          index,
                        ) {
                          final table =
                              controller.filteredList[index].ticketInfo;
                          final isAvailable =
                              controller.filteredList[index].status ==
                              "available";

                          return _TableSlotButton(
                            id: table.id,
                            label: table.title ?? '',
                            available: isAvailable,
                            price: table.price ?? '',
                            priceUnit: "\$",
                            selected: selectedTables.any(
                              (t) => t.id == controller.filteredList[index].id,
                            ),
                            onClicked: () {
                              if (isAvailable) {
                                controller.toggleTableSelection(table);
                              }
                            },
                          );
                        }),
                      ],
                    );
                  }),
                  const SizedBox(height: 8),
                  // Legend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.circle, color: Colors.green, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Available',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      SizedBox(width: 16),
                      Icon(Icons.circle, color: Color(0xFFAFAFAF), size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Sold',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),

                  // Selected Tables Summary
                  Obx(() {
                    if (controller.selectedTables.isEmpty) {
                      return SizedBox();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: _buildSelectedTablesSummary(controller),
                    );
                  }),

                  const SizedBox(height: 24),
                  Obx(() {
                    final detail = controller.detail.value;
                    return PrimaryButton(
                      text: 'Proceed to Confirmation',
                      onPressed: () {
                        if (controller.selectedTables.isEmpty) {
                          CustomSnackbar.show(
                            context,
                            message: "Please select at least one table.",
                            backgroundColor: Colors.red,
                          );
                          return;
                        }
                        context.push(
                          "/table-booking-confirmation",
                          extra: TableBookingInfoArg(
                            event: event,
                            eventDetail: detail,
                            tables: controller.selectedTables
                                .map((t) {
                                  return TicketBuyingInfo(
                                    ticketId: t.id,
                                    quantity: 1,
                                    ticketTitle: t.title ?? "",
                                    totalTicketQty: t.totalTicketQty ?? 0,
                                    unitPrice:
                                        double.tryParse(t.price ?? '0') ?? 0.0,
                                  );
                                })
                                .where((t) => t.quantity > 0)
                                .toList(),
                            promoCode: '',
                            session: session,
                            selectedDate: selectedDate,
                          ),
                        );
                      },
                    );
                  }),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSessionDetailsCard(dynamic session, String selectedDate) {
    String sessionType = 'Select Session';
    String timeDisplay = '';

    if (session != null) {
      try {
        sessionType = (session.sessionType ?? 'select_session')
            .toString()
            .toUpperCase();
        final startTime = session.sessionStartTime;
        final endTime = session.sessionEndTime;
        if (startTime != null && endTime != null) {
          timeDisplay =
              '${formatTimeToAmPm(startTime)} – ${formatTimeToAmPm(endTime)}';
        }
      } catch (_) {}
    }

    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF2E2D2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFD1B26F).withOpacity(0.3), width: 1),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Session Details',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Color(0xFFD1B26F).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  sessionType,
                  style: TextStyle(
                    color: Color(0xFFD1B26F),
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Date
          Row(
            children: [
              Icon(Icons.calendar_today, color: Color(0xFFD1B26F), size: 16),
              SizedBox(width: 10),
              Text(
                selectedDate,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          if (timeDisplay.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.schedule, color: Color(0xFFD1B26F), size: 16),
                SizedBox(width: 10),
                Text(
                  timeDisplay,
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChangeSessionButton(
    BuildContext context,
    TableBookingController controller,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFFD1B26F).withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFFD1B26F).withOpacity(0.3), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            if (controller.bookingArgs.value.sessions != null &&
                controller.bookingArgs.value.sessions!.isNotEmpty) {
              _showSessionSelectionBottomSheet(
                context,
                controller.bookingArgs.value.sessions!,
                controller,
              );
            } else {
              Navigator.pop(context);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.edit, color: Color(0xFFD1B26F), size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Change Session & Date',
                      style: TextStyle(
                        color: Color(0xFFD1B26F),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFFD1B26F),
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSessionSelectionBottomSheet(
    BuildContext context,
    List<Session> sessions,
    TableBookingController controller,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SessionSelectionSheetForTableBooking(
        sessions: sessions,
        event: controller.bookingArgs.value.event,
        eventDetail: controller.bookingArgs.value.eventDetail,
        controller: controller,
      ),
    );
  }

  Widget _buildSeatingPlan(TableBookingController controller) {
    return Obx(() {
      if (controller.detail.value.others == null) {
        return SizedBox();
      }
      final image = controller.detail.value.others!.seatingPlan;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seating Plan',
            style: TextStyle(
              color: Color(0xFFD1B26F),
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          Obx(() {
            if (controller.isEventDetailLoading.value) {
              return Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black.withOpacity(0.3),
                ),
              );
            }
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black.withOpacity(0.3),
              ),
              child: SizedBox(
                width: double.infinity,
                child: Image.network(
                  '${AppUrls.imageUrl}$image',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Seating plan not available",
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  },
                ),
              ),
            );
          }),
        ],
      );
    });
  }

  Widget _buildSelectedTablesSummary(TableBookingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF2E2D2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFD1B26F).withOpacity(0.3), width: 1),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selected Tables',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.selectedTables
                      .map((element) => element.title ?? '')
                      .join(", "),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Price',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    Text(
                      "\$${controller.selectedTables.fold<double>(0, (sum, element) => sum + (double.tryParse(element.price ?? '') ?? 0.0)).toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Color(0xFFD1B26F),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TableSlotButton extends StatelessWidget {
  final int id;
  final String label;
  final String price;
  final String priceUnit;
  final bool available;
  final bool selected;
  final VoidCallback? onClicked;
  const _TableSlotButton({
    required this.id,
    required this.label,
    required this.price,
    this.priceUnit = "\$",
    required this.available,
    required this.selected,
    this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: available ? Colors.green : const Color(0xFFAFAFAF),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          ),
          onPressed: () {
            onClicked?.call();
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "$priceUnit$price",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 10.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        if (selected)
          Positioned(
            top: 0,
            right: 0,
            child: Icon(
              Icons.check_circle,
              color: Colors.yellow.shade700,
              size: 20,
            ),
          ),
      ],
    );
  }
}

// SessionSelectionSheetForTableBooking
class SessionSelectionSheetForTableBooking extends StatefulWidget {
  final List<Session> sessions;
  final EventsModel event;
  final EventDetailsModel eventDetail;
  final TableBookingController controller;

  const SessionSelectionSheetForTableBooking({
    super.key,
    required this.sessions,
    required this.event,
    required this.eventDetail,
    required this.controller,
  });

  @override
  State<SessionSelectionSheetForTableBooking> createState() =>
      _SessionSelectionSheetForTableBookingState();
}

class _SessionSelectionSheetForTableBookingState
    extends State<SessionSelectionSheetForTableBooking> {
  Session? selectedSession;
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();

    // Filter out past sessions
    final upcoming = widget.sessions.where((s) {
      try {
        final endDate = DateTime.parse(
          s.lastSessionDate ?? s.firstSessionDate ?? '',
        );
        return endDate.isAfter(now);
      } catch (_) {
        return true;
      }
    }).toList();

    return DraggableScrollableSheet(
      expand: false,
      maxChildSize: 0.9,
      initialChildSize: 0.7,
      builder: (context, scrollController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Session & Date',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Divider(color: Color(0xFFD1B26F).withOpacity(0.2)),

            // Sessions List
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: upcoming.length,
                itemBuilder: (ctx, i) =>
                    _buildSessionItem(upcoming[i], theme, context),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSessionItem(
    dynamic session,
    ThemeData theme,
    BuildContext context,
  ) {
    final type = (session.sessionType ?? '').toLowerCase();
    final startDate = session.firstSessionDate;
    final endDate = session.lastSessionDate;
    final startTime = session.sessionStartTime;
    final endTime = session.sessionEndTime;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () => _onSessionSelected(session, type),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF2E2D2C),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selectedSession == session
                  ? Color(0xFFD1B26F)
                  : Color(0xFFD1B26F).withOpacity(0.3),
              width: selectedSession == session ? 2 : 1,
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Session Type & Time
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFFD1B26F).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      type.toUpperCase(),
                      style: TextStyle(
                        color: Color(0xFFD1B26F),
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${formatTimeToAmPm(startTime)} – ${formatTimeToAmPm(endTime)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),

              // Date Range
              Text(
                type == 'single'
                    ? 'Date: ${_formatDate(startDate)}'
                    : '${_formatDate(startDate)} → ${_formatDate(endDate)}',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),

              // Days for weekly
              if (type == 'weekly' &&
                  session.daysOfWeek is List &&
                  session.daysOfWeek.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Every: ${session.daysOfWeek.map((d) => d.toString().substring(0, 3)).join(', ')}',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),

              // Date Selection UI
              if (selectedSession == session) ...[
                SizedBox(height: 12),
                _buildDateSelectionUI(type, session, context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelectionUI(
    String type,
    dynamic session,
    BuildContext context,
  ) {
    switch (type) {
      case 'single':
        return _buildSingleSessionUI(session);
      case 'daily':
        return _buildDailySessionUI(session, context);
      case 'weekly':
        return _buildWeeklySessionUI(session, context);
      case 'monthly':
        return _buildMonthlySessionUI(session, context);
      case 'time_slot':
        return _buildTimeSlotUI(session);
      default:
        return SizedBox();
    }
  }

  Widget _buildSingleSessionUI(dynamic session) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFD1B26F).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '✓ Date Selected: ${_formatDate(session.firstSessionDate)}',
            style: TextStyle(
              color: Color(0xFFD1B26F),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              text: 'Book Sofa & Table',
              onPressed: () => _proceedToBooking(
                session,
                _formatDate(session.firstSessionDate),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailySessionUI(dynamic session, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select a date:',
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showDatePicker(context, session, 'daily'),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Color(0xFFD1B26F).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xFFD1B26F).withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: Color(0xFFD1B26F), size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? _formatDate(selectedDate.toString())
                        : 'Choose date',
                    style: TextStyle(
                      color: selectedDate != null
                          ? Colors.white
                          : Colors.white54,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (selectedDate != null) ...[
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              text: 'Book Sofa & Table',
              onPressed: () => _proceedToBooking(
                session,
                _formatDate(selectedDate.toString()),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildWeeklySessionUI(dynamic session, BuildContext context) {
    final startDate = DateTime.parse(session.firstSessionDate);
    final endDate = DateTime.parse(session.lastSessionDate);
    final allowedDays = (session.daysOfWeek as List)
        .map((d) => d.toString().toLowerCase())
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select a date (only allowed days):',
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showWeeklyDatePicker(
            context,
            startDate,
            endDate,
            allowedDays,
            session,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Color(0xFFD1B26F).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xFFD1B26F).withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: Color(0xFFD1B26F), size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? _formatDate(selectedDate.toString())
                        : 'Choose date',
                    style: TextStyle(
                      color: selectedDate != null
                          ? Colors.white
                          : Colors.white54,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (selectedDate != null) ...[
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              text: 'Book Sofa & Table',
              onPressed: () => _proceedToBooking(
                session,
                _formatDate(selectedDate.toString()),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMonthlySessionUI(dynamic session, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select a date:',
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showDatePicker(context, session, 'monthly'),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Color(0xFFD1B26F).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xFFD1B26F).withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: Color(0xFFD1B26F), size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? _formatDate(selectedDate.toString())
                        : 'Choose date',
                    style: TextStyle(
                      color: selectedDate != null
                          ? Colors.white
                          : Colors.white54,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (selectedDate != null) ...[
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              text: 'Book Sofa & Table',
              onPressed: () => _proceedToBooking(
                session,
                _formatDate(selectedDate.toString()),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTimeSlotUI(dynamic session) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFD1B26F).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '✓ Time Slot Selected',
            style: TextStyle(
              color: Color(0xFFD1B26F),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '${_formatDate(session.firstSessionDate)} • ${formatTimeToAmPm(session.sessionStartTime)} – ${formatTimeToAmPm(session.sessionEndTime)}',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              text: 'Book Sofa & Table',
              onPressed: () => _proceedToBooking(
                session,
                _formatDate(session.firstSessionDate),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onSessionSelected(dynamic session, String type) {
    setState(() {
      selectedSession = session;
      selectedDate = null;

      // Auto-select for single and time_slot
      if (type == 'single' || type == 'time_slot') {
        selectedDate = DateTime.parse(session.firstSessionDate);
      }
    });
  }

  void _showDatePicker(
    BuildContext context,
    dynamic session,
    String type,
  ) async {
    final startDate = DateTime.parse(session.firstSessionDate);
    final endDate = DateTime.parse(session.lastSessionDate);

    final picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: startDate,
      lastDate: endDate,
      builder: (context, child) => Theme(
        data: Theme.of(
          context,
        ).copyWith(colorScheme: ColorScheme.dark(primary: Color(0xFFD1B26F))),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _showWeeklyDatePicker(
    BuildContext context,
    DateTime startDate,
    DateTime endDate,
    List<String> allowedDays,
    dynamic session,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: startDate,
      lastDate: endDate,
      selectableDayPredicate: (DateTime date) {
        final dayName = [
          'monday',
          'tuesday',
          'wednesday',
          'thursday',
          'friday',
          'saturday',
          'sunday',
        ][(date.weekday - 1) % 7];
        return allowedDays.contains(dayName);
      },
      builder: (context, child) => Theme(
        data: Theme.of(
          context,
        ).copyWith(colorScheme: ColorScheme.dark(primary: Color(0xFFD1B26F))),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _proceedToBooking(dynamic session, String selectedDateStr) {
    Navigator.pop(context);
    widget.controller.updateSessionAndRefetch(session, selectedDateStr);
  }

  String _formatDate(String date) {
    try {
      final d = DateTime.parse(date);
      return '${_monthShort(d.month)} ${d.day}, ${d.year}';
    } catch (_) {
      return date;
    }
  }

  String _monthShort(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month];
  }
}
