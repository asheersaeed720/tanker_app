import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  String? uid;
  String? bookingId;
  String? name;
  String? phoneNo;
  String? houseNo;
  String? block;
  String? area;
  String? gallons;
  String? status;
  Timestamp? createdAt;

  BookingModel({
    this.uid,
    this.bookingId,
    this.name,
    this.phoneNo,
    this.houseNo,
    this.block,
    this.area,
    this.gallons,
    this.status,
    this.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      uid: json['uid'],
      bookingId: json['booking_id'],
      name: json['name'],
      phoneNo: json['phone_no'],
      houseNo: json['house_no'],
      block: json['block'],
      area: json['area'],
      gallons: json['gallons'],
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
      'house_no': houseNo,
      'block': houseNo,
      'area': block,
      'gallons': gallons,
      'status': status,
      'created_at': createdAt,
    };
  }
}
