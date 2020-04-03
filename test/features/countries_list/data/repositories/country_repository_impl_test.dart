import 'package:countries_ttd/core/error/exceptions.dart';
import 'package:countries_ttd/core/error/failures.dart';
import 'package:countries_ttd/core/network/network_info.dart';
import 'package:countries_ttd/features/countries_list/data/datasources/country_local_datasource.dart';
import 'package:countries_ttd/features/countries_list/data/datasources/country_remote_datasource.dart';
import 'package:countries_ttd/features/countries_list/data/models/country_model.dart';
import 'package:countries_ttd/features/countries_list/data/repositories/country_repository_impl.dart';
import 'package:countries_ttd/features/countries_list/domain/entities/country.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock implements CountryRemoteDataSource {}

class MockLocalDataSource extends Mock implements CountryLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  CountryRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp((){
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = CountryRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo
    );
  });

  final testCountryModel = CountryModel(name: 'Afghanistan', capital: 'Kabul', code: '93');
  List<CountryModel> countries = List();
  countries.add(testCountryModel);

  group('device is online', () {
    setUp((){
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });
    test('should check if the device is online', 
    () async {
      // arrange
      when(mockRemoteDataSource.getCountries()).thenAnswer((_) async => countries);
      // act
      repository.getCountries();
      // assert
      verify(mockNetworkInfo.isConnected);
    });
    
    test('should return remote data when the call to remote data source is successful', () async {
      when(mockRemoteDataSource.getCountries()).thenAnswer((_) async => countries);
      // act
      final result = await repository.getCountries();
      // assert
      verify(mockRemoteDataSource.getCountries());
      expect(result, Right(countries));
    });

    test('should cache the data locally when the call to remote data source is successful', () async {
      // arrange 
      when(mockRemoteDataSource.getCountries()).thenAnswer((_) async => countries);
      // act
      await repository.getCountries();
      // assert
      verify(mockRemoteDataSource.getCountries());
      verify(mockLocalDataSource.cacheCountries(countries));
    });

    test('should return server failure when the call to remote data source is unsuccessful', () async {
      // arrange
      when(mockRemoteDataSource.getCountries()).thenThrow(ServerException());
      // act
      final result = await repository.getCountries();
      // assert
      expect(result, Left(ServerFailure()));
      verifyZeroInteractions(mockLocalDataSource);
    });
  });

  group('device offline', () {
    setUp((){
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });
    
    test('should return last locally cached data when the cache data is present', 
    () async {
      // arrange
      when(mockLocalDataSource.getCacheCountries()).thenAnswer((_) async => countries);
      // act
      final result = await repository.getCountries();
      // assert
      verifyZeroInteractions(mockRemoteDataSource);
      verify(mockLocalDataSource.getCacheCountries());
      expect(result, Right(countries));
    });

    test('should return CacheFailure when there is no cache data present', 
    () async {
      // arrange
      when(mockLocalDataSource.getCacheCountries()).thenThrow(CacheException());
      // act
      final result = await repository.getCountries();
      // assert
      verifyZeroInteractions(mockRemoteDataSource);
      verify(mockLocalDataSource.getCacheCountries());
      expect(result, Left(CacheFailure()));
    });
  });
}