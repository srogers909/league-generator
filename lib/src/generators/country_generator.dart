import '../models/country.dart';
import '../data/countries/country_repository.dart';

/// Generator for creating country-based data configurations
class CountryGenerator {
  
  /// Gets all available countries for generation
  static List<Country> getAllCountries() {
    return CountryRepository.getAllCountries();
  }

  /// Gets countries with strong soccer culture for better generation results
  static List<Country> getStrongSoccerCountries() {
    return CountryRepository.getStrongSoccerCountries();
  }

  /// Gets a country by its code
  static Country? getCountryByCode(String code) {
    return CountryRepository.getCountryByCode(code);
  }

  /// Gets countries by language for localization
  static List<Country> getCountriesByLanguage(String language) {
    return CountryRepository.getCountriesByLanguage(language);
  }

  /// Validates if a country is suitable for soccer data generation
  static bool isCountrySuitableForGeneration(Country country) {
    // Basic validation - could be expanded with more criteria
    return country.leagueStructure.topDivisionTeams >= 10 &&
           country.leagueStructure.professionalDivisions >= 1 &&
           country.namingCulture.teamPrefixes.isNotEmpty;
  }

  /// Gets recommended countries for new users
  static List<Country> getRecommendedCountries() {
    final strongSoccerCountries = getStrongSoccerCountries();
    
    // Return top soccer nations that are well-suited for generation
    return strongSoccerCountries.where((country) => 
      isCountrySuitableForGeneration(country)
    ).take(5).toList();
  }
}
