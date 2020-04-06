import 'dart:convert';

import 'package:countries_ttd/core/error/exceptions.dart';
import 'package:countries_ttd/features/countries_list/data/datasources/country_local_datasource.dart';
import 'package:countries_ttd/features/countries_list/data/models/country_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  CountryLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp((){
    mockSharedPreferences = MockSharedPreferences();
    dataSource = CountryLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('getCountriesCached', (){
    final List<dynamic> parsedJson = json.decode(fixture('all_countries_response.json'));
    final List<CountryModel> countries = parsedJson.map((country) => CountryModel.fromJson(country)).toList();
    print('country_local_datasource_test countries $countries');

    test('should return Country from SharedPreferences when there is one in the cache', () async {
      // arrange
      when(mockSharedPreferences.getString(CACHED_COUNTRIES)).thenReturn(fixture('all_countries_response.json'));
      // act
      final result = await dataSource.getCacheCountries();
      // assert
      verify(mockSharedPreferences.getString(CACHED_COUNTRIES));
      expect(result, countries);
    });

    test('should throw a CacheException when there is not a cached value', () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      // act
      final call = dataSource.getCacheCountries;
      // assert
      expect(() => call(), throwsA(isInstanceOf<CacheException>()));
    });
  });

  group('cacheCountries', (){
    final List<dynamic> parsedJson = json.decode(fixture('all_countries_response.json'));
    final List<CountryModel> countries = parsedJson.map((country) => CountryModel.fromJson(country)).toList();

    test('should call SharedPreferences to cache the data', () async {
      // act 
      dataSource.cacheCountries(countries);
      // assert
      final expectedJsonString = json.encode(countries);
      print('expectedJsonString = $expectedJsonString');
      verify(mockSharedPreferences.setString(CACHED_COUNTRIES, expectedJsonString));
    });
  });
}