import 'dart:convert';

import 'package:countries_ttd/core/error/exceptions.dart';
import 'package:countries_ttd/features/countries_list/data/models/country_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

abstract class CountryRemoteDataSource {
  /// Calls the https://restcountries.eu/rest/v2/all endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<CountryModel>> getCountries();
}

class CountryRemoteDataSourceImpl implements CountryRemoteDataSource {

  final Client client;

  CountryRemoteDataSourceImpl({@required this.client});

  @override
  Future<List<CountryModel>> getCountries() async {
    final response = await client.get(
      'https://restcountries.eu/rest/v2/all',
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) throw ServerException();
    final List<dynamic> parsedJson = json.decode(response.body);
    final List<CountryModel> countries = parsedJson.map((country) => CountryModel.fromJson(country)).toList();
    return countries;
  }

}