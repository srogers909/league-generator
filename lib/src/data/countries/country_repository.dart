import '../../models/country.dart';

/// Repository for country data used in soccer data generation
class CountryRepository {
  static final Map<String, Country> _countries = {
    'GB': _createEngland(),
    'ES': _createSpain(),
    'DE': _createGermany(),
    'IT': _createItaly(),
    'FR': _createFrance(),
    'BR': _createBrazil(),
    'AR': _createArgentina(),
    'NL': _createNetherlands(),
    'PT': _createPortugal(),
    'US': _createUnitedStates(),
  };

  /// Get all available countries
  static List<Country> getAllCountries() {
    return _countries.values.toList()..sort((a, b) => a.name.compareTo(b.name));
  }

  /// Get country by code
  static Country? getCountryByCode(String code) {
    return _countries[code.toUpperCase()];
  }

  /// Get countries with strong soccer culture
  static List<Country> getStrongSoccerCountries() {
    return _countries.values
        .where((country) => country.strongSoccerCulture)
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  /// Get countries by language
  static List<Country> getCountriesByLanguage(String language) {
    return _countries.values
        .where((country) => country.language == language)
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  // Private factory methods for creating country data

  static Country _createEngland() {
    return const Country(
      code: 'GB',
      name: 'England',
      nativeName: 'England',
      language: 'en',
      currency: 'GBP',
      strongSoccerCulture: true,
      leagueStructure: LeagueStructure(
        topDivisionTeams: 20,
        professionalDivisions: 4,
        hasPlayoffs: true,
        hasRelegation: true,
        seasonLength: 38,
        seasonStartMonth: 8,
      ),
      namingCulture: NamingCulture(
        teamPrefixes: ['FC', 'AFC', 'Athletic'],
        teamSuffixes: ['United', 'City', 'Town', 'Rovers', 'Wanderers', 'County', 'Borough'],
        stadiumPatterns: ['{team} Stadium', '{city} Stadium', 'Old {landmark}', '{sponsor} Stadium'],
        includesCityInTeamName: true,
        prefersTraditionalNames: true,
        titlePrefixes: ['Mr.', 'Mrs.', 'Sir', 'Lord'],
      ),
    );
  }

  static Country _createSpain() {
    return const Country(
      code: 'ES',
      name: 'Spain',
      nativeName: 'España',
      language: 'es',
      currency: 'EUR',
      strongSoccerCulture: true,
      leagueStructure: LeagueStructure(
        topDivisionTeams: 20,
        professionalDivisions: 3,
        hasPlayoffs: false,
        hasRelegation: true,
        seasonLength: 38,
        seasonStartMonth: 8,
      ),
      namingCulture: NamingCulture(
        teamPrefixes: ['Real', 'Athletic', 'Club', 'CF', 'CD', 'SD'],
        teamSuffixes: ['FC', 'CF', 'CD', 'SD', 'Club de Fútbol'],
        stadiumPatterns: ['Estadio {name}', 'Campo de {name}', '{sponsor} Stadium'],
        includesCityInTeamName: true,
        prefersTraditionalNames: true,
        titlePrefixes: ['Sr.', 'Sra.', 'Don', 'Doña'],
      ),
    );
  }

  static Country _createGermany() {
    return const Country(
      code: 'DE',
      name: 'Germany',
      nativeName: 'Deutschland',
      language: 'de',
      currency: 'EUR',
      strongSoccerCulture: true,
      leagueStructure: LeagueStructure(
        topDivisionTeams: 18,
        professionalDivisions: 3,
        hasPlayoffs: true,
        hasRelegation: true,
        seasonLength: 34,
        seasonStartMonth: 8,
      ),
      namingCulture: NamingCulture(
        teamPrefixes: ['FC', 'SV', 'VfL', 'VfB', 'Borussia', 'Eintracht', 'Bayern'],
        teamSuffixes: ['04', '05', '09', 'München', 'Dortmund'],
        stadiumPatterns: ['{name}-Arena', '{name} Stadion', '{sponsor} Arena'],
        includesCityInTeamName: true,
        prefersTraditionalNames: true,
        titlePrefixes: ['Herr', 'Frau', 'Dr.'],
      ),
    );
  }

  static Country _createItaly() {
    return const Country(
      code: 'IT',
      name: 'Italy',
      nativeName: 'Italia',
      language: 'it',
      currency: 'EUR',
      strongSoccerCulture: true,
      leagueStructure: LeagueStructure(
        topDivisionTeams: 20,
        professionalDivisions: 3,
        hasPlayoffs: true,
        hasRelegation: true,
        seasonLength: 38,
        seasonStartMonth: 8,
      ),
      namingCulture: NamingCulture(
        teamPrefixes: ['AC', 'AS', 'FC', 'SS', 'US', 'Inter'],
        teamSuffixes: ['Calcio', 'FC', '1907', '1909', '1900'],
        stadiumPatterns: ['Stadio {name}', '{name} Stadium', 'Arena {name}'],
        includesCityInTeamName: true,
        prefersTraditionalNames: true,
        titlePrefixes: ['Sig.', 'Sig.ra', 'Dott.'],
      ),
    );
  }

  static Country _createFrance() {
    return const Country(
      code: 'FR',
      name: 'France',
      nativeName: 'France',
      language: 'fr',
      currency: 'EUR',
      strongSoccerCulture: true,
      leagueStructure: LeagueStructure(
        topDivisionTeams: 20,
        professionalDivisions: 3,
        hasPlayoffs: false,
        hasRelegation: true,
        seasonLength: 38,
        seasonStartMonth: 8,
      ),
      namingCulture: NamingCulture(
        teamPrefixes: ['AS', 'FC', 'RC', 'OGC', 'LOSC', 'Olympique'],
        teamSuffixes: ['FC', 'SC', 'AC'],
        stadiumPatterns: ['Stade {name}', 'Stadium {name}', 'Parc {name}'],
        includesCityInTeamName: true,
        prefersTraditionalNames: true,
        titlePrefixes: ['M.', 'Mme', 'Dr.'],
      ),
    );
  }

  static Country _createBrazil() {
    return const Country(
      code: 'BR',
      name: 'Brazil',
      nativeName: 'Brasil',
      language: 'pt',
      currency: 'BRL',
      strongSoccerCulture: true,
      leagueStructure: LeagueStructure(
        topDivisionTeams: 20,
        professionalDivisions: 4,
        hasPlayoffs: true,
        hasRelegation: true,
        seasonLength: 38,
        seasonStartMonth: 4,
      ),
      namingCulture: NamingCulture(
        teamPrefixes: ['Sport Club', 'Clube', 'Associação', 'Grêmio', 'Santos'],
        teamSuffixes: ['FC', 'EC', 'AC', 'SC'],
        stadiumPatterns: ['Estádio {name}', 'Arena {name}', 'Estádio {landmark}'],
        includesCityInTeamName: true,
        prefersTraditionalNames: true,
        titlePrefixes: ['Sr.', 'Sra.', 'Dr.'],
      ),
    );
  }

  static Country _createArgentina() {
    return const Country(
      code: 'AR',
      name: 'Argentina',
      nativeName: 'Argentina',
      language: 'es',
      currency: 'ARS',
      strongSoccerCulture: true,
      leagueStructure: LeagueStructure(
        topDivisionTeams: 28,
        professionalDivisions: 3,
        hasPlayoffs: true,
        hasRelegation: true,
        seasonLength: 40,
        seasonStartMonth: 2,
      ),
      namingCulture: NamingCulture(
        teamPrefixes: ['Club Atlético', 'Club', 'Asociación Atlética', 'Racing'],
        teamSuffixes: ['Juniors', 'Unidos', 'Central'],
        stadiumPatterns: ['Estadio {name}', 'La Bombonera', 'El Monumental'],
        includesCityInTeamName: true,
        prefersTraditionalNames: true,
        titlePrefixes: ['Sr.', 'Sra.', 'Dr.'],
      ),
    );
  }

  static Country _createNetherlands() {
    return const Country(
      code: 'NL',
      name: 'Netherlands',
      nativeName: 'Nederland',
      language: 'nl',
      currency: 'EUR',
      strongSoccerCulture: true,
      leagueStructure: LeagueStructure(
        topDivisionTeams: 18,
        professionalDivisions: 2,
        hasPlayoffs: true,
        hasRelegation: true,
        seasonLength: 34,
        seasonStartMonth: 8,
      ),
      namingCulture: NamingCulture(
        teamPrefixes: ['AFC', 'FC', 'PSV', 'AZ', 'SC'],
        teamSuffixes: ['\'20', '\'26', 'United'],
        stadiumPatterns: ['{name} Stadion', '{sponsor} Arena', '{name} Stadium'],
        includesCityInTeamName: true,
        prefersTraditionalNames: true,
        titlePrefixes: ['Dhr.', 'Mevr.', 'Dr.'],
      ),
    );
  }

  static Country _createPortugal() {
    return const Country(
      code: 'PT',
      name: 'Portugal',
      nativeName: 'Portugal',
      language: 'pt',
      currency: 'EUR',
      strongSoccerCulture: true,
      leagueStructure: LeagueStructure(
        topDivisionTeams: 18,
        professionalDivisions: 3,
        hasPlayoffs: false,
        hasRelegation: true,
        seasonLength: 34,
        seasonStartMonth: 8,
      ),
      namingCulture: NamingCulture(
        teamPrefixes: ['FC', 'SC', 'CD', 'CF', 'Sporting'],
        teamSuffixes: ['FC', 'SC', 'CD'],
        stadiumPatterns: ['Estádio {name}', 'Estádio do {landmark}', '{sponsor} Stadium'],
        includesCityInTeamName: true,
        prefersTraditionalNames: true,
        titlePrefixes: ['Sr.', 'Sra.', 'Dr.'],
      ),
    );
  }

  static Country _createUnitedStates() {
    return const Country(
      code: 'US',
      name: 'United States',
      nativeName: 'United States',
      language: 'en',
      currency: 'USD',
      strongSoccerCulture: false,
      leagueStructure: LeagueStructure(
        topDivisionTeams: 29,
        professionalDivisions: 2,
        hasPlayoffs: true,
        hasRelegation: false,
        seasonLength: 34,
        seasonStartMonth: 2,
      ),
      namingCulture: NamingCulture(
        teamPrefixes: ['FC', 'SC', 'Real'],
        teamSuffixes: ['FC', 'SC', 'United', 'City'],
        stadiumPatterns: ['{sponsor} Stadium', '{city} Stadium', '{landmark} Field'],
        includesCityInTeamName: true,
        prefersTraditionalNames: false,
        titlePrefixes: ['Mr.', 'Mrs.', 'Dr.'],
      ),
    );
  }
}
