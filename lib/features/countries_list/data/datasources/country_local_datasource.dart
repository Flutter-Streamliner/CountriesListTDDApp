import 'package:countries_ttd/features/countries_list/data/models/country_model.dart';

abstract class CountryLocalDataSource {
  Future<CountryModel> getCacheCountry();

  Future<void> cacheCountry(CountryModel countryModel);
}