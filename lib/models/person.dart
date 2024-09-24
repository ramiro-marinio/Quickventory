import 'dart:convert';

Person personFromJson(String str) => Person.fromJson(json.decode(str));

String personToJson(Person data) => json.encode(data.toJson());

class Person {
  String id;
  String fullName;
  String? country;
  String? image;
  String? address;
  String? email;
  String? phone;

  Person({
    required this.id,
    required this.fullName,
    required this.country,
    required this.image,
    required this.address,
    required this.email,
    required this.phone,
  });

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        id: json["personId"],
        fullName: json["fullName"],
        country: json["country"],
        image: json["image"],
        address: json["personAddress"],
        email: json["email"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() {
    return {
      "personId": id,
      "fullName": fullName,
      "country": country,
      "image": image,
      "personAddress": address,
      "email": email,
      "phone": phone,
    };
  }
}
