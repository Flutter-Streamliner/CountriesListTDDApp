import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:countries_ttd/core/error/failures.dart';
import 'package:countries_ttd/core/usecases/usecase.dart';
import 'package:countries_ttd/features/countries_list/data/models/country_model.dart';
import 'package:countries_ttd/features/countries_list/domain/usecases/get_all_countries.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'country_event.dart';
part 'country_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class CountryBloc extends Bloc<CountryEvent, CountryState> {

  final GetAllCountriesUseCase getAllCountriesUseCase;

  @override
  CountryState get initialState => CountryInitialState();

  CountryBloc({@required this.getAllCountriesUseCase});

  @override
  Stream<CountryState> mapEventToState(
    CountryEvent event,
  ) async* {
    if (event is GetAllCountriesEvent) {
      yield CountryLoadingState();
      final result = await getAllCountriesUseCase(NoParams());
      yield result.fold(
        (failure) => CountryErrorState(message: failure is ServerFailure ? SERVER_FAILURE_MESSAGE : CACHE_FAILURE_MESSAGE), 
        (countries) => CountryLoadedState(countries: countries));
    }
  }
}
