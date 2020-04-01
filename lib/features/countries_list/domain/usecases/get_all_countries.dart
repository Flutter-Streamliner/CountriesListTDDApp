import 'package:countries_ttd/core/error/failures.dart';
import 'package:countries_ttd/core/usecases/usecase.dart';
import 'package:countries_ttd/features/countries_list/domain/entities/country.dart';
import 'package:countries_ttd/features/countries_list/domain/repositories/country_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

class GetAllCountriesUseCase extends UseCase<List<Country>, NoParams>{
  final CountryRepository repository;

  GetAllCountriesUseCase({@required this.repository});

  Future<Either<Failure, List<Country>>> call(NoParams noParams) async => await repository.getCountries();
}