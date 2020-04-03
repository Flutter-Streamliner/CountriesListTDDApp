import 'dart:convert';

import 'package:countries_ttd/core/error/exceptions.dart';
import 'package:countries_ttd/features/countries_list/data/models/country_model.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CountryLocalDataSource {
  Future<List<CountryModel>> getCacheCountries();

  Future<void> cacheCountries(List<CountryModel> countryModel);
}

const String CACHED_COUNTRIES = 'CACHED_COUNTRIES';

class CountryLocalDataSourceImpl implements CountryLocalDataSource {

  final SharedPreferences sharedPreferences;

  CountryLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<void> cacheCountries(List<CountryModel> countries) {
    final jsonString = json.encode(countries);
    sharedPreferences.setString(CACHED_COUNTRIES, jsonString);
  }

  @override
  Future<List<CountryModel>> getCacheCountries() {
    final jsonString = sharedPreferences.getString(CACHED_COUNTRIES);
    if (jsonString == null) throw CacheException();
    final List<dynamic> parsedJson = json.decode(jsonString);
    final List<CountryModel> countries = parsedJson.map((country) => CountryModel.fromJson(country)).toList();
    return Future.value(countries);
  }

}