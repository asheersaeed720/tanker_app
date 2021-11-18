import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:tanker_app/src/booking/booking_controller.dart';
import 'package:tanker_app/utils/custom_app_bar.dart';
import 'package:tanker_app/utils/input_decoration.dart';
import 'package:tanker_app/widgets/custom_async_btn.dart';

class AddBookingScreen extends StatefulWidget {
  static const String routeName = '/add-booking';

  const AddBookingScreen({Key? key}) : super(key: key);

  @override
  State<AddBookingScreen> createState() => _AddBookingScreenState();
}

class _AddBookingScreenState extends State<AddBookingScreen> {
  final _bookingController = Get.put(BookingController());

  final _formKey = GlobalKey<FormState>();

  bool isNumberValidate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: customAppBar(context, 'Request Tanker'),
      body: Form(
        key: _formKey,
        child: GetBuilder<BookingController>(
          init: BookingController(),
          builder: (_) => ListView(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
            children: [
              _buildNameField(context),
              const SizedBox(height: 16.0),
              _buildInternationPhoneNo(context),
              const SizedBox(height: 16.0),
              _buildHouseNoAndStreelField(context),
              const SizedBox(height: 16.0),
              _buildBlockAndSectorField(context),
              const SizedBox(height: 16.0),
              _buildAreaField(context),
              const SizedBox(height: 16.0),
              _buildGallonField(context),
              const SizedBox(height: 16.0),
              CustomAsyncBtn(
                height: 42.0,
                btntxt: 'Add Booking',
                onPress: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                    await _bookingController.addBooking();
                  }
                },
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameField(BuildContext context) {
    return TextFormField(
      autofocus: true,
      onChanged: (value) {
        _bookingController.bookingFormModel.name = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return 'Required';
        }
      },
      keyboardType: TextInputType.text,
      decoration: buildTextFieldInputDecoration(context, labelTxt: 'Name'),
    );
  }

  Widget _buildInternationPhoneNo(BuildContext context) {
    return InternationalPhoneNumberInput(
      onInputChanged: (PhoneNumber number) async {
        var numberWithCode = '';
        if (number.isoCode == 'PK') {
          numberWithCode = number.phoneNumber!.padLeft(12, '0');
        } else {
          numberWithCode = number.phoneNumber ?? '';
        }
        _bookingController.bookingFormModel.phoneNo = numberWithCode;
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

  Widget _buildHouseNoAndStreelField(BuildContext context) {
    return TextFormField(
      autofocus: true,
      onChanged: (value) {
        _bookingController.bookingFormModel.houseNo = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return 'Required';
        }
      },
      keyboardType: TextInputType.text,
      decoration: buildTextFieldInputDecoration(context, labelTxt: 'House no/street'),
    );
  }

  Widget _buildBlockAndSectorField(BuildContext context) {
    return TextFormField(
      autofocus: true,
      onChanged: (value) {
        _bookingController.bookingFormModel.block = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return 'Required';
        }
      },
      keyboardType: TextInputType.text,
      decoration: buildTextFieldInputDecoration(context, labelTxt: 'Block/sector/phase'),
    );
  }

  Widget _buildAreaField(BuildContext context) {
    return TextFormField(
      autofocus: true,
      onChanged: (value) {
        _bookingController.bookingFormModel.area = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return 'Required';
        }
      },
      keyboardType: TextInputType.text,
      decoration: buildTextFieldInputDecoration(context, labelTxt: 'Area'),
    );
  }

  Widget _buildGallonField(BuildContext context) {
    return DropdownSearch<String>(
      mode: Mode.MENU,
      items: const ["1,000", "2,000", '3,000'],
      // ignore: deprecated_member_use
      label: "No. of gallons",
      onChanged: (value) {
        _bookingController.bookingFormModel.gallons = value;
      },
      validator: (value) {
        if (value == null) {
          return 'Required';
        }
      },
      // selectedItem: "1,000",
    );
  }
}
