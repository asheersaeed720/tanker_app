import 'package:flutter/material.dart';
import 'package:tanker_app/src/booking/booking_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class BookingItem extends StatelessWidget {
  final BookingModel bookingItem;

  const BookingItem(this.bookingItem, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String name = bookingItem.name ?? '';
    String formattedTimeAgo = timeago.format(DateTime.parse('${bookingItem.createdAt!.toDate()}'));
    return Container(
      width: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3F8),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formattedTimeAgo,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '#${bookingItem.bookingId}',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
              ),
              Text('${bookingItem.status}'),
            ],
          ),
          // const SizedBox(height: 15),
          const Divider(thickness: 1.0, height: 18.0),
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: Colors.blue, size: 32),
              const SizedBox(width: 10),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 210),
                child: Text(
                  '${bookingItem.houseNo} - ${bookingItem.block} - ${bookingItem.area}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey.withOpacity(0.9),
                  ),
                ),
              )
            ],
          ),
          // const SizedBox(height: 8.0),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     Text(
          //       'View Details',
          //       style: TextStyle(color: Colors.blue[800]),
          //       textAlign: TextAlign.end,
          //     ),
          //     Icon(Icons.arrow_forward, size: 18.0, color: Colors.blue[800])
          //   ],
          // ),
        ],
      ),
    );
  }
}
