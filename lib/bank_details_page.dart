import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class BankDetailsPage extends StatefulWidget {
  const BankDetailsPage({super.key});

  @override
  State<BankDetailsPage> createState() => _BankDetailsPageState();
}

class _BankDetailsPageState extends State<BankDetailsPage> {
  final TextEditingController panController = TextEditingController();

  final TextEditingController birthdateController = TextEditingController();

  ValueNotifier<bool> isPanError = ValueNotifier<bool>(false);
  ValueNotifier<bool> isbirthdateError = ValueNotifier<bool>(false);
  ValueNotifier<bool> isButtonDisabled = ValueNotifier<bool>(true);

  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'S.',
                    style: TextStyle(
                        color: Colors.orange,
                        fontSize: 36,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text("First of the few steps to take you up a bank account"),
                  SizedBox(
                    height: 20,
                  ),
                  Text('PanNumber'),
                  TextFormField(
                      controller: panController,
                      onChanged: (value) {
                        panController
                          ..text = value.toUpperCase()
                          ..selection = TextSelection.fromPosition(TextPosition(
                              offset: panController.text.length,
                              affinity: TextAffinity.upstream));
                        isButtonValid();
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                        // FilteringTextInputFormatter.allow(RegExp("[A-Z0-9]")),
                      ]),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Birthdate'),
                  TextFormField(
                    controller: birthdateController,
                    keyboardType: TextInputType.none,
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      _showDate();
                    },
                  ),
                  Spacer(),
                  ValueListenableBuilder(
                    valueListenable: isButtonDisabled,
                    builder: (context, value, child) {
                      return ElevatedButton(
                          onPressed: () async {
                            if (!isButtonDisabled.value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Container(
                                          height: 50.0,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              50,
                                          color: Colors.black,
                                          // margin: EdgeInsets.all(24.0),
                                          child: Center(
                                            child: Text(
                                              'Details Submitted Successfully',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ))));
                              await Future.delayed(Duration(seconds: 3));
                              SystemChannels.platform
                                  .invokeMethod('SystemNavigator.pop');
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: value
                                ? MaterialStateProperty.all(Colors.grey)
                                : MaterialStateProperty.all(Colors.purple),
                          ),
                          child: Center(
                            child: Text('Next'),
                          ));
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        child: Text(
                          'I dont have a PAN',
                          style: TextStyle(color: Colors.purple),
                        ),
                        onTap: () {
                          SystemChannels.platform
                              .invokeMethod('SystemNavigator.pop');
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool isValidPanCardNo() {
    final pattern = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
    return pattern.hasMatch(panController.text);
  }

  isButtonValid() {
    if (panController.text.isEmpty || birthdateController.text.isEmpty) {
      isButtonDisabled.value = true;
      return;
    }

    if (isValidPanCardNo() && birthdateController.text.isNotEmpty) {
      isButtonDisabled.value = false;
    }
  }

  _showDate() async {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1920),
        lastDate: DateTime.now(),
        builder: (context, picker) {
          return picker!;
        }).then((selectedDate) {
      if (selectedDate != null) {
        birthdateController
          ..text = DateFormat.yMMMd().format(_selectedDate)
          ..selection = TextSelection.fromPosition(TextPosition(
              offset: birthdateController.text.length,
              affinity: TextAffinity.upstream));
        isButtonValid();
      }
    });
  }
}
