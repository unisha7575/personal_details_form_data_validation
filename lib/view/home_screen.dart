import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:user_form_validation/constants/app_colors.dart';

import '../api_data_modal.dart';
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

  DateTime? selectedDate;
  late String dropdownValue;
  bool isLoading = true;
  TitleForDropDown? loadedData;
  List<String> salutationList = <String>[];
  bool isMale = true;

  InputDecoration inputDecoration = InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide:
      const BorderSide(color: AppColors.blueGrey, width: 1),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(color: AppColors.blueGrey,width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(color: AppColors.blueGrey, width: 1.0),
    ),
  );

  Future<void> data() async {
    http.Response res = await http.get(Uri.parse("https://api.probusinsurance.com/api/Motor/PrivateCar/Salutation?companyCode=DIGIT"));
    setState(() {
      isLoading = false;
      loadedData = titleForDopDownFromJson(res.body);
      if (loadedData != null) {
        dropdownValue = loadedData?.response[0].name ?? 'Mrs';
        for (int i = 0; i < loadedData!.response.length; i++) {
          salutationList.add(loadedData!.response[i].name);
        }
      }
      debugPrint("Line43 ${loadedData?.statusCode}");
      debugPrint("Line44 ${loadedData?.response[0].name}");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data();
  }

  Future<void> presentDatePicker() async {
    DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1950),
            builder: (context, child) {
              return Theme(
                  data: ThemeData().copyWith(
                      colorScheme: const ColorScheme.light(
                    primary: AppColors.primaryColor,
                  )),
                  child: child!);
            },
            lastDate: DateTime.now(),
    );
    if(pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        String formattedDate = DateFormat('dd MMM yyyy').format(pickedDate);
        dateOfBirth.text = formattedDate;
      });
    }
  }

  final _firstName = GlobalKey<FormState>();
  final _middleName = GlobalKey<FormState>();
  final _lastName = GlobalKey<FormState>();
  //final _dateOfBirth = GlobalKey<FormState>();
  final _other = GlobalKey<FormState>();
  final _occupation = GlobalKey<FormState>();


  bool isValidFormData() {
    return (_firstName.currentState?.validate()??false)
        && (_middleName.currentState?.validate()??false)
        && (_lastName.currentState?.validate()??false)
        &&  dateOfBirth.text.isNotEmpty
        && (_other.currentState?.validate()??false)
        && (_occupation.currentState?.validate()??false);
  }
  void _submit() {
    debugPrint("Line105:");
    // final isValid = (_firstName.currentState?.validate()??false)
    //     && (_middleName.currentState?.validate()??false)
    //     && (_lastName.currentState?.validate()??false)
    //     &&  dateOfBirth.text.isNotEmpty
    //     && (_other.currentState?.validate()??false)
    //     && (_occupation.currentState?.validate()??false);
    final isValid = isValidFormData();
    if (isValid) {
      debugPrint("Line113:");
      final PersonalDetailData personalDetailData = PersonalDetailData(
        salutation: dropdownValue??'',
        firstName: firstName.text??"",
        middleName: middleName.text??'',
        lastName: lastName.text??'',
        dateOfBirth: dateOfBirth.text??"",
        gender: isMale?'Male':'Female',
        other: other.text??'',
        occupation: occupation.text??'',
      );
      debugPrint(personalDetailData.firstName);
      debugPrint(personalDetailData.middleName);
      debugPrint(personalDetailData.lastName);
      debugPrint(personalDetailData.dateOfBirth);
      debugPrint(personalDetailData.gender);
      debugPrint(personalDetailData.other);
      debugPrint(personalDetailData.occupation);
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
                style: TextStyle(color: AppColors.white, fontSize: 24)),
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
                  child: ListView(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.blueGrey),
                            borderRadius: BorderRadius.circular(12.0)),
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
                                child: Text(value,style:const TextStyle(fontSize: 18,fontWeight: FontWeight.w400),),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Form(
                        key: _firstName,
                        child: TextFormField(
                          controller: firstName,
                          decoration: inputDecoration.copyWith(
                            labelText: 'First Name',
                            hintText: 'First Name'
                          ),
                          autocorrect: false,
                          textCapitalization: TextCapitalization.sentences,
                          validator: (value) {
                            if (value == null ) {
                              return 'Please enter some text';
                            } else if(value.trim().isEmpty){
                              return 'Please enter some text';
                            }
                            return null;
                          },

                        ),
                      ),
                      const SizedBox(
                        height: 18.0,
                      ),
                      Form(
                        key: _middleName,
                        child: TextFormField(
                          controller: middleName,
                          decoration: inputDecoration.copyWith(
                              labelText: 'Middle Name',
                              hintText: 'Middle Name'
                          ),
                          autocorrect: false,
                          textCapitalization: TextCapitalization.sentences,
                          validator: (value) {
                            if (value == null ) {
                              return 'Please enter some text';
                            } else if(value.trim().isEmpty){
                              return 'Please enter some text';
                            }
                            return null;
                          },

                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Form(
                        key: _lastName,
                        child: TextFormField(
                          controller: lastName,
                          decoration: inputDecoration.copyWith(
                              labelText: 'Last Name',
                              hintText: 'Last Name'
                          ),
                          autocorrect: false,
                          textCapitalization: TextCapitalization.sentences,
                          validator: (value) {
                            if (value == null ) {
                              return 'Please enter some text';
                            } else if(value.trim().isEmpty){
                              return 'Please enter some text';
                            }
                            return null;
                          },

                        ),
                      ),
                      const SizedBox(
                        height: 18,
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
                          const SizedBox(width: 20.0),
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
                        height: 18,
                      ),
                      TextFormField(
                        controller: dateOfBirth,
                        readOnly: true,
                        autofocus: false,
                        onTap: () async {
                          await presentDatePicker();
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: AppColors.blueGrey, width: 1.0),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide:
                                const BorderSide(color: AppColors.blueGrey,width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                                color: AppColors.blueGrey, width: 1.0),
                          ),
                         hintText: "Date of Birth",
                          labelText: "Date of Birth",
                          // labelStyle: const TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color: Colors.black),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: (selectedDate==null)?const SizedBox.shrink():Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    color: Colors.blueGrey[100]
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
                                    child: Text(
                                      '${DateTime.now().year - selectedDate!.year}' "${(DateTime.now().year - selectedDate!.year)>1 ? ' Years':' Year'}",style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13
                                    ),
                                    ),
                                  ),
                                ),
                              ),
                              const Icon(Icons.calendar_month,color: AppColors.primaryColor),
                              const SizedBox(width: 16.0)
                            ],
                          ),
                        ),
                        validator: (value) {
                          if(value==null){
                            return 'Please enter some text';
                          } else if(value.isEmpty){
                            return 'Please enter some text';
                          } else {
                            return null;
                          }
                      },
                        autocorrect: false,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Form(
                        key: _other,
                        child: TextFormField(
                          controller: other,
                          decoration: inputDecoration.copyWith(
                              labelText: 'Other',
                              hintText: 'Other'
                          ),
                          autocorrect: false,
                          textCapitalization: TextCapitalization.sentences,
                          validator: (value) {
                            if (value == null ) {
                              return 'Please enter some text';
                            } else if(value.trim().isEmpty){
                              return 'Please enter some text';
                            }
                            return null;
                          },

                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Form(
                        key: _occupation,
                        child: TextFormField(
                          controller: occupation,
                          decoration: inputDecoration.copyWith(
                              labelText: 'Occupation',
                              hintText: 'Occupation'
                          ),
                          autocorrect: false,
                          textCapitalization: TextCapitalization.sentences,
                          validator: (value) {
                            if (value == null ) {
                              return 'Please enter some text';
                            } else if(value.trim().isEmpty){
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          // onSaved: (value){
                          //   _enteredEmail = value!;
                          // },
                        ),
                      ),
                    ],
                  ),
                ),
          bottomNavigationBar: SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                  onPressed: () {
                    _submit();
                  },
                  style: ElevatedButton.styleFrom(

                    foregroundColor: AppColors.primaryColor,
                    backgroundColor: isValidFormData()?AppColors.primaryColor:AppColors.grey
                  ),
                  child: const Text(
                    "Next",
                    style: TextStyle(color: AppColors.white, fontSize: 20),
                  ))),
        ),
      ),
    );
  }

}
