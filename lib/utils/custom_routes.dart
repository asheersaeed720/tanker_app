import 'package:get/get.dart';
import 'package:tanker_app/src/auth/views/auth_screen.dart';
import 'package:tanker_app/src/auth/views/otp_verification_screen.dart';
import 'package:tanker_app/src/auth/views/phone_auth_screen.dart';
import 'package:tanker_app/src/booking/booking_screen.dart';

final List<GetPage<dynamic>> customRoutes = [
  GetPage(
    name: AuthScreen.routeName,
    page: () => const AuthScreen(),
  ),
  GetPage(
    name: PhoneAuthScreen.routeName,
    page: () => const PhoneAuthScreen(),
  ),
  GetPage(
    name: BookingScreen.routeName,
    page: () => const BookingScreen(),
  ),
  GetPage(
    name: OtpVerificationScreen.routeName,
    page: () => const OtpVerificationScreen(),
  ),
];
