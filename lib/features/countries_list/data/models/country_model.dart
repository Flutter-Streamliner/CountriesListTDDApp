import 'package:countries_ttd/features/countries_list/domain/entities/country.dart';
import 'package:flutter/foundation.dart';

class CountryModel extends Country {
  CountryModel({
    @required String name,
    @required String capital,
    @required String code,
  }) : super (name: name, capital: capital, code: code);

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      name: json['name'],
      capital: json['capital'],
      code: json['callingCodes'][0]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name' : name,
      'capital' : capital,
      'callingCodes': [code]
    };
  }

  @override
  String toString() => 'CountryModel{name = $name, capital = $capital, code = $code}';
}