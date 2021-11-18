import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tanker_app/src/auth/models/user.dart';
import 'package:tanker_app/src/auth/views/auth_screen.dart';
import 'package:tanker_app/src/auth/views/otp_verification_screen.dart';
import 'package:tanker_app/src/booking/booking_screen.dart';
import 'package:tanker_app/src/network_manager.dart';
import 'package:tanker_app/utils/custom_snack_bar.dart';
import 'package:tanker_app/utils/display_toast_message.dart';
import 'package:tanker_app/utils/firebase_collection_ref.dart';

class AuthController extends NetworkManager {
  bool disableWhileLoad = false;

  Map<String, dynamic> storedUser = {};

  UserModel userFormModel = UserModel();

  @override
  void onInit() {
    storedUser = GetStorage().read('user') ?? {};
    log('$storedUser', name: 'user');
    super.onInit();
  }

  phoneNoVerification({bool isResend = false}) async {
    if (connectionType != 0) {
      disableWhileLoad = true;
      update();
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: userFormModel.phoneNo,
        verificationCompleted: (PhoneAuthCredential credential) {
          FirebaseAuth.instance.signInWithCredential(credential).then((_) {
            saveUserToFirebase();
          }).catchError((e) {
            disableWhileLoad = false;
            update();
            displayToastMessage('Invalid Otp');
            log('$e');
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            displayToastMessage('The provided phone number is not valid.');
          }
          disableWhileLoad = false;
          update();
        },
        codeSent: (String verificationId, int? resendToken) async {
          disableWhileLoad = false;
          update();
          if (!isResend) Get.to(() => OtpVerificationScreen(verificationId: verificationId));
        },
        timeout: const Duration(seconds: 120),
        codeAutoRetrievalTimeout: (String verificationId) {
          disableWhileLoad = false;
          update();
        },
      );
      disableWhileLoad = false;
      update();
    } else {
      customSnackBar('Network error', 'Check your internet connection try again later');
    }
  }

  void signIn(String verificationId, String smsCode) {
    disableWhileLoad = true;
    update();
    AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    FirebaseAuth.instance.signInWithCredential(credential).then((_) {
      saveUserToFirebase();
    }).catchError((e) {
      disableWhileLoad = false;
      update();
      displayToastMessage('Invalid Otp');
      log('$e');
    });
  }

  Future<void> saveUserToFirebase() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    Map<String, dynamic> data = {
      "uid": uid,
      "phone_no": userFormModel.phoneNo,
    };
    GetStorage().write('user', data);
    storedUser = GetStorage().read('user');
    await users.doc(uid).set(data);
    disableWhileLoad = false;
    update();
    Get.offAllNamed(BookingScreen.routeName);
  }

  signOutUser() async {
    Get.back();
    disableWhileLoad = true;
    update();
    await FirebaseAuth.instance.signOut();
    GetStorage().remove('user');
    Get.offAndToNamed(AuthScreen.routeName);
    disableWhileLoad = false;
    update();
    displayToastMessage('Logout');
  }
}
