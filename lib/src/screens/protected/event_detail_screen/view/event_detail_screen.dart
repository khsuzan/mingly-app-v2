import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mingly/src/application/booking/ticket_booking.dart';
import 'package:mingly/src/application/events/model/events_model.dart';
import 'package:mingly/src/components/helpers.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../components/home.dart';
import '../controller/event_detail_controller.dart';
import '../widget/carousel_slider.dart';

class EventDetailScreen extends StatelessWidget {
  final EventsModel event;
  const EventDetailScreen({super.key, required this.event});

  void _showSessionSelectionDialog(
    BuildContext context,
    List<dynamic>? sessions,
    EventsModel event,
    dynamic eventDetail,
    {required bool isTableBooking,
  }) {
    if (sessions == null || sessions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No sessions available')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SessionSelectionSheet(
        sessions: sessions,
        event: event,
        eventDetail: eventDetail,
        isTableBooking: isTableBooking,
      ),
    );
  }

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
            title: Text(
              'Event Details',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
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
                                  Obx(() {
                                    return IconButton(
                                      icon: Icon(
                                        controller.isFavourite.value
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: const Color(0xFFD1B26F),
                                      ),
                                      onPressed: () {
                                        if (controller.isFavourite.value) {
                                          controller.removeFromFavourite(
                                            context,
                                            event.id.toString(),
                                          );
                                          return;
                                        }
                                        controller.addToFavourite(
                                          context,
                                          event.id.toString(),
                                        );
                                      },
                                    );
                                  }),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Color(0xFFD1B26F),
                                    size: 18,
                                  ),
                                  SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      "${event.venue?.address} ${event.venue?.city}",
                                      style: TextStyle(color: Colors.white70),
                                    ),
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
                                      controller.detail.value
                                          .toString(),
                                      style: TextStyle(color: Colors.white70),
                                    );
                                  }),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Obx(
                                () => EventSessionsWidget(
                                  sessions: controller.detail.value.sessions,
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

                              ExpandableLinkify(
                                text: event.description ?? '',
                                maxLines: 6,
                                style: const TextStyle(color: Colors.white),
                                linkStyle: const TextStyle(
                                  color: Colors.blueAccent,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              Obx(() {
                                if (controller.venue.value == null) {
                                  return SizedBox();
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(height: 24),
                                    Text(
                                      'Venue',
                                      style: TextStyle(
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                );
                              }),
                              Obx(() {
                                if (controller.venue.value == null) {
                                  return SizedBox();
                                }
                                final image =
                                    controller.venue.value?.images?.firstOrNull;
                                return InkWell(
                                  onTap: () {
                                    context.push(
                                      "/venue-detail",
                                      extra: controller.venue.value,
                                    );
                                  },
                                  child: VenueCardSmall(
                                    image: image?.imageUrl,
                                    title: controller.venue.value!.name!,
                                    location:
                                        '${controller.venue.value!.address}\n${controller.venue.value!.city}, ${controller.venue.value!.country}',
                                  ),
                                );
                              }),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Sticky buttons at bottom
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    border: Border(
                      top: BorderSide(
                        color: Color(0xFFD1B26F).withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          text: 'Book Ticket',
                          onPressed: () {
                            _showSessionSelectionDialog(
                              context,
                              controller.detail.value.sessions,
                              event,
                              controller.detail.value,
                              isTableBooking: false,
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: PrimaryButton(
                          text: 'Sofa & Table',
                          onPressed: () {
                            _showSessionSelectionDialog(
                              context,
                              controller.detail.value.sessions,
                              event,
                              controller.detail.value,
                              isTableBooking: true,
                            );
                          },
                        ),
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
// --- Place this widget at the very end of the file ---

class ExpandableLinkify extends StatefulWidget {
  final String text;
  final int maxLines;
  final TextStyle? style;
  final TextStyle? linkStyle;
  const ExpandableLinkify({
    super.key,
    required this.text,
    this.maxLines = 3,
    this.style,
    this.linkStyle,
  });

  @override
  State<ExpandableLinkify> createState() => _ExpandableLinkifyState();
}

class _ExpandableLinkifyState extends State<ExpandableLinkify> {
  bool expanded = false;
  bool showSeeMore = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(text: widget.text, style: widget.style);
        final tp = TextPainter(
          text: span,
          maxLines: widget.maxLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);
        showSeeMore = tp.didExceedMaxLines;

        if (!showSeeMore || expanded) {
          return Linkify(
            text: widget.text,
            onOpen: (link) async {
              if (kDebugMode) {
                print('Opening link: [38;5;28m${link.url}[0m');
              }
              final Uri url = Uri.parse(link.url);
              if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                throw Exception('Could not launch $url');
              }
            },
            style: widget.style,
            linkStyle: widget.linkStyle,
            maxLines: expanded ? null : widget.maxLines,
            overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis,
          );
        }

        // Find the visible substring for maxLines
        int endIndex = widget.text.length;
        for (int i = widget.text.length; i > 0; i--) {
          final testSpan = TextSpan(
            text: widget.text.substring(0, i),
            style: widget.style,
          );
          final testTp = TextPainter(
            text: testSpan,
            maxLines: widget.maxLines,
            textDirection: TextDirection.ltr,
          )..layout(maxWidth: constraints.maxWidth);
          if (!testTp.didExceedMaxLines) {
            endIndex = i;
            break;
          }
        }
        final visibleText = widget.text.substring(0, endIndex).trimRight();

        return RichText(
          text: TextSpan(
            children: [
              TextSpan(text: visibleText, style: widget.style),
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: GestureDetector(
                  onTap: () => setState(() => expanded = true),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      'See more',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// --- EventSessionsWidget ---
class EventSessionsWidget extends StatefulWidget {
  final List<dynamic>? sessions;
  const EventSessionsWidget({Key? key, required this.sessions}) : super(key: key);

  @override
  State<EventSessionsWidget> createState() => _EventSessionsWidgetState();
}

class _EventSessionsWidgetState extends State<EventSessionsWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (widget.sessions == null || widget.sessions!.isEmpty) {
      return Row(
        children: [
          Icon(Icons.access_time, color: Color(0xFFD1B26F), size: 18),
          SizedBox(width: 4),
          Text('No sessions available', style: TextStyle(color: Colors.white70)),
        ],
      );
    }

    final now = DateTime.now();
    // Filter out past sessions
    final upcoming = widget.sessions!.where((s) {
      try {
        final endDate = DateTime.parse(s.lastSessionDate ?? s.firstSessionDate ?? '');
        final endTime = s.sessionEndTime;
        if (endTime != null && endTime.length == 8) {
          final parts = endTime.split(":");
          return endDate.add(Duration(hours: int.parse(parts[0]), minutes: int.parse(parts[1])))
              .isAfter(now);
        }
        return endDate.isAfter(now);
      } catch (_) {
        return true;
      }
    }).toList();

    if (upcoming.isEmpty) {
      return Row(
        children: [
          Icon(Icons.access_time, color: Color(0xFFD1B26F), size: 18),
          SizedBox(width: 4),
          Text('All sessions completed', style: TextStyle(color: Colors.white70)),
        ],
      );
    }

    // Group sessions by type
    final singleSessions = upcoming.where((s) => (s.sessionType ?? '').toLowerCase() == 'single').toList();
    final dailySessions = upcoming.where((s) => (s.sessionType ?? '').toLowerCase() == 'daily').toList();
    final weeklySessions = upcoming.where((s) => (s.sessionType ?? '').toLowerCase() == 'weekly').toList();
    final monthlySessions = upcoming.where((s) => (s.sessionType ?? '').toLowerCase() == 'monthly').toList();
    final timeSlotSessions = upcoming.where((s) => (s.sessionType ?? '').toLowerCase() == 'time_slot').toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Time Slot Sessions
        if (timeSlotSessions.isNotEmpty) ...[
          _buildSessionTypeHeader('Available Time Slots', theme),
          ...timeSlotSessions.map<Widget>((s) => _buildSessionCard(s, context, theme)),
        ],
        // Single Sessions
        if (singleSessions.isNotEmpty) ...[
          if (timeSlotSessions.isNotEmpty) SizedBox(height: 16),
          _buildSessionTypeHeader('One-Time Sessions', theme),
          ...singleSessions.map<Widget>((s) => _buildSessionCard(s, context, theme)),
        ],
        // Daily Sessions
        if (dailySessions.isNotEmpty) ...[
          if (singleSessions.isNotEmpty || timeSlotSessions.isNotEmpty) SizedBox(height: 16),
          _buildSessionTypeHeader('Daily Sessions', theme),
          ...dailySessions.map<Widget>((s) => _buildSessionCard(s, context, theme)),
        ],
        // Weekly Sessions
        if (weeklySessions.isNotEmpty) ...[
          if (singleSessions.isNotEmpty || dailySessions.isNotEmpty || timeSlotSessions.isNotEmpty) SizedBox(height: 16),
          _buildSessionTypeHeader('Weekly Sessions', theme),
          ...weeklySessions.map<Widget>((s) => _buildSessionCard(s, context, theme)),
        ],
        // Monthly Sessions
        if (monthlySessions.isNotEmpty) ...[
          if (singleSessions.isNotEmpty || dailySessions.isNotEmpty || weeklySessions.isNotEmpty || timeSlotSessions.isNotEmpty) SizedBox(height: 16),
          _buildSessionTypeHeader('Monthly Sessions', theme),
          ...monthlySessions.map<Widget>((s) => _buildSessionCard(s, context, theme)),
        ],
      ],
    );
  }

  Widget _buildSessionTypeHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
          fontSize: 14,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSessionCard(dynamic s, BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF2E2D2C),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xFFD1B26F).withOpacity(0.3), width: 1),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Range
            Row(
              children: [
                Icon(Icons.calendar_today, color: Color(0xFFD1B26F), size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getDateDisplay(s),
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 13),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            // Time Range
            Row(
              children: [
                Icon(Icons.schedule, color: Color(0xFFD1B26F), size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getTimeDisplay(s, context),
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ),
              ],
            ),
            // Days for weekly sessions
            if ((s.sessionType ?? '').toLowerCase() == 'weekly' && s.daysOfWeek is List && s.daysOfWeek.isNotEmpty)
              ...[
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.repeat, color: Color(0xFFD1B26F), size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        s.daysOfWeek.map((d) => _capitalize(d)).join(', '),
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ],
          ],
        ),
      ),
    );
  }

  String _getDateDisplay(dynamic s) {
    final type = (s.sessionType ?? '').toLowerCase();
    final startDate = s.firstSessionDate;
    final endDate = s.lastSessionDate;

    if (type == 'single') {
      return 'Date: ${_formatDate(startDate)}';
    } else if (startDate != null && endDate != null && startDate != endDate) {
      return '${_formatDate(startDate)} → ${_formatDate(endDate)}';
    } else if (startDate != null) {
      return _formatDate(startDate);
    }
    return '';
  }

  String _getTimeDisplay(dynamic s, BuildContext context) {
    final startTime = s.sessionStartTime;
    final endTime = s.sessionEndTime;
    if (startTime != null && endTime != null) {
      return '${formatTimeToAmPm(startTime)} – ${formatTimeToAmPm(endTime)}';
    }
    return '';
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
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month];
  }

  String _capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

// --- SessionSelectionSheet ---
class SessionSelectionSheet extends StatefulWidget {
  final List<dynamic> sessions;
  final EventsModel event;
  final dynamic eventDetail;
  final bool isTableBooking;

  const SessionSelectionSheet({
    Key? key,
    required this.sessions,
    required this.event,
    required this.eventDetail,
    required this.isTableBooking,
  }) : super(key: key);

  @override
  State<SessionSelectionSheet> createState() => _SessionSelectionSheetState();
}

class _SessionSelectionSheetState extends State<SessionSelectionSheet> {
  dynamic selectedSession;
  DateTime? selectedDate;
  List<DateTime>? selectedDates; // For weekly

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    
    // Filter out past sessions
    final upcoming = widget.sessions.where((s) {
      try {
        final endDate = DateTime.parse(s.lastSessionDate ?? s.firstSessionDate ?? '');
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
                itemBuilder: (ctx, i) => _buildSessionItem(
                  upcoming[i],
                  theme,
                  context,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSessionItem(dynamic session, ThemeData theme, BuildContext context) {
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
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
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
              if (type == 'weekly' && session.daysOfWeek is List && session.daysOfWeek.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Every: ${session.daysOfWeek.map((d) => d.toString().substring(0, 3)).join(', ')}',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),

              // Date/Day Selection UI
              if (selectedSession == session) ...[
                SizedBox(height: 12),
                _buildDateSelectionUI(type, session, context, theme),
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
    ThemeData theme,
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
            style: TextStyle(color: Color(0xFFD1B26F), fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              text: widget.isTableBooking ? 'Book Sofa & Table' : 'Continue to Booking',
              onPressed: () => _proceedToBooking(session, _formatDate(session.firstSessionDate)),
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
                    selectedDate != null ? _formatDate(selectedDate.toString()) : 'Choose date',
                    style: TextStyle(
                      color: selectedDate != null ? Colors.white : Colors.white54,
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
              text: widget.isTableBooking ? 'Book Sofa & Table' : 'Continue to Booking',
              onPressed: () => _proceedToBooking(session, _formatDate(selectedDate.toString())),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildWeeklySessionUI(dynamic session, BuildContext context) {
    final startDate = DateTime.parse(session.firstSessionDate);
    final endDate = DateTime.parse(session.lastSessionDate);
    final allowedDays = (session.daysOfWeek as List).map((d) => d.toString().toLowerCase()).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select a date (only allowed days):',
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showWeeklyDatePicker(context, startDate, endDate, allowedDays, session),
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
                    selectedDate != null ? _formatDate(selectedDate.toString()) : 'Choose date',
                    style: TextStyle(
                      color: selectedDate != null ? Colors.white : Colors.white54,
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
              text: widget.isTableBooking ? 'Book Sofa & Table' : 'Continue to Booking',
              onPressed: () => _proceedToBooking(session, _formatDate(selectedDate.toString())),
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
                    selectedDate != null ? _formatDate(selectedDate.toString()) : 'Choose date',
                    style: TextStyle(
                      color: selectedDate != null ? Colors.white : Colors.white54,
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
              text: widget.isTableBooking ? 'Book Sofa & Table' : 'Continue to Booking',
              onPressed: () => _proceedToBooking(session, _formatDate(selectedDate.toString())),
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
            style: TextStyle(color: Color(0xFFD1B26F), fontWeight: FontWeight.w500),
          ),
          Text(
            '${_formatDate(session.firstSessionDate)} • ${formatTimeToAmPm(session.sessionStartTime)} – ${formatTimeToAmPm(session.sessionEndTime)}',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              text: widget.isTableBooking ? 'Book Sofa & Table' : 'Continue to Booking',
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
      selectedDates = null;

      // Auto-select for single and time_slot
      if (type == 'single' || type == 'time_slot') {
        selectedDate = DateTime.parse(session.firstSessionDate);
      }
    });
  }

  void _showDatePicker(BuildContext context, dynamic session, String type) async {
    final startDate = DateTime.parse(session.firstSessionDate);
    final endDate = DateTime.parse(session.lastSessionDate);

    final picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: startDate,
      lastDate: endDate,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.dark(primary: Color(0xFFD1B26F)),
        ),
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
        final dayName = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'][
            (date.weekday - 1) % 7];
        return allowedDays.contains(dayName);
      },
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.dark(primary: Color(0xFFD1B26F)),
        ),
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
    if (widget.isTableBooking) {
      Navigator.pop(context);
      context.push(
        "/table-booking",
        extra: {
          'event': widget.event,
          'session': session,
          'selected_date': selectedDateStr,
        },
      );
    } else {
      Navigator.pop(context);
      context.push(
        "/ticket-booking",
        extra: TicketBookInfoArg(
          event: widget.event,
          eventDetail: widget.eventDetail,
          tickets: [],
          promoCode: '',
          session: session,
          selectedDate: selectedDateStr,
        ),
      );
    }
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
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month];
  }
}

