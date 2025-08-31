import 'dart:math';
import 'package:tactics_fc_engine/soccer_engine.dart';
import '../models/country.dart';
import '../models/generation_config.dart';
import '../utils/generation_utils.dart';
import '../utils/name_utils.dart';

/// Generator for creating soccer teams with realistic characteristics
class TeamGenerator {
  final Random _random;
  final GenerationUtils _utils;
  final NameUtils _nameUtils;

  TeamGenerator({int? seed}) 
      : _random = Random(seed),
        _utils = GenerationUtils(seed: seed),
        _nameUtils = NameUtils(seed: seed);

  /// Generates a list of teams for a given country and configuration
  List<Team> generateTeams({
    required Country country,
    required TeamConfig config,
    required int count,
    List<String>? cityNames,
  }) {
    final teams = <Team>[];
    final usedNames = <String>{};
    final cities = cityNames ?? _getDefaultCityNames(country);

    for (int i = 0; i < count; i++) {
      final team = _generateSingleTeam(
        country: country,
        config: config,
        usedNames: usedNames,
        cities: cities,
      );
      teams.add(team);
      usedNames.add(team.name);
    }

    return teams;
  }

  /// Generates a single team with realistic characteristics
  Team _generateSingleTeam({
    required Country country,
    required TeamConfig config,
    required Set<String> usedNames,
    required List<String> cities,
  }) {
    // Generate team name
    final teamName = _generateTeamName(
      country: country,
      config: config,
      usedNames: usedNames,
      cities: cities,
    );

    // Generate team characteristics
    final reputation = _generateReputation(config);
    final city = cities[_random.nextInt(cities.length)];
    final foundedYear = _generateFoundedYear();
    final colors = _generateTeamColors();

    return Team(
      id: _utils.generateId(),
      name: teamName,
      city: city,
      foundedYear: foundedYear,
      // Stadium and players will be added separately
      // The team starts with empty squad - players added later
    );
  }

  /// Generates a realistic team name based on country culture
  String _generateTeamName({
    required Country country,
    required TeamConfig config,
    required Set<String> usedNames,
    required List<String> cities,
  }) {
    final culture = country.namingCulture;
    String teamName;
    int attempts = 0;
    const maxAttempts = 50;

    do {
      if (config.useTraditionalNames && culture.prefersTraditionalNames) {
        teamName = _generateTraditionalName(culture, cities);
      } else {
        teamName = _generateModernName(culture, cities);
      }
      attempts++;
    } while (usedNames.contains(teamName) && attempts < maxAttempts);

    // If we couldn't generate a unique name, append a number
    if (usedNames.contains(teamName)) {
      int suffix = 2;
      String originalName = teamName;
      do {
        teamName = '$originalName $suffix';
        suffix++;
      } while (usedNames.contains(teamName));
    }

    return teamName;
  }

  /// Generates a traditional team name following cultural patterns
  String _generateTraditionalName(NamingCulture culture, List<String> cities) {
    final city = cities[_random.nextInt(cities.length)];
    
    // Decide name structure
    final usePrefix = _random.nextDouble() < 0.4;
    final useSuffix = _random.nextDouble() < 0.6;
    final includeCity = culture.includesCityInTeamName && _random.nextDouble() < 0.8;

    String name = '';

    // Add prefix
    if (usePrefix && culture.teamPrefixes.isNotEmpty) {
      name += culture.teamPrefixes[_random.nextInt(culture.teamPrefixes.length)];
      if (includeCity) name += ' ';
    }

    // Add city name
    if (includeCity) {
      name += city;
    }

    // Add suffix
    if (useSuffix && culture.teamSuffixes.isNotEmpty) {
      if (name.isNotEmpty) name += ' ';
      name += culture.teamSuffixes[_random.nextInt(culture.teamSuffixes.length)];
    }

    // Fallback if name is empty
    if (name.isEmpty) {
      name = '$city FC';
    }

    return name.trim();
  }

  /// Generates a modern team name with corporate influence
  String _generateModernName(NamingCulture culture, List<String> cities) {
    final city = cities[_random.nextInt(cities.length)];
    
    // Modern names often use simpler patterns
    final patterns = [
      '$city FC',
      '$city United',
      '$city City',
      'FC $city',
    ];

    // Add some culture-specific patterns
    if (culture.teamPrefixes.isNotEmpty) {
      final prefix = culture.teamPrefixes[_random.nextInt(culture.teamPrefixes.length)];
      patterns.add('$prefix $city');
    }

    return patterns[_random.nextInt(patterns.length)];
  }

  /// Generates team reputation based on configuration
  int _generateReputation(TeamConfig config) {
    // Use normal distribution centered around middle of range
    final mean = (config.minReputation + config.maxReputation) / 2;
    final stdDev = (config.maxReputation - config.minReputation) / 4;
    
    final reputation = _utils.generateNormalInt(
      mean: mean.toDouble(),
      standardDeviation: stdDev,
      min: config.minReputation,
      max: config.maxReputation,
    );

    return reputation;
  }

  /// Generates a realistic founded year for the team
  int _generateFoundedYear() {
    // Most teams founded between 1880-2020, with peak around 1900-1950
    final currentYear = DateTime.now().year;
    final minYear = 1880;
    final maxYear = currentYear - 5; // Teams need some history
    
    // Weight towards earlier years (more traditional clubs)
    final yearRange = maxYear - minYear;
    final weightedYear = minYear + (yearRange * _random.nextDouble() * _random.nextDouble()).round();
    
    return weightedYear;
  }

  /// Generates team colors
  Map<String, String> _generateTeamColors() {
    final colorOptions = [
      {'primary': 'Red', 'secondary': 'White'},
      {'primary': 'Blue', 'secondary': 'White'},
      {'primary': 'White', 'secondary': 'Blue'},
      {'primary': 'Green', 'secondary': 'White'},
      {'primary': 'Yellow', 'secondary': 'Blue'},
      {'primary': 'Black', 'secondary': 'White'},
      {'primary': 'Purple', 'secondary': 'White'},
      {'primary': 'Orange', 'secondary': 'Black'},
    ];

    return colorOptions[_random.nextInt(colorOptions.length)];
  }

  /// Gets default city names for a country
  List<String> _getDefaultCityNames(Country country) {
    // This would ideally come from a more comprehensive database
    switch (country.code) {
      case 'GB':
        return ['London', 'Manchester', 'Liverpool', 'Birmingham', 'Leeds', 'Sheffield', 'Bristol', 'Newcastle', 'Brighton', 'Southampton'];
      case 'ES':
        return ['Madrid', 'Barcelona', 'Sevilla', 'Valencia', 'Bilbao', 'Málaga', 'Zaragoza', 'Las Palmas', 'Granada', 'Getafe'];
      case 'DE':
        return ['Berlin', 'München', 'Hamburg', 'Köln', 'Frankfurt', 'Stuttgart', 'Düsseldorf', 'Dortmund', 'Essen', 'Bremen'];
      case 'IT':
        return ['Roma', 'Milano', 'Napoli', 'Torino', 'Palermo', 'Genova', 'Bologna', 'Firenze', 'Bari', 'Catania'];
      case 'FR':
        return ['Paris', 'Marseille', 'Lyon', 'Toulouse', 'Nice', 'Nantes', 'Montpellier', 'Strasbourg', 'Bordeaux', 'Lille'];
      case 'BR':
        return ['São Paulo', 'Rio de Janeiro', 'Salvador', 'Brasília', 'Fortaleza', 'Belo Horizonte', 'Manaus', 'Curitiba', 'Recife', 'Porto Alegre'];
      case 'AR':
        return ['Buenos Aires', 'Córdoba', 'Rosario', 'Mendoza', 'La Plata', 'San Miguel', 'Salta', 'Santa Fe', 'Mar del Plata', 'San Juan'];
      case 'NL':
        return ['Amsterdam', 'Rotterdam', 'Den Haag', 'Utrecht', 'Eindhoven', 'Tilburg', 'Groningen', 'Almere', 'Breda', 'Nijmegen'];
      case 'PT':
        return ['Lisboa', 'Porto', 'Vila Nova de Gaia', 'Amadora', 'Braga', 'Setúbal', 'Coimbra', 'Funchal', 'Almada', 'Agualva-Cacém'];
      case 'US':
        return ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix', 'Philadelphia', 'San Antonio', 'San Diego', 'Dallas', 'San Jose'];
      default:
        return ['Capital City', 'Port City', 'Mountain View', 'River City', 'Central City', 'East City', 'West City', 'North City', 'South City', 'Old Town'];
    }
  }
}
