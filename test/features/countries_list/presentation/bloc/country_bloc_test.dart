import 'dart:convert';

import 'package:countries_ttd/core/error/failures.dart';
import 'package:countries_ttd/core/usecases/usecase.dart';
import 'package:countries_ttd/features/countries_list/data/models/country_model.dart';
import 'package:countries_ttd/features/countries_list/domain/usecases/get_all_countries.dart';
import 'package:countries_ttd/features/countries_list/presentation/bloc/country_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetAllCountriesUseCase extends Mock implements GetAllCountriesUseCase {}

void main() {
  CountryBloc bloc;
  MockGetAllCountriesUseCase mockUseCase;


  setUp((){
    mockUseCase = MockGetAllCountriesUseCase();
    bloc = CountryBloc(getAllCountriesUseCase: mockUseCase);
  });

  test('initialState should be empty', () async {
    expect(bloc.initialState, CountryInitialState());
  });

  group('GetAllCountriesEvent', (){
    final List<dynamic> parsedJson = json.decode(fixture('all_countries_response.json'));
    final List<CountryModel> countries = parsedJson.map((country) => CountryModel.fromJson(country)).toList();
    test('should get data from the concrete use case', () async {
      // arrange
      when(mockUseCase(NoParams())).thenAnswer((_) async => Right(countries));
      // act
      bloc.add(GetAllCountriesEvent());
      await untilCalled(mockUseCase(any));
      // assert
      verify(mockUseCase(NoParams()));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () async {
      // arrange
      when(mockUseCase(any)).thenAnswer((_) async => Right(countries));
      // assert later
      final expected = [CountryInitialState(), CountryLoadingState(), CountryLoadedState(countries: countries)];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
      // act
      bloc.add(GetAllCountriesEvent());

    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockUseCase(any)).thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        CountryInitialState(), 
        CountryLoadingState(), 
        CountryErrorState(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
      // act
      bloc.add(GetAllCountriesEvent());
    });

    test('should emit [Loading, Error] with a proper message for the error when getting data fails', () async {
      // arrange
      when(mockUseCase(any)).thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        CountryInitialState(),
        CountryLoadingState(),
        CountryErrorState(message: CACHE_FAILURE_MESSAGE)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));
      // act
      bloc.add(GetAllCountriesEvent());
    });
  });
}