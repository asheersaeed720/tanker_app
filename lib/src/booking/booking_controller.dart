import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tanker_app/src/booking/booking_model.dart';
import 'package:tanker_app/utils/display_toast_message.dart';
import 'package:tanker_app/utils/firebase_collection_ref.dart';

class BookingController extends GetxController {
  final bookingRef = bookings.withConverter<BookingModel>(
    fromFirestore: (snapshot, _) => BookingModel.fromJson(snapshot.data()!),
    toFirestore: (trip, _) => trip.toJson(),
  );

  Stream<QuerySnapshot<BookingModel>> getUserBookings() {
    return bookingRef
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  Future<void> addBooking(String name, String phoneNo, String tankerType, String address) async {
    await bookingRef
        .add(BookingModel(
      uid: FirebaseAuth.instance.currentUser!.uid,
      bookingId: DateTime.now().millisecondsSinceEpoch.remainder(100000).toString(),
      name: name,
      phoneNo: phoneNo,
      address: address,
      tankerType: tankerType,
      status: 'Pending',
      createdAt: Timestamp.now(),
    ))
        .then((_) {
      Get.back();
      // Get.to(() => TripDetailScreen(tripId: trip.id));
      displayToastMessage('Booking Added');
    }).catchError((error) {
      log("Failed to add trip: $error");
    });
  }
}
