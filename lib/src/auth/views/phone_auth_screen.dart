import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:tanker_app/src/auth/auth_controller.dart';
import 'package:tanker_app/utils/input_decoration.dart';
import 'package:tanker_app/widgets/custom_async_btn.dart';
import 'package:tanker_app/widgets/loading_widget.dart';

class PhoneAuthScreen extends StatefulWidget {
  static const String routeName = '/phone-auth';

  const PhoneAuthScreen({Key? key}) : super(key: key);

  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _authController = Get.find<AuthController>();

  bool isNumberValidate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
              child: GetBuilder<AuthController>(
                builder: (_) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/dummy_logo.png',
                        width: MediaQuery.of(context).size.width * 0.6,
                      ),
                    ),
                    const SizedBox(height: 38.0),
                    _buildPhoneNoField(),
                    const SizedBox(height: 32.0),
                    _authController.disableWhileLoad
                        ? const LoadingWidget()
                        : CustomAsyncBtn(
                            btntxt: 'Continue',
                            onPress: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                FocusScopeNode currentFocus = FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                                await _authController.phoneNoVerification();
                              }
                            },
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneNoField() {
    return InternationalPhoneNumberInput(
      isEnabled: _authController.disableWhileLoad ? false : true,
      onInputChanged: (PhoneNumber number) async {
        var numberWithCode = '';
        if (number.isoCode == 'PK') {
          numberWithCode = number.phoneNumber!.padLeft(12, '0');
        } else {
          numberWithCode = number.phoneNumber ?? '';
        }
        _authController.userFormModel.phoneNo = numberWithCode.trim();
      },
      selectorConfig: const SelectorConfig(
        selectorType: PhoneInputSelectorType.DIALOG,
      ),
      autoValidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Required';
        } else if (!isNumberValidate) {
          return 'Invalid phone number';
        }
        return null;
      },
      onInputValidated: (value) {
        setState(() {
          isNumberValidate = value;
        });
      },
      initialValue: PhoneNumber(isoCode: 'PK'),
      ignoreBlank: false,
      maxLength: 14,
      selectorTextStyle: const TextStyle(color: Colors.black),
      formatInput: false,
      inputBorder: const OutlineInputBorder(),
      inputDecoration: buildTextFieldInputDecoration(context, labelTxt: 'Mobile no'),
    );
  }
}
