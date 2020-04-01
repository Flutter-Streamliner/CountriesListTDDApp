
import 'package:countries_ttd/core/usecases/usecase.dart';
import 'package:countries_ttd/features/countries_list/domain/entities/country.dart';
import 'package:countries_ttd/features/countries_list/domain/repositories/country_repository.dart';
import 'package:countries_ttd/features/countries_list/domain/usecases/get_all_countries.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockCountryRepository extends Mock implements CountryRepository {}

void main() {
  GetAllCountriesUseCase getAllCountriesUseCase;
  MockCountryRepository mockCountryRepository;

  setUp(() {
    mockCountryRepository = MockCountryRepository();
    getAllCountriesUseCase = GetAllCountriesUseCase(repository: mockCountryRepository);
  });

  Country testCountry = Country(name: 'Afghanistan', capital: 'Kabul', code: '93');
  List<Country> testCountriesList = List();
  testCountriesList.add(testCountry);

  test('should get the list of countries from the repository',
  () async {
    when(mockCountryRepository.getCountries())
      .thenAnswer((_) async => Right(testCountriesList));

    // The "act" phase of the test. Call the not-yet-existent method.
    final result = await getAllCountriesUseCase(NoParams());

    // UseCase should simply return whatever was returned from the Repository
    expect(result, Right(testCountriesList));

    // Verify that the method has been called on the Repository
    verify(mockCountryRepository.getCountries());
    // Only the above method should be called and nothing more.
    verifyNoMoreInteractions(mockCountryRepository);
  });
}