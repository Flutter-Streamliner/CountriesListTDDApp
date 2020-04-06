import 'dart:convert';

import 'package:countries_ttd/core/error/exceptions.dart';
import 'package:countries_ttd/features/countries_list/data/datasources/country_remote_datasource.dart';
import 'package:countries_ttd/features/countries_list/data/models/country_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  CountryRemoteDataSourceImpl remoteDataSource;
  MockHttpClient mockHttpClient;

  setUp((){
    mockHttpClient = MockHttpClient();
    remoteDataSource = CountryRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('getCountries', (){

    final List<dynamic> parsedJson = json.decode(fixture('all_countries_response.json'));
    final List<CountryModel> countries = parsedJson.map((country) => CountryModel.fromJson(country)).toList();
    
    test('should perform a GET request on a URL with "all" being endpoint and with application/json header', () async {
      // arrange
      when(mockHttpClient.get(any, headers: anyNamed("headers"))).thenAnswer((_) async =>
        http.Response(fixture('all_countries_response.json'), 200),
      );
      // act
      remoteDataSource.getCountries();
      // assert
      verify(mockHttpClient.get(
        'https://restcountries.eu/rest/v2/all',
        headers: {'Content-Type' : 'application/json'},
      ));
    });

    test('should return country list when the response code is 200', () async {
      // arrange 
      when(mockHttpClient.get(any, headers: anyNamed("headers"))).thenAnswer((_) async => 
        http.Response(fixture('all_countries_response.json'), 200),
      );
      // act
      final result = await remoteDataSource.getCountries();
      // assert
      expect(result, countries);
    });

    test('should throw a ServerException when the response code is 404 or other', () async {
      // arrange
      when(mockHttpClient.get(any, headers: anyNamed("headers"))).thenAnswer((_) async =>
        http.Response('Resource not found', 404)
      );
      // act
      final call = remoteDataSource.getCountries;
      // assert
      expect(() => call(), throwsA(isInstanceOf<ServerException>()));
    });
  });
}