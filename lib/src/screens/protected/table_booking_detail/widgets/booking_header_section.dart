import 'package:flutter/material.dart';
import 'package:mingly/src/application/booking/model/order_detail.dart';
import 'package:mingly/src/components/helpers.dart';
import 'package:mingly/src/constant/app_urls.dart';

class BookingHeaderSection extends StatelessWidget {
  final OrderDetailResponse orderDetail;

  const BookingHeaderSection({required this.orderDetail, super.key});

  @override
  Widget build(BuildContext context) {
    final image = orderDetail.event?.images?.firstOrNull?.imageUrl;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 200,
          width: double.infinity,
          child: image != null
              ? Image.network(
                  AppUrls.imageUrl + image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const NoImage(),
                )
              : const NoImage(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                orderDetail.event?.eventName ?? 'Event',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${orderDetail.event?.venue?.name ?? "N/A"}, ${orderDetail.event?.venue?.city ?? "N/A"}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
