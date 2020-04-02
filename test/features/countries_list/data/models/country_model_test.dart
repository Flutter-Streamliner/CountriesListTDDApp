import 'package:countries_ttd/features/countries_list/data/models/country_model.dart';
import 'package:countries_ttd/features/countries_list/domain/entities/country.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final testCountryModel = CountryModel(name: 'Afghanistan', capital: 'Kabul', code: '93');

  test('should be a subclass of Country entity', 
  () async {
    expect(testCountryModel, isA<Country>());
  });

  test('should return a valid model when the JSON number is an integer', 
  () async {
    final Map<String, dynamic> jsonMap = json.decode(fixture('country.json'));
    // act
    final result = CountryModel.fromJson(jsonMap);
    // assert
    expect(result, testCountryModel);
  });

  test('should return a JSON map containing the proper data', 
  () async {
    // act
    final result = testCountryModel.toJson();
    // assert
    final Map<String, dynamic> expectedJsonMap = json.decode(fixture('country.json'));
    expect(result, expectedJsonMap);
  });
}