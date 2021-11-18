import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:tanker_app/src/auth/auth_controller.dart';
import 'package:tanker_app/utils/app_theme.dart';
import 'package:tanker_app/widgets/custom_async_btn.dart';
import 'package:tanker_app/widgets/loading_widget.dart';

class OtpVerificationScreen extends StatefulWidget {
  static const String routeName = '/otp-verification';

  const OtpVerificationScreen({this.verificationId = '', Key? key}) : super(key: key);

  final String verificationId;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _authController = Get.find<AuthController>();

  late Timer _timer;
  int _start = 120;

  void startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_start == 0) {
          if (mounted) {
            setState(() {
              timer.cancel();
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _start--;
            });
          }
        }
      },
    );
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

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
          child: GetBuilder<AuthController>(
            builder: (_) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3.5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset("assets/images/otp_phone.png", width: 218.0),
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
                PinCodeTextField(
                  autofocus: true,
                  controller: _authController.pinController,
                  hideCharacter: true,
                  highlight: true,
                  highlightColor: Colors.blue,
                  defaultBorderColor: Colors.black,
                  hasTextBorderColor: Colors.green,
                  maxLength: 6,
                  onDone: (text) {
                    _authController.signIn(widget.verificationId, text);
                  },
                  pinBoxWidth: 50,
                  pinBoxHeight: 64,
                  hasUnderline: true,
                  wrapAlignment: WrapAlignment.spaceAround,
                  pinBoxDecoration: ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                  pinTextStyle: const TextStyle(fontSize: 22.0),
                  pinTextAnimatedSwitcherTransition: ProvidedPinBoxTextAnimation.scalingTransition,
                  pinTextAnimatedSwitcherDuration: const Duration(milliseconds: 300),
                  highlightAnimationBeginColor: Colors.black,
                  highlightAnimationEndColor: Colors.white12,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                if (_start == 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: CustomAsyncBtn(
                      btntxt: 'Resend',
                      onPress: _authController.disableWhileLoad
                          ? null
                          : () async {
                              await _authController.phoneNoVerification(isResend: true);
                              setState(() {
                                _start = 120;
                              });
                              startTimer();
                            },
                    ),
                  ),
                if (_start != 0) Text('Code Expiry: $_start'),
                const SizedBox(height: 18),
                _authController.disableWhileLoad ? const LoadingWidget() : const SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }

  // @override
  // void dispose() {
  //   _pinController.dispose();
  //   _timer.cancel();
  //   super.dispose();
  // }
}
