import 'package:countries_ttd/core/error/failures.dart';
import 'package:countries_ttd/features/countries_list/domain/entities/country.dart';
import 'package:dartz/dartz.dart';

abstract class CountryRepository {
  Future<Either<Failure, List<Country>>> getCountries();
}