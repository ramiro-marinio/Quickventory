class Country {
  final String name;
  final String isoCode;
  final List<Map<String, String>> translations;
  Country({
    required this.name,
    required this.isoCode,
    required this.translations,
  });
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "isoCode": isoCode,
      "translations": translations,
    };
  }

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      isoCode:
          (json["tld"][0] as String).replaceAll(RegExp(r'.'), '').toUpperCase(),
      name: json["name"],
      translations: json["translations"],
    );
  }
}
