import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:tanker_app/src/auth/auth_controller.dart';
import 'package:tanker_app/utils/app_theme.dart';
import 'package:tanker_app/utils/display_toast_message.dart';
import 'package:tanker_app/widgets/loading_widget.dart';

class OtpVerificationScreen extends StatefulWidget {
  static const String routeName = '/otp-verification';

  const OtpVerificationScreen({this.verificationId, Key? key}) : super(key: key);

  final String? verificationId;

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _authController = Get.find<AuthController>();

  TextEditingController controller = TextEditingController(text: "");
  String thisText = "";
  int pinLength = 6;
  bool hasError = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Otp Verification',
          style: TextStyle(
            fontFamily: AppTheme.fontName,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            color: AppTheme.nearBlack,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 3.5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset("assets/images/otp_phone.png"),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Phone Number Verification',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: TextSpan(
                    text: "Enter the code sent to ",
                    children: [
                      TextSpan(
                        text: _authController.userFormModel.phoneNo,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ],
                    style: const TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              GetBuilder<AuthController>(
                builder: (_) => PinCodeTextField(
                  autofocus: true,
                  controller: controller,
                  hideCharacter: true,
                  highlight: true,
                  highlightColor: Colors.blue,
                  defaultBorderColor: Colors.black,
                  hasTextBorderColor: Colors.green,
                  maxLength: pinLength,
                  hasError: hasError,
                  maskCharacter: "*",
                  onTextChanged: (text) {
                    setState(() {
                      hasError = false;
                    });
                  },
                  onDone: (text) async {
                    // print("DONE $text");
                    // print("DONE CONTROLLER ${controller.text}");
                    _authController.disableWhileLoad = true;
                    _authController.update();
                    AuthCredential credential = PhoneAuthProvider.credential(
                      verificationId: '${widget.verificationId}',
                      smsCode: text,
                    );
                    await FirebaseAuth.instance.signInWithCredential(credential).then((_) async {
                      await _authController.saveUser();
                      _authController.disableWhileLoad = false;
                      _authController.update();
                    }).catchError((e) {
                      _authController.disableWhileLoad = false;
                      _authController.update();
                      displayToastMessage('Invalid Otp');
                      log('$e');
                    });
                  },
                  pinBoxWidth: 50,
                  pinBoxHeight: 64,
                  hasUnderline: true,
                  wrapAlignment: WrapAlignment.spaceAround,
                  pinBoxDecoration: ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                  pinTextStyle: const TextStyle(fontSize: 22.0),
                  pinTextAnimatedSwitcherTransition: ProvidedPinBoxTextAnimation.scalingTransition,
//                    pinBoxColor: Colors.green[100],
                  pinTextAnimatedSwitcherDuration: const Duration(milliseconds: 300),
//                    highlightAnimation: true,
                  highlightAnimationBeginColor: Colors.black,
                  highlightAnimationEndColor: Colors.white12,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 18),
              _authController.disableWhileLoad ? const LoadingWidget() : const SizedBox(),
              // Visibility(
              //   child: const Text(
              //     "Wrong PIN!",
              //   ),
              //   visible: hasError,
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 32.0),
              //   child: Wrap(
              //     alignment: WrapAlignment.spaceEvenly,
              //     children: <Widget>[
              //       MaterialButton(
              //         color: Colors.blue,
              //         textColor: Colors.white,
              //         child: const Text("+"),
              //         onPressed: () {
              //           setState(() {
              //             pinLength++;
              //           });
              //         },
              //       ),
              //       MaterialButton(
              //         color: Colors.blue,
              //         textColor: Colors.white,
              //         child: const Text("-"),
              //         onPressed: () {
              //           setState(() {
              //             pinLength--;
              //           });
              //         },
              //       ),
              //       MaterialButton(
              //         color: Colors.blue,
              //         textColor: Colors.white,
              //         child: const Text("SUBMIT"),
              //         onPressed: () {
              //           setState(() {
              //             thisText = controller.text;
              //           });
              //         },
              //       ),
              //       MaterialButton(
              //         color: Colors.red,
              //         textColor: Colors.white,
              //         child: const Text("SUBMIT Error"),
              //         onPressed: () {
              //           setState(() {
              //             hasError = true;
              //           });
              //         },
              //       ),
              //       MaterialButton(
              //         color: Colors.pink,
              //         textColor: Colors.white,
              //         child: const Text("CLEAR PIN"),
              //         onPressed: () {
              //           controller.clear();
              //         },
              //       ),
              //       MaterialButton(
              //         color: Colors.lime,
              //         textColor: Colors.black,
              //         child: const Text("SET TO 456"),
              //         onPressed: () {
              //           controller.text = "456";
              //         },
              //       ),
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
