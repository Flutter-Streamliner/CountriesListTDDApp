import 'package:countries_ttd/core/error/exceptions.dart';
import 'package:countries_ttd/core/error/failures.dart';
import 'package:countries_ttd/core/platform/network_info.dart';
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
    networkInfo.isConnected;
    try {
      final result = await remoteDataSource.getCountries();
      localDataSource.cacheCountry(result[0]);
      return Right(result);
    } on ServerException  {
      return Left(ServerFailure());
    }
  }

}