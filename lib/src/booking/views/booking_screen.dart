import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanker_app/src/booking/booking_controller.dart';
import 'package:tanker_app/src/booking/booking_item.dart';
import 'package:tanker_app/src/booking/booking_model.dart';
import 'package:tanker_app/src/booking/views/add_booking_screen.dart';
import 'package:tanker_app/utils/custom_app_bar.dart';
import 'package:tanker_app/widgets/custom_button.dart';
import 'package:tanker_app/widgets/loading_widget.dart';

class BookingScreen extends StatelessWidget {
  static const String routeName = '/booking';

  const BookingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: customAppBar(context, 'Booking'),
      body: GetBuilder<BookingController>(
        init: BookingController(),
        builder: (bookingController) => StreamBuilder<QuerySnapshot<BookingModel>>(
          stream: bookingController.getUserBookings(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<QueryDocumentSnapshot<BookingModel>> bookingList =
                  snapshot.data!.docs as List<QueryDocumentSnapshot<BookingModel>>;
              return bookingList.length == 0
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('No Bookings!', style: Theme.of(context).textTheme.headline1),
                          const SizedBox(height: 12.0),
                          Text('There is no tankers bookings found yet.',
                              style: Theme.of(context).textTheme.bodyText1),
                          const SizedBox(height: 14.0),
                          CustomButton(
                            btnTxt: 'Add Booking',
                            onPressed: () => Get.toNamed(AddBookingScreen.routeName),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      itemBuilder: (context, i) => BookingItem(bookingList[i].data()),
                      itemCount: bookingList.length,
                      separatorBuilder: (context, i) => const Divider(),
                    );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            }
            return const LoadingWidget();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Get.toNamed(AddBookingScreen.routeName),
      ),
    );
  }
}
