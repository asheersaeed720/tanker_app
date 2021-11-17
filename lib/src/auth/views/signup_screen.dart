import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:tanker_app/src/auth/auth_controller.dart';
import 'package:tanker_app/src/booking/booking_screen.dart';
import 'package:tanker_app/utils/input_decoration.dart';
import 'package:tanker_app/widgets/custom_async_btn.dart';
import 'package:tanker_app/widgets/loading_widget.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = '/sign-up';

  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _authController = Get.find<AuthController>();

  bool isNumberValidate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 44.0,
            left: 16.0,
            child: InkWell(
              onTap: () => Get.back(),
              child: const Icon(Icons.arrow_back),
            ),
          ),
          Center(
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
                        // Center(
                        //   child: Image.asset(
                        //     'assets/images/dummy_logo.png',
                        //     width: MediaQuery.of(context).size.width * 0.6,
                        //   ),
                        // ),
                        Text('Lets get started!', style: Theme.of(context).textTheme.headline1),
                        const SizedBox(height: 38.0),
                        _buildNameTextField(),
                        const SizedBox(height: 18.0),
                        _buildPhoneNoField(),
                        const SizedBox(height: 18.0),
                        _buildPasswordTextField(),
                        const SizedBox(height: 18.0),
                        _authController.disableWhileLoad
                            ? const LoadingWidget()
                            : CustomAsyncBtn(
                                btntxt: 'Sign up',
                                onPress: () async {
                                  Get.toNamed(BookingScreen.routeName);
                                  // if (_formKey.currentState!.validate()) {
                                  //   _formKey.currentState!.save();
                                  //   FocusScopeNode currentFocus = FocusScope.of(context);
                                  //   if (!currentFocus.hasPrimaryFocus) {
                                  //     currentFocus.unfocus();
                                  //   }
                                  //   await _authController.logInUser();
                                  // }
                                },
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameTextField() {
    return TextFormField(
      onChanged: (value) {},
      validator: (value) {
        if (value!.isEmpty) {
          return 'Required';
        }
        return null;
      },
      keyboardType: TextInputType.name,
      decoration: buildTextFieldInputDecoration(context, labelTxt: 'Name'),
    );
  }

  Widget _buildPhoneNoField() {
    return InternationalPhoneNumberInput(
      onInputChanged: (PhoneNumber number) async {
        var numberWithCode = '';
        if (number.isoCode == 'PK') {
          numberWithCode = number.phoneNumber!.padLeft(12, '0');
        } else {
          numberWithCode = number.phoneNumber ?? '';
        }
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

  Widget _buildPasswordTextField() {
    return TextFormField(
      onChanged: (value) {},
      obscureText: _authController.obscureText,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Required';
        }
        return null;
      },
      keyboardType: TextInputType.visiblePassword,
      decoration: buildPasswordInputDecoration(
        context,
        labelTxt: 'Password',
        suffixIcon: GestureDetector(
          onTap: () {
            _authController.obscureText = !_authController.obscureText;
          },
          child: Icon(
            _authController.obscureText ? Icons.visibility : Icons.visibility_off,
          ),
        ),
      ),
    );
  }
}
