import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mingly/src/application/booking/ticket_booking.dart';
import 'package:mingly/src/application/events/model/events_model.dart';
import 'package:mingly/src/components/custom_loading_dialog.dart';
import 'package:mingly/src/components/helpers.dart';
import 'package:url_launcher/url_launcher.dart';

import 'controller/event_detail_controller.dart';
import 'widget/carousel_slider.dart';

class EventDetailScreen extends StatelessWidget {
  final EventsModel event;
  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetBuilder<EventDetailController>(
      init: EventDetailController(id: event.id.toString()),
      builder: (controller) {
        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: theme.colorScheme.surface,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              "Event Details",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: false,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(2),
              child: Container(
                color: Colors.grey.shade800,
                height: 2,
                width: double.infinity,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image carousel (static for now)
                Obx(() {
                  final youtubeUrl = controller.detail.value;
                  return EventCarouselSlider(
                    youtubeUrl: youtubeUrl.others?.youtube,
                    images: event.images,
                  );
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              event.eventName.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.favorite_border,
                              color: const Color(0xFFD1B26F),
                            ),
                            onPressed: () {
                              controller.addToFavourite(
                                context,
                                event.id.toString(),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Color(0xFFD1B26F),
                            size: 18,
                          ),
                          SizedBox(width: 4),
                          Text(
                            event.venue?.city ?? "",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Color(0xFFD1B26F),
                            size: 18,
                          ),
                          SizedBox(width: 4),
                          Obx(() {
                            return Text(
                              controller.detail.value.firstSessionDate
                                  .toString(),
                              style: TextStyle(color: Colors.white70),
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Obx(
                        () => Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: Color(0xFFD1B26F),
                              size: 18,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '${formatTimeToAmPm(controller.detail.value.sessionStartTime.toString())} - ${formatTimeToAmPm(controller.detail.value.sessionEndTime.toString())}',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Description',
                        style: TextStyle(
                          color: Color(0xFFD1B26F),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),

                      Linkify(
                        text: event.description ?? '',
                        onOpen: (link) async {
                          if (kDebugMode) {
                            print('Opening link: ${link.url}');
                          }
                          final Uri url = Uri.parse(link.url);

                          // Always use external mode
                          if (!await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          )) {
                            throw Exception('Could not launch $url');
                          }
                        },
                        style: const TextStyle(color: Colors.white),
                        linkStyle: const TextStyle(
                          color: Colors.blueAccent,
                          decoration: TextDecoration.underline,
                        ),
                      ), // Text(

                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          PrimaryButton(
                            text: 'Book Ticket',
                            onPressed: () {
                              context.push(
                                "/ticket-booking",
                                extra: TicketBookInfoArg(
                                  event: event,
                                  eventDetail: controller.detail.value,
                                  tickets: [],
                                  promoCode: '',
                                ),
                              );
                            },
                          ),
                          PrimaryButton(
                            text: 'Sofa & Table',
                            onPressed: () {
                              context.push("/table-booking", extra: event);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
