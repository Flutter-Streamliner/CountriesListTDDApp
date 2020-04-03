import 'package:countries_ttd/core/error/exceptions.dart';
import 'package:countries_ttd/core/error/failures.dart';
import 'package:countries_ttd/core/network/network_info.dart';
import 'package:countries_ttd/features/countries_list/data/datasources/country_local_datasource.dart';
import 'package:countries_ttd/features/countries_list/data/datasources/country_remote_datasource.dart';
import 'package:countries_ttd/features/countries_list/domain/entities/country.dart';
import 'package:countries_ttd/features/countries_list/domain/repositories/country_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

class CountryRepositoryImpl extends CountryRepository {

  final CountryRemoteDataSource remoteDataSource;
  final CountryLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CountryRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo
  });

  @override
  Future<Either<Failure, List<Country>>> getCountries() async {
    if (await networkInfo.isConnected) {
      try {
        final countries = await remoteDataSource.getCountries();
        localDataSource.cacheCountries(countries);
        return Right(countries);
      } on ServerException  {
        return Left(ServerFailure());
      }
    } else {
      try {
        final cachedCountries = await localDataSource.getCacheCountries();
        return Right(cachedCountries);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

}