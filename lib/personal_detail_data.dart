class PersonalDetailData {
  String salutation;
  String firstName;
  String middleName;
  String lastName;
  String gender;
  String dateOfBirth;
  String other;
  String occupation;

  PersonalDetailData(
      {
        required this.salutation,
        required this.firstName,
      required this.middleName,
      required this.lastName,
      required this.dateOfBirth,
      required this.gender,
      required this.other,
      required this.occupation});
}
