import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mingly/src/application/events/model/events_model.dart';
import 'package:mingly/src/application/events/model/table_ticket_model.dart';

import '../../../../application/booking/ticket_booking.dart';
import '../../../../components/custom_snackbar.dart';
import '../../../../components/helpers.dart';
import '../../../../constant/app_urls.dart';
import '../controller/table_booking_controller.dart';

class TableBookingScreen extends StatelessWidget {
  final EventsModel event;
  const TableBookingScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetX<TableBookingController>(
      init: TableBookingController(eventId: event.id.toString()),
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
            "Table Booking",
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
                  Text(
                    event.eventName.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Color(0xFFD1B26F)),
                      SizedBox(width: 8),
                      Text(
                        event.venue!.city.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  Text(
                    '${controller.detail.value.city}',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Color(0xFFD1B26F)),
                      SizedBox(width: 8),
                      Text(
                        "  ${controller.detail.value.sessionStartTime.toString()} - ${controller.detail.value.sessionEndTime.toString()}",
                        style: TextStyle(color: Colors.white),
                      ),

                      Text(
                        "  ${controller.detail.value.firstSessionDate.toString()}",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    if (controller.selectedSession == null) {
                      return SizedBox();
                    }
                    return InkWell(
                      onTap: () {
                        final sessions = controller.groupedSessionsByDate.keys
                            .toList();
                        showSessionPicker(context, sessions, (date) {
                          // Handle the selected session here
                          controller.updateDateSelection(date);
                        });
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "lib/assets/icons/calender_gold.svg",
                          ),
                          const SizedBox(width: 5),
                          Text(
                            formatDate(
                              controller.selectedSession!.firstSessionDate,
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                          const Icon(
                            Icons.arrow_drop_down_sharp,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                  const Text(
                    'Select a time you like',
                    style: TextStyle(
                      color: Color(0xFFD1B26F),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Obx(() {
                    if (controller.timeSlots.isEmpty) {
                      return Center(
                        child: Text(
                          'No time slots available',
                          style: TextStyle(color: Colors.white70),
                        ),
                      );
                    }
                    return Wrap(
                      spacing: 15,
                      runSpacing: 8,
                      children: [
                        ...List.generate(controller.timeSlots.length, (index) {
                          final timeSlot = controller.timeSlots[index];
                          return _TimeSlotButton(
                            label: formatTimeToAmPm(timeSlot.sessionStartTime),
                            index: index,
                            selected:
                                timeSlot.sessionStartTime ==
                                controller
                                    .selectedTimeSlot
                                    .value
                                    ?.sessionStartTime,
                            onPressed: (index) {
                              controller.selectTimeSlot(
                                controller.timeSlots[index],
                              );
                            },
                          );
                        }),
                      ],
                    );
                  }),
                  const SizedBox(height: 16),
                  const Text(
                    'Seating Plan',
                    style: TextStyle(
                      color: Color(0xFFD1B26F),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(() {
                    if (controller.detail.value.others == null) {
                      return SizedBox();
                    }
                    final image = controller.detail.value.others!.seatingPlan;
                    return SizedBox(
                      width: double.infinity,
                      child: Image.network(
                        '${AppUrls.imageUrl}$image',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Text("Seat plan not available");
                        },
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                  const Text(
                    'Book Preferred Slot',
                    style: TextStyle(
                      color: Color(0xFFD1B26F),
                      fontWeight: FontWeight.bold,
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

                          // Example: consider "available" if availabilityStatus == "available"
                          final isAvailable =
                              controller.filteredList[index].status ==
                              "available";

                          return _TableSlotButton(
                            id: table.id,
                            label: table.title ?? '',
                            available: isAvailable,
                            // table: table,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.circle, color: Colors.green, size: 16),
                      SizedBox(width: 4),
                      Text('Available', style: TextStyle(color: Colors.white)),
                      SizedBox(width: 16),
                      Icon(Icons.circle, color: Color(0xFFAFAFAF), size: 16),
                      SizedBox(width: 4),
                      Text('Sold', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  Obx(() {
                    if (controller.selectedTables.isEmpty) {
                      return SizedBox();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 60,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Selected Tables:',
                                  style: TextStyle(
                                    color: Color(0xFFD1B26F),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  controller.selectedTables
                                      .map((element) => element.title ?? '')
                                      .join(", "),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),

                          Expanded(
                            flex: 40,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'Total Price:',
                                  style: TextStyle(
                                    color: Color(0xFFD1B26F),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "\$${controller.selectedTables.map((element) => double.tryParse(element.price ?? '') ?? 0.0).sum.toStringAsFixed(2)}",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                  Obx(() {
                    final detail = controller.detail.value;
                    return PrimaryButton(
                      text: 'Proceed',
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
                          extra: TicketBookInfoArg(
                            event: event,
                            eventDetail: detail,
                            tickets: controller.selectedTables
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

  void showSessionPicker(
    BuildContext context,
    List<String> sessionDates,
    Function(String index) onDateSelected,
  ) async {
    final String? choice = await showModalBottomSheet<dynamic>(
      context: context,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Select a Session Date',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (sessionDates.isEmpty)
                SizedBox(
                  height: 160,
                  child: Center(
                    child: Text(
                      'No sessions available',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                )
              else
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: sessionDates.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: Colors.white10),
                    itemBuilder: (ctx, i) {
                      final s = sessionDates[i];
                      return ListTile(
                        title: Text(
                          formatDate(s),
                          style: const TextStyle(color: Colors.white),
                        ),
                        onTap: () => context.pop(s),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );

    if (choice != null) {
      onDateSelected(choice);
    }
  }

  String formatDate(dynamic value) {
    if (value == null) return '';
    if (value is DateTime) return DateFormat('dd-MMM-yyyy').format(value);

    // try ISO string
    final parsed = DateTime.tryParse(value.toString());
    if (parsed != null) return DateFormat('dd-MMM-yyyy').format(parsed);

    // try epoch seconds/ms
    final intVal = int.tryParse(value.toString());
    if (intVal != null) {
      final millis = intVal > 1000000000000 ? intVal : intVal * 1000;
      return DateFormat(
        'dd-MMM-yyyy',
      ).format(DateTime.fromMillisecondsSinceEpoch(millis));
    }

    return value.toString();
  }
}

class _TimeSlotButton extends StatelessWidget {
  final String label;
  final bool selected;
  final int index;
  final Function(int index)? onPressed;
  const _TimeSlotButton({
    required this.label,
    this.selected = false,
    required this.index,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // final provider = context.watch<EventsProvider>();
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: selected
            ? const Color(0xFFD1B26F)
            : Colors.grey.shade900,
        foregroundColor: selected ? Colors.black : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      onPressed: () {
        onPressed?.call(index);
      },
      child: Text(label),
    );
  }
}

class _TableSlotButton extends StatelessWidget {
  final int id;
  final String label;
  final String price;
  final String priceUnit;
  final Tables? table;
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
    this.table,
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
