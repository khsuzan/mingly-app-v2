import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mingly/src/application/events/model/event_session_model.dart';
import 'package:mingly/src/application/events/model/events_model.dart';
import 'package:mingly/src/application/events/model/table_ticket_model.dart';
import 'package:mingly/src/components/custom_loading_dialog.dart'
    show LoadingDialog;
import 'package:mingly/src/components/custom_snackbar.dart';
import 'package:mingly/src/constant/app_urls.dart';
import 'package:mingly/src/screens/protected/event_list_screen/events_provider.dart';
import 'package:mingly/src/screens/protected/venue_list_screen/venue_provider.dart';
import 'package:provider/provider.dart';

import '../controller/table_booking_controller.dart';

class TableBookingScreen extends StatelessWidget {
  final EventsModel event;
  const TableBookingScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.put(TableBookingController(id: event.id.toString()));
    // final eventProvider = context.watch<EventsProvider>();
    // final venueProvider = context.watch<VenueProvider>();
    return Scaffold(
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
                    event.venueCity.toString(),
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
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        final sessions = controller.sessionTimes;
                        showSessionPicker(context, sessions, (selectedSession) {
                          // Handle the selected session here
                          debugPrint("Selected session: $selectedSession");
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
                              controller.detail.value.firstSessionDate,
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                          const Icon(
                            Icons.arrow_drop_down_sharp,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 16),
              const Text(
                'Description',
                style: TextStyle(
                  color: Color(0xFFD1B26F),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                controller.detail.value.description.toString(),
                style: TextStyle(color: Colors.white70),
              ),

              const SizedBox(height: 24),
              const Text(
                'Select a time you like',
                style: TextStyle(
                  color: Color(0xFFD1B26F),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // if (controller.sessionTimes.isEmpty)
              //   Wrap(
              //     spacing: 15,
              //     runSpacing: 8,
              //     children: [
              //       ...List.generate(controller.sessionTimes.length, (
              //         index,
              //       ) {
              //         final timeSlot = controller.sessionTimes[index];
              //         return _TimeSlotButton(label: timeSlot, index: index);
              //       }),
              //     ],
              //   ),
              // eventProvider.listedTimeSlot.isEmpty
              //     ? SizedBox()
              //     : Wrap(
              //         spacing: 15,
              //         runSpacing: 8,
              //         children: [
              //           ...List.generate(eventProvider.listedTimeSlot!.length, (
              //             index,
              //           ) {
              //             final timeSlot = eventProvider.listedTimeSlot![index];
              //             return _TimeSlotButton(label: timeSlot, index: index);
              //           }),
              //         ],
              //       ),
              const SizedBox(height: 24),

              // eventProvider.tableTicketModel.tables == null
              //     ? Center(child: Text("No Tables found in this session"))
              //     : Center(
              //         child: Container(
              //           decoration: BoxDecoration(
              //             border: Border.all(color: Colors.white24),
              //             borderRadius: BorderRadius.circular(12),
              //           ),
              //           child:
              //               eventProvider
              //                       .tableTicketModel
              //                       .tables!
              //                       .first
              //                       .image ==
              //                   null
              //               ? Image.network(
              //                   'https://www.directmobilityonline.co.uk/assets/img/noimage.png',
              //                   height: 200,
              //                   fit: BoxFit.contain,
              //                 )
              //               : Image.network(
              //                   '${AppUrls.imageUrl}${eventProvider.tableTicketModel.tables!.first.image}',
              //                   height: 200,
              //                   fit: BoxFit.contain,
              //                   errorBuilder: (context, error, stackTrace) {
              //                     debugPrint("❌ Image load failed: $error");
              //                     return Image.network(
              //                       'https://www.directmobilityonline.co.uk/assets/img/noimage.png',
              //                       fit: BoxFit.cover,
              //                       height: 160,
              //                       width: double.infinity,
              //                     );
              //                   },
              //                 ),
              //         ),
              //       ),
              const SizedBox(height: 16),
              const Text(
                'Book Preferred Slot',
                style: TextStyle(
                  color: Color(0xFFD1B26F),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // eventProvider.tableTicketModel.tables == null ||
              //         eventProvider.tableTicketModel.tables!.isEmpty
              //     ? SizedBox()
              //     : Wrap(
              //         spacing: 8,
              //         runSpacing: 8,
              //         children: [
              //           ...List.generate(
              //             eventProvider.tableTicketModel.tables!.length,
              //             (index) {
              //               final table =
              //                   eventProvider.tableTicketModel.tables![index];

              //               // Example: consider "available" if availabilityStatus == "available"
              //               final isAvailable =
              //                   table.availabilityStatus == "available";

              //               return _TableSlotButton(
              //                 id: table.tableId!.toInt(),
              //                 label:
              //                     'Table\n${(table.tcketNumber ?? index + 1).toString().padLeft(2, '0')}',
              //                 available: isAvailable,
              //                 table: table,
              //               );
              //             },
              //           ),
              //         ],
              //       ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.circle, color: Colors.green, size: 16),
                  SizedBox(width: 4),
                  Text('Available', style: TextStyle(color: Colors.white)),
                  SizedBox(width: 16),
                  Icon(Icons.circle, color: Colors.red, size: 16),
                  SizedBox(width: 4),
                  Text('Sold', style: TextStyle(color: Colors.white)),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD1B26F),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    context.push("/beverages");
                  },
                  child: const Text('Proceed'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void showSessionPicker(
    BuildContext context,
    List<EventSessionModel> sessions,
    Function(DateTime selectedSession) onDateSelected,
  ) async {
    final DateTime? choice = await showModalBottomSheet<dynamic>(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: sessions.isEmpty
              ? SizedBox(
                  height: 160,
                  child: Center(
                    child: Text(
                      'No sessions available',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  itemCount: sessions.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, color: Colors.white24),
                  itemBuilder: (ctx, i) {
                    final s = sessions[i].firstSessionDate;
                    // if session is an object adjust the label below:
                    return ListTile(
                      title: Text(
                        formatDate(s),
                        style: const TextStyle(color: Colors.white),
                      ),
                      onTap: () => context.pop(sessions[i]),
                    );
                  },
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
  const _TimeSlotButton({
    required this.label,
    this.selected = false,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EventsProvider>();
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: provider.indexOfSelectedTimeSlot == index
            ? const Color(0xFFD1B26F)
            : Colors.grey.shade900,
        foregroundColor: provider.indexOfSelectedTimeSlot == index
            ? Colors.black
            : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      onPressed: () {
        provider.selectTimeSlot(index);
      },
      child: Text(label),
    );
  }
}

class _TableSlotButton extends StatelessWidget {
  final int id;
  final String label;
  final Tables table;
  final bool available;
  const _TableSlotButton({
    required this.label,
    required this.available,
    required this.id,
    required this.table,
  });

  @override
  Widget build(BuildContext context) {
    final eventProvider = context.watch<EventsProvider>();
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: available ? Colors.green : Colors.red,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: eventProvider.tableBooking.seatId == table.id
              ? BorderSide(color: Colors.white)
              : BorderSide(color: Colors.transparent),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      ),
      onPressed: () {
        if (available == false) {
          CustomSnackbar.show(
            context,
            message: "Table already booked.",
            backgroundColor: Colors.red,
          );
        } else if (available) {
          List<String> parts = eventProvider
              .tableTicketModel
              .sessionInfo!
              .sessionStart!
              .split(':');
          print("Data show" + parts.length.toString());
          String formate = "${parts[0]}:${parts[1]}";

          eventProvider.selecteTableBooking(
            table.tableId!,
            eventProvider.selectedTableTime,
            table.id!,
          );
          eventProvider.selectedTable(table);
        }
      },
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
