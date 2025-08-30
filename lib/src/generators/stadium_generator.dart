import 'dart:math';
import '../models/country.dart';
import '../models/generation_config.dart';
import '../utils/generation_utils.dart';

/// Generator for creating stadium data with realistic characteristics
class StadiumGenerator {
  final Random _random;
  final GenerationUtils _utils;

  StadiumGenerator({int? seed}) 
      : _random = Random(seed),
        _utils = GenerationUtils(seed: seed);

  /// Generates a stadium for a team
  Map<String, dynamic> generateStadium({
    required Country country,
    required StadiumConfig config,
    required String teamName,
    required String cityName,
    required int teamReputation,
  }) {
    // Generate stadium name based on cultural patterns
    final stadiumName = _generateStadiumName(
      country: country,
      teamName: teamName,
      cityName: cityName,
    );

    // Generate capacity based on team reputation and configuration
    final capacity = _generateCapacity(
      config: config,
      teamReputation: teamReputation,
      useRealistic: config.useRealisticCapacities,
    );

    // Generate founding year
    final foundedYear = _generateFoundedYear();

    // Generate stadium characteristics
    final characteristics = _generateStadiumCharacteristics(country);

    return {
      'id': _utils.generateId(),
      'name': stadiumName,
      'capacity': capacity,
      'city': cityName,
      'country': country.code,
      'foundedYear': foundedYear,
      'surfaceType': characteristics['surfaceType'],
      'roofType': characteristics['roofType'],
      'hasUndersoilHeating': characteristics['hasUndersoilHeating'],
      'atmosphere': _calculateAtmosphere(capacity, teamReputation),
    };
  }

  /// Generates a stadium name based on cultural patterns
  String _generateStadiumName({
    required Country country,
    required String teamName,
    required String cityName,
  }) {
    final patterns = country.namingCulture.stadiumPatterns;
    if (patterns.isEmpty) {
      return '$teamName Stadium';
    }

    final pattern = patterns[_random.nextInt(patterns.length)];
    
    // Replace placeholders in the pattern
    String stadiumName = pattern
        .replaceAll('{team}', teamName)
        .replaceAll('{city}', cityName)
        .replaceAll('{name}', _generateGenericStadiumName())
        .replaceAll('{landmark}', _generateLandmarkName())
        .replaceAll('{sponsor}', _generateSponsorName());
    
    return _capitalizeWords(stadiumName);
  }

  /// Generates stadium capacity based on team reputation and settings
  int _generateCapacity({
    required StadiumConfig config,
    required int teamReputation,
    required bool useRealistic,
  }) {
    if (!useRealistic) {
      return config.minCapacity + 
             _random.nextInt(config.maxCapacity - config.minCapacity);
    }

    // Base capacity on team reputation (better teams = bigger stadiums)
    final baseCapacity = _calculateBaseCapacity(teamReputation);
    
    // Add some variation
    final variation = (baseCapacity * 0.3).round();
    final minCap = (baseCapacity - variation).clamp(config.minCapacity, config.maxCapacity);
    final maxCap = (baseCapacity + variation).clamp(config.minCapacity, config.maxCapacity);
    
    return _utils.generateNormalInt(
      mean: baseCapacity.toDouble(),
      standardDeviation: variation / 3.0,
      min: minCap,
      max: maxCap,
    );
  }

  /// Calculates base capacity based on team reputation
  int _calculateBaseCapacity(int reputation) {
    // Linear mapping: reputation 30-85 -> capacity 8000-60000
    final normalizedRep = (reputation - 30) / 55.0; // Normalize to 0-1
    final baseCapacity = 8000 + (normalizedRep * 52000).round();
    return baseCapacity.clamp(5000, 80000);
  }

