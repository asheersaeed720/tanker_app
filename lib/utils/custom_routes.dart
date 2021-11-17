import 'package:get/get.dart';
import 'package:tanker_app/src/auth/views/auth_screen.dart';
import 'package:tanker_app/src/auth/views/login_screen.dart';
import 'package:tanker_app/src/auth/views/otp_verification_screen.dart';
import 'package:tanker_app/src/auth/views/signup_screen.dart';
import 'package:tanker_app/src/booking/booking_screen.dart';

final List<GetPage<dynamic>> customRoutes = [
  GetPage(
    name: AuthScreen.routeName,
    page: () => const AuthScreen(),
  ),
  GetPage(
    name: LogInScreen.routeName,
    page: () => const LogInScreen(),
  ),
  GetPage(
    name: SignUpScreen.routeName,
    page: () => const SignUpScreen(),
  ),
  GetPage(
    name: BookingScreen.routeName,
    page: () => const BookingScreen(),
  ),
  GetPage(
    name: OtpVerificationScreen.routeName,
    page: () => OtpVerificationScreen(),
  ),
];
