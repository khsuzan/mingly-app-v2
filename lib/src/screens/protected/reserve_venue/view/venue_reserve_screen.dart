import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mingly/src/application/venues/model/venues_model.dart';

import '../controller/venue_reserve_controller.dart';

class VenueReserveScreen extends StatelessWidget {
  final VenuesModel venue;
  const VenueReserveScreen({super.key, required this.venue});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.put(VenueReserveController());
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
          'Reserve Venue',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                venue.name ?? '',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Reservation Request',
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              // Date Picker
              Text('Date', style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),
              _DatePickerField(
                onDateSelected: (date) {
                  controller.updateDate(date);
                },
              ),
              const SizedBox(height: 16),
              // Person Count
              Text('Person Count', style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),
              _PersonCountField(
                onCountChanged: (count) => controller.updatePersonCount(count),
              ),
              const SizedBox(height: 16),
              // From Time
              Text('From Time', style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),
              _TimePickerField(
                label: 'From Time',
                onTimeSelected: (time) {
                  controller.updateFromTime(time);
                },
              ),
              const SizedBox(height: 16),
              // To Time
              Text('To Time', style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),
              _TimePickerField(
                label: 'To Time',
                onTimeSelected: (time) {
                  controller.updateToTime(time);
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    //controller.reserveVenue(venue.id);
                  },
                  child: const Text(
                    'Request a Reservation',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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

// Date Picker Field
class _DatePickerField extends StatefulWidget {
  final Function(DateTime)? onDateSelected;
  const _DatePickerField({this.onDateSelected});
  @override
  State<_DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<_DatePickerField> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (picked != null) {
          setState(() {
            selectedDate = picked;
          });
          if (widget.onDateSelected != null) {
            widget.onDateSelected!(picked);
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.white70),
            const SizedBox(width: 12),
            Text(
              selectedDate == null
                  ? 'Select date'
                  : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

// Person Count Field
class _PersonCountField extends StatefulWidget {
  final Function(int)? onCountChanged;
  const _PersonCountField({this.onCountChanged});
  @override
  State<_PersonCountField> createState() => _PersonCountFieldState();
}

class _PersonCountFieldState extends State<_PersonCountField> {
  int count = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.people, color: Colors.white70),
          const SizedBox(width: 12),
          Text('Persons:', style: TextStyle(color: Colors.white)),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.remove, color: Colors.white70),
            onPressed: count > 1
                ? () {
                    count--;
                    setState(() {});
                    if (widget.onCountChanged != null) {
                      widget.onCountChanged!(count);
                    }
                  }
                : null,
          ),
          Text('$count', style: TextStyle(color: Colors.white, fontSize: 16)),
          IconButton(
            icon: Icon(Icons.add, color: Colors.white70),
            onPressed: () {
              count++;
              setState(() {});
              if (widget.onCountChanged != null) {
                widget.onCountChanged!(count);
              }
            },
          ),
        ],
      ),
    );
  }
}

// Time Picker Field
class _TimePickerField extends StatefulWidget {
  final String label;
  final Function(TimeOfDay)? onTimeSelected;
  const _TimePickerField({required this.label, this.onTimeSelected});

  @override
  State<_TimePickerField> createState() => _TimePickerFieldState();
}

class _TimePickerFieldState extends State<_TimePickerField> {
  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (picked != null) {
          setState(() {
            selectedTime = picked;
          });
          if (widget.onTimeSelected != null) {
            widget.onTimeSelected!(picked);
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time, color: Colors.white70),
            const SizedBox(width: 12),
            Text(
              selectedTime == null
                  ? 'Select ${widget.label.toLowerCase()}'
                  : selectedTime!.format(context),
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
