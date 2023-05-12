// To parse this JSON data, do
//
//     final titleForDopDown = titleForDopDownFromJson(jsonString);

import 'dart:convert';

TitleForDopDown titleForDopDownFromJson(String str) => TitleForDopDown.fromJson(json.decode(str));

String titleForDopDownToJson(TitleForDopDown data) => json.encode(data.toJson());

class TitleForDopDown {
  dynamic error;
  bool isAuthenticated;
  dynamic message;
  List<Response> response;
  int statusCode;

  TitleForDopDown({
    this.error,
    required this.isAuthenticated,
    this.message,
    required this.response,
    required this.statusCode,
  });

  factory TitleForDopDown.fromJson(Map<String, dynamic> json) => TitleForDopDown(
    error: json["Error"],
    isAuthenticated: json["IsAuthenticated"],
    message: json["Message"],
    response: List<Response>.from(json["Response"].map((x) => Response.fromJson(x))),
    statusCode: json["StatusCode"],
  );

  Map<String, dynamic> toJson() => {
    "Error": error,
    "IsAuthenticated": isAuthenticated,
    "Message": message,
    "Response": List<dynamic>.from(response.map((x) => x.toJson())),
    "StatusCode": statusCode,
  };
}

class Response {
  String id;
  String name;

  Response({
    required this.id,
    required this.name,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    id: json["Id"],
    name: json["Name"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Name": name,
  };
}
