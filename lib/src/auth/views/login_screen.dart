import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:tanker_app/src/auth/auth_controller.dart';
import 'package:tanker_app/utils/input_decoration.dart';
import 'package:tanker_app/widgets/custom_async_btn.dart';
import 'package:tanker_app/widgets/loading_widget.dart';

class LogInScreen extends StatefulWidget {
  static const String routeName = '/login';

  const LogInScreen({Key? key}) : super(key: key);

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
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
                    // const SizedBox(height: 18.0),
                    // _buildPasswordTextField(),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsets.only(top: 6.0),
                    //       child: TextButton(
                    //         onPressed: () {
                    //           // Get.toNamed(ForgotPasswordScreen.routeName);
                    //         },
                    //         child: Text(
                    //           'Forgot password?',
                    //           style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    //                 decoration: TextDecoration.underline,
                    //                 color: Colors.blue[800],
                    //                 fontSize: 14.0,
                    //               ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
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
                    // const SizedBox(height: 20.0),
                    // Center(
                    //   child: Row(
                    //     children: [
                    //       const Text("Don't have an account? "),
                    //       InkWell(
                    //         onTap: () => Get.toNamed(SignUpScreen.routeName),
                    //         child: Text(
                    //           'Register',
                    //           style: TextStyle(
                    //             color: Colors.blue[800],
                    //             fontWeight: FontWeight.bold,
                    //             decoration: TextDecoration.underline,
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // )
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
