import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String uid;
  final String bookingId;
  final String name;
  final String phoneNo;
  final String address;
  final String tankerType;
  final String status;
  final Timestamp createdAt;

  BookingModel({
    required this.uid,
    required this.bookingId,
    required this.name,
    required this.phoneNo,
    required this.address,
    required this.tankerType,
    required this.status,
    required this.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      uid: json['uid'],
      bookingId: json['booking_id'],
      name: json['name'],
      phoneNo: json['phone_no'],
      address: json['address'],
      tankerType: json['tanker_type'],
      status: json['status'],
      createdAt: json['created_at'],
    );
  }

  Map<String, Object?> toJson() {
    return {
      'uid': uid,
      'booking_id': bookingId,
      'name': name,
      'phone_no': phoneNo,
      'address': address,
      'tanker_type': tankerType,
      'status': status,
      'created_at': createdAt,
    };
  }
}