  /// Generates a realistic founded year for the stadium
  int _generateFoundedYear() {
    final currentYear = DateTime.now().year;
    
    // Most stadiums built between 1920-2020, with peaks in certain periods
    final periods = [
      {'start': 1920, 'end': 1939, 'weight': 15.0}, // Early football boom
      {'start': 1945, 'end': 1975, 'weight': 25.0}, // Post-war construction
      {'start': 1976, 'end': 1995, 'weight': 20.0}, // Modernization period
      {'start': 1996, 'end': 2010, 'weight': 25.0}, // Modern stadium era
      {'start': 2011, 'end': currentYear, 'weight': 15.0}, // Recent builds
    ];

    final selectedPeriod = _utils.weightedChoice(
      periods,
      periods.map((p) => p['weight'] as double).toList(),
    );

    final start = selectedPeriod['start'] as int;
    final end = selectedPeriod['end'] as int;
    
    return start + _random.nextInt(end - start + 1);
  }

  /// Generates stadium characteristics based on country and era
  Map<String, dynamic> _generateStadiumCharacteristics(Country country) {
    // Surface type distribution
    final surfaceTypes = ['Natural Grass', 'Artificial Turf', 'Hybrid Grass'];
    final surfaceWeights = [70.0, 10.0, 20.0]; // Most stadiums use natural grass
    final surfaceType = _utils.weightedChoice(surfaceTypes, surfaceWeights);

    // Roof type distribution
    final roofTypes = ['Open', 'Partial', 'Retractable', 'Full'];
    final roofWeights = [60.0, 25.0, 10.0, 5.0];
    final roofType = _utils.weightedChoice(roofTypes, roofWeights);

    // Undersoil heating (more common in colder countries)
    final hasUndersoilHeating = _shouldHaveUndersoilHeating(country);

    return {
      'surfaceType': surfaceType,
      'roofType': roofType,
      'hasUndersoilHeating': hasUndersoilHeating,
    };
  }

  /// Determines if stadium should have undersoil heating based on country
  bool _shouldHaveUndersoilHeating(Country country) {
    // More likely in colder European countries
    final coldCountries = ['GB', 'DE', 'NL', 'NO', 'SE', 'DK', 'FI'];
    final isColderCountry = coldCountries.contains(country.code);
    
    final probability = isColderCountry ? 0.7 : 0.2;
    return _random.nextDouble() < probability;
  }

  /// Calculates stadium atmosphere rating based on capacity and team reputation
  int _calculateAtmosphere(int capacity, int teamReputation) {
    // Base atmosphere on capacity (bigger isn't always better)
    double atmosphereScore = 0.0;
    
    if (capacity < 20000) {
      atmosphereScore += 70.0; // Intimate atmosphere
    } else if (capacity < 40000) {
      atmosphereScore += 80.0; // Good balance
    } else if (capacity < 60000) {
      atmosphereScore += 75.0; // Large but can be atmospheric
    } else {
      atmosphereScore += 65.0; // Very large, potentially less intimate
    }

    // Add team reputation factor (successful teams have better atmosphere)
    atmosphereScore += (teamReputation - 50) * 0.3;
    
    // Add some randomness
    atmosphereScore += (_random.nextDouble() - 0.5) * 20;
    
    return atmosphereScore.round().clamp(40, 95);
  }

  /// Helper methods for name generation
  String _generateGenericStadiumName() {
    final names = ['Arena', 'Stadium', 'Ground', 'Park', 'Field', 'Dome'];
    return names[_random.nextInt(names.length)];
  }

  String _generateLandmarkName() {
    final landmarks = ['Trafford', 'Bridge', 'Park', 'Hill', 'Valley', 'Lane', 'Road', 'Gardens'];
    return landmarks[_random.nextInt(landmarks.length)];
  }

  String _generateSponsorName() {
    final sponsors = ['Emirates', 'Etihad', 'Allianz', 'Signal Iduna', 'Wanda', 'Mercedes-Benz'];
    return sponsors[_random.nextInt(sponsors.length)];
  }

  String _capitalizeWords(String text) {
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  /// Validates stadium configuration
  bool validateStadiumConfig(StadiumConfig config) {
    // Check capacity bounds
    if (config.minCapacity >= config.maxCapacity) {
      return false;
    }

    if (config.minCapacity < 1000 || config.maxCapacity > 150000) {
      return false; // Unrealistic capacity bounds
    }

    return true;
  }
}
