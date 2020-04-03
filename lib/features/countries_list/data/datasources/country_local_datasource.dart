import 'package:countries_ttd/features/countries_list/data/models/country_model.dart';

abstract class CountryLocalDataSource {
  Future<List<CountryModel>> getCacheCountries();

  Future<void> cacheCountries(List<CountryModel> countryModel);
}