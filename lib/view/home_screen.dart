import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../modal.dart';
import '../personal_detail_data.dart';
import 'custom_radio_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController firstName = TextEditingController();
  TextEditingController middleName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController dateOfBirth = TextEditingController();
  TextEditingController other = TextEditingController();
  TextEditingController occupation = TextEditingController();
  TextEditingController salutationController = TextEditingController();
  late String dropdownValue;
  bool isLoading = true;
  TitleForDopDown? loadedData;
  List<String> salutationList = <String>[];
  bool isMale = true;

  Future<void> data() async {
    http.Response res = await http.get(Uri.parse(
        "https://api.probusinsurance.com/api/Motor/PrivateCar/Salutation?companyCode=DIGIT"));
    setState(() {
      isLoading = false;
      loadedData = titleForDopDownFromJson(res.body);
      if (loadedData != null) {
        dropdownValue = loadedData?.response[0].name ?? 'Mrs';
        for (int i = 0; i < loadedData!.response.length; i++) {
          salutationList.add(loadedData!.response[i].name);
        }
      }
      debugPrint("Line23 ${loadedData?.statusCode}");
      debugPrint("Line24 ${loadedData?.response[0].name}");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data();
  }

  DateTime? selectedDate;

  void presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1950),
            builder: (context, child) {
              return Theme(
                  data: ThemeData().copyWith(
                      colorScheme: ColorScheme.light(
                    primary: Color(0xff00B8CD),
                  )),
                  child: child!);
            },
            lastDate: DateTime.now())
        .then((pickedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    });
  }

  final _form = GlobalKey<FormState>();

  void _submit() {
    final isValid = _form.currentState!.validate();
    debugPrint("Line81: $isValid");
    if (isValid) {
      debugPrint("Line81:");
      final PersonalDetailData personalDetailData = PersonalDetailData(
        firstName: firstName.text,
        middleName: middleName.text,
        lastName: lastName.text,
        dateOfBirth: dateOfBirth.text,
        gender: salutationController.text,
        other: other.text,
        occupation: occupation.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: const Text("Personal Detail",
                style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          body: (isLoading)
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      CircularProgressIndicator(),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Please wait!..."),
                      )
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _form,
                    child: ListView(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueGrey),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 4.0, bottom: 4.0, left: 10.0),
                            child: DropdownButton<String>(
                              value: dropdownValue,
                              icon: const SizedBox.shrink(),
                              underline: const SizedBox.shrink(),
                              onChanged: (String? value) {
                                setState(() {
                                  dropdownValue = value!;
                                });
                              },
                              items: salutationList
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: firstName,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Colors.blueGrey, width: 15),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            // border: InputBorder.none,
                            labelText: 'First Name',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            value;
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: middleName,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  const BorderSide(color: Colors.blueGrey),
                            ),
                            labelText: 'Middle Name',
                          ),

                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          // onSaved: (value){
                          //   _enteredEmail = value!;
                          // },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: lastName,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.blueGrey),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  const BorderSide(color: Colors.blueGrey),
                            ),
                            labelText: 'Last Name',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          // onSaved: (value){
                          //   _enteredEmail = value!;
                          // },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomRadioButton(
                              label: 'Male',
                              isSelected: isMale,
                              onTap: () {
                                if (!isMale) {
                                  setState(() {
                                    isMale = true;
                                  });
                                }
                              },
                            ),
                            SizedBox(width: 20.0),
                            CustomRadioButton(
                              label: 'Female',
                              isSelected: !isMale,
                              onTap: () {
                                if (isMale) {
                                  setState(() {
                                    isMale = false;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () {
                            debugPrint("Line262: ");
                            presentDatePicker();
                          },
                          child: Ink(
                            child: TextFormField(
                              controller: dateOfBirth,
                              enabled: false,
                              // onTap: () {
                              //   debugPrint("Line262: ");
                              //   presentDatePicker();
                              // },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.blueGrey),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide:
                                      const BorderSide(color: Colors.blueGrey),
                                ),
                                labelText: selectedDate != null
                                    ? selectedDate.toString().split(" ").first
                                    : "Date Of Birth",
                                suffixIcon: const Icon(Icons.calendar_month),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.sentences,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: other,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  const BorderSide(color: Colors.blueGrey),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  const BorderSide(color: Colors.blueGrey),
                            ),
                            labelText: 'Other',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          // onSaved: (value){
                          //   _enteredEmail = value!;
                          // },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: occupation,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  const BorderSide(color: Colors.blueGrey),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  const BorderSide(color: Colors.blueGrey),
                            ),
                            labelText: 'Occupation',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          // onSaved: (value){
                          //   _enteredEmail = value!;
                          // },
                        ),
                      ],
                    ),
                  ),
                ),
          bottomNavigationBar: SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                  onPressed: () {
                    _submit();
                  },
                  child: Text(
                    "Next",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ))),
        ),
      ),
    );
  }
}
