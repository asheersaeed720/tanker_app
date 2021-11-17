import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tanker_app/src/auth/models/user.dart';
import 'package:tanker_app/src/auth/views/auth_screen.dart';
import 'package:tanker_app/src/auth/views/otp_verification_screen.dart';
import 'package:tanker_app/src/booking/booking_screen.dart';
import 'package:tanker_app/src/network_manager.dart';
import 'package:tanker_app/utils/display_toast_message.dart';
import 'package:tanker_app/utils/firebase_collection_ref.dart';

class AuthController extends NetworkManager {
  bool disableWhileLoad = false;

  bool _obscureText = true;
  bool get obscureText => _obscureText;
  set obscureText(bool newObscureVal) {
    _obscureText = newObscureVal;
    update();
  }

  UserModel userFormModel = UserModel();

  phoneNoVerification() async {
    disableWhileLoad = true;
    update();
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: userFormModel.phoneNo,
      verificationCompleted: (PhoneAuthCredential credential) async {},
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
        Get.to(() => OtpVerificationScreen(verificationId: verificationId));
      },
      timeout: const Duration(seconds: 120),
      codeAutoRetrievalTimeout: (String verificationId) {
        disableWhileLoad = false;
        update();
      },
    );
  }

  saveUser() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    Map<String, dynamic> data = {
      "uid": uid,
      "phone_no": userFormModel.phoneNo,
    };
    await users.doc(uid).set(data);
    Get.offAllNamed(BookingScreen.routeName);
  }

  signOutUser() async {
    Get.back();
    disableWhileLoad = true;
    update();
    await FirebaseAuth.instance.signOut();
    Get.offAndToNamed(AuthScreen.routeName);
    disableWhileLoad = false;
    update();
    displayToastMessage('Logout');
  }

  // Future<void> logInUser() async {
  //   try {
  //     disableWhileLoad = true;
  //     update();
  //     UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: 'companyUserForm.companyEmail',
  //       password: 'companyUserForm.password',
  //     );
  //     if (userCredential.user != null) {
  //       // await userReference.doc(userCredential.user!.uid).get();
  //       Get.offAllNamed(AuthScreen.routeName);
  //       disableWhileLoad = false;
  //       update();
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found') {
  //       displayToastMessage('No user found for that email.');
  //     } else if (e.code == 'wrong-password') {
  //       displayToastMessage('Wrong password');
  //     } else {
  //       log(e.code);
  //     }
  //     disableWhileLoad = false;
  //     update();
  //   } on TimeoutException catch (_) {
  //     disableWhileLoad = false;
  //     update();
  //     customSnackBar('Error', 'Network error, please try again later');
  //   } on SocketException catch (_) {
  //     disableWhileLoad = false;
  //     update();
  //     customSnackBar('Error', 'Network error, please try again later');
  //   } catch (e) {
  //     disableWhileLoad = false;
  //     update();
  //     log(e.toString());
  //   }
  // }

  // Future<void> signUpUser() async {
  //   try {
  //     disableWhileLoad = true;
  //     update();

  //     UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //       email: 'companyUserForm.companyEmail',
  //       password: 'companyUserForm.password',
  //     );
  //     if (userCredential.user != null) {
  //       Map<String, dynamic> data = {
  //         "uid": userCredential.user!.uid,
  //         "is_approved": false,
  //       };
  //       // await companyUserReference.doc(userCredential.user!.uid).set(data);
  //       // FirebaseAuth.instance.currentUser!.updateDisplayName(companyUserForm.companyNameAndLogo);
  //       // Get.offAllNamed(EmailVerificationScreen.routeName);
  //       disableWhileLoad = false;
  //       update();
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'weak-password') {
  //       displayToastMessage('Password is too weak');
  //     } else if (e.code == 'email-already-in-use') {
  //       displayToastMessage('Email aleady exist');
  //     } else {
  //       log(e.message ?? '');
  //     }
  //     disableWhileLoad = false;
  //     update();
  //   } on TimeoutException catch (_) {
  //     disableWhileLoad = false;
  //     update();
  //     customSnackBar('Error', 'Network error, please try again later');
  //   } on SocketException catch (_) {
  //     disableWhileLoad = false;
  //     update();
  //     customSnackBar('Error', 'Network error, please try again later');
  //   } catch (e) {
  //     disableWhileLoad = false;
  //     update();
  //     log(e.toString());
  //   }
  // }

  // Future<void> forgotPw() async {
  //   disableWhileLoad = true;
  //   FirebaseAuth.instance.sendPasswordResetEmail(email: resetPwEmail.text).then((_) {
  //     disableWhileLoad = false;
  //     resetPwEmail.clear();
  //     displayToastMessage('Check your email');
  //     update();
  //   }).catchError((e) {
  //     disableWhileLoad = false;
  //     resetPwEmail.clear();
  //     update();
  //     displayToastMessage('$e');
  //   });
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   videoController!.dispose();
  // }
}
