import 'package:countries_ttd/features/countries_list/data/models/country_model.dart';

abstract class CountryRemoteDataSource {
  /// Calls the https://restcountries.eu/rest/v2/all endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<CountryModel>> getCountries();
}