part of 'country_bloc.dart';

abstract class CountryState extends Equatable {
  const CountryState();
  @override
  List<Object> get props => [];
}

class CountryInitialState extends CountryState {}

class CountryLoadingState extends CountryState {}

class CountryLoadedState extends CountryState {
  final List<CountryModel> countries;

  CountryLoadedState({@required this.countries});

  @override
  List<Object> get props => [countries];
}

class CountryErrorState extends CountryState {
  final String message;

  CountryErrorState({@required this.message});

  @override
  List<Object> get props => [message];

}
