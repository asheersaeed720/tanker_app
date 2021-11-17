import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference users = FirebaseFirestore.instance.collection('users');
final CollectionReference bookings = FirebaseFirestore.instance.collection('bookings');
