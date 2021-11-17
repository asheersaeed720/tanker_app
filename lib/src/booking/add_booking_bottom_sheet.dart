import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:tanker_app/src/booking/booking_controller.dart';
import 'package:tanker_app/utils/input_decoration.dart';
import 'package:tanker_app/widgets/custom_async_btn.dart';

createOrderBottomSheet(context) {
  final _formKey = GlobalKey<FormState>();

  String name = '';

  String phoneNo = '';

  String address = '';

  String tankerType = 'Small Tanker';

  bool isNumberValidate = false;

  showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(12),
        topLeft: Radius.circular(12),
      ),
    ),
    isScrollControlled: true,
    context: context,
    builder: (builder) => StatefulBuilder(
      builder: (BuildContext context, StateSetter customSetState) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 14.0),
          Container(
            width: 62.0,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 4.0, color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, top: 24, left: 16),
            child: Text(
              "Create a new booking",
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16.0,
              right: 16.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextFormField(
                    autofocus: true,
                    onChanged: (value) {
                      name = value;
                    },
                    // maxLength: 30,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Required';
                      }
                    },
                    keyboardType: TextInputType.text,
                    decoration: buildTextFieldInputDecoration(context, labelTxt: 'Name'),
                  ),
                  const SizedBox(height: 16.0),
                  InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) async {
                      var numberWithCode = '';
                      if (number.isoCode == 'PK') {
                        numberWithCode = number.phoneNumber!.padLeft(12, '0');
                      } else {
                        numberWithCode = number.phoneNumber ?? '';
                      }
                      phoneNo = numberWithCode;
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
                      customSetState(() => isNumberValidate = value);
                    },
                    initialValue: PhoneNumber(isoCode: 'PK'),
                    ignoreBlank: false,
                    maxLength: 14,
                    selectorTextStyle: const TextStyle(color: Colors.black),
                    formatInput: false,
                    inputBorder: const OutlineInputBorder(),
                    inputDecoration: buildTextFieldInputDecoration(context, labelTxt: 'Mobile no'),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    autofocus: true,
                    onChanged: (value) {
                      address = value;
                    },
                    maxLines: 4,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Required';
                      }
                    },
                    keyboardType: TextInputType.streetAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                          width: 1.0,
                        ),
                      ),
                      hintText: 'Address',
                      labelStyle: const TextStyle(color: Colors.black87),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  DropdownSearch<String>(
                    mode: Mode.MENU,
                    items: const ["Small Tanker", "Med Tanker", 'Large Tanker'],
                    // popupItemDisabled: (String s) => s.startsWith('I'),
                    onChanged: (value) {
                      tankerType = '$value';
                    },
                    selectedItem: "Small Tanker",
                  ),
                  const SizedBox(height: 16.0),
                  GetBuilder<BookingController>(
                      init: BookingController(),
                      builder: (bookingController) {
                        return CustomAsyncBtn(
                          height: 42.0,
                          btntxt: 'Add Booking',
                          onPress: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              FocusScopeNode currentFocus = FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              await bookingController.addBooking(
                                  name, phoneNo, tankerType, address);
                            }
                          },
                        );
                      }),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
