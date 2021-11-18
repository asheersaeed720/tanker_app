import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tanker_app/src/booking/booking_model.dart';
import 'package:tanker_app/src/network_manager.dart';
import 'package:tanker_app/utils/custom_snack_bar.dart';
import 'package:tanker_app/utils/display_toast_message.dart';
import 'package:tanker_app/utils/firebase_collection_ref.dart';

class BookingController extends NetworkManager {
  BookingModel bookingFormModel = BookingModel();

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

  Future<void> addBooking() async {
    if (connectionType != 0) {
      await bookingRef
          .add(BookingModel(
        uid: FirebaseAuth.instance.currentUser!.uid,
        bookingId: DateTime.now().millisecondsSinceEpoch.remainder(100000).toString(),
        name: bookingFormModel.name,
        phoneNo: bookingFormModel.phoneNo,
        houseNo: bookingFormModel.houseNo,
        block: bookingFormModel.block,
        area: bookingFormModel.area,
        gallons: bookingFormModel.gallons,
        status: 'Pending',
        createdAt: Timestamp.now(),
      ))
          .then((_) {
        Get.back();
        displayToastMessage('Booking Added');
      }).catchError((error) {
        log("Failed to add trip: $error");
      });
    } else {
      customSnackBar('Network error', 'Check your internet connection try again later');
    }
  }
}
