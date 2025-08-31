import 'dart:math';
import 'package:tactics_fc_engine/soccer_engine.dart';
import '../models/country.dart';
import '../models/generation_config.dart';
import '../utils/generation_utils.dart';
import '../utils/name_utils.dart';

/// Generator for creating soccer players with realistic characteristics
class PlayerGenerator {
  final Random _random;
  final GenerationUtils _utils;
  final NameUtils _nameUtils;

  PlayerGenerator({int? seed}) 
      : _random = Random(seed),
        _utils = GenerationUtils(seed: seed),
        _nameUtils = NameUtils(seed: seed);

  /// Generates a list of players for a team
  List<Player> generatePlayersForTeam({
    required Country country,
    required PlayerConfig config,
    required int squadSize,
  }) {
    final players = <Player>[];
    
    for (int i = 0; i < squadSize; i++) {
      final player = _generateSinglePlayer(
        country: country,
        config: config,
      );
      players.add(player);
    }

    return players;
  }

  /// Generates a squad size based on team reputation and configuration
  int generateSquadSize({
    required int teamReputation,
    required PlayerConfig config,
  }) {
    if (!config.useVariableSquadSizes) {
      return config.averageSquadSize;
    }

    // Calculate base size influenced by reputation
    // Reputation ranges from 0-100, we want it to influence squad size
    final reputationFactor = (teamReputation / 100.0) * config.reputationInfluence;
    
    // Calculate the reputation-based adjustment
    // High reputation teams get larger squads, low reputation get smaller
    final reputationRange = config.maxSquadSize - config.minSquadSize;
    final reputationAdjustment = (reputationFactor - 0.5) * reputationRange * 0.8;
    
    final targetSize = config.averageSquadSize + reputationAdjustment;
    
    // Add random variation for realism
    final finalSize = _utils.generateNormalInt(
      mean: targetSize,
      standardDeviation: 2.5,
      min: config.minSquadSize,
      max: config.maxSquadSize,
    );
    
    return finalSize;
  }

  /// Generates a single player with realistic characteristics
  Player _generateSinglePlayer({
    required Country country,
    required PlayerConfig config,
  }) {
    // Generate basic info
    final gender = 'male'; // Soccer is typically male-dominated
    final fullName = _nameUtils.generateFullName(
      language: country.language,
      gender: gender,
      titlePrefixes: country.namingCulture.titlePrefixes,
    );

    // Generate age based on distribution
    final age = _generateAge(config.ageDistribution);
    
    // Generate position based on realistic distribution
    final position = _generatePosition(config.useRealisticPositions);
    
    // Generate overall skill based on distribution
    final overall = _generateOverallSkill(config.skillDistribution);
    
    // Generate nationality (domestic vs foreign players)
    final nationality = _generateNationality(country, config.domesticPlayerPercentage);

    // Generate individual skill attributes based on overall rating
    final technical = _utils.generateNormalInt(
      mean: overall.toDouble(),
      standardDeviation: 8.0,
      min: 1,
      max: 100,
    );
    
    final physical = _utils.generateNormalInt(
      mean: overall.toDouble(),
      standardDeviation: 8.0,
      min: 1,
      max: 100,
    );
    
    final mental = _utils.generateNormalInt(
      mean: overall.toDouble(),
      standardDeviation: 8.0,
      min: 1,
      max: 100,
    );

    return Player(
      id: _utils.generateId(),
      name: fullName,
      age: age,
      position: position,
      technical: technical,
      physical: physical,
      mental: mental,
    );
  }

  /// Generates a realistic age based on distribution parameters
  int _generateAge(AgeDistribution distribution) {
    return _utils.generateNormalInt(
      mean: distribution.peakAge.toDouble(),
      standardDeviation: distribution.standardDeviation,
      min: distribution.minAge,
      max: distribution.maxAge,
    );
  }

  /// Generates a position based on realistic distribution
  PlayerPosition _generatePosition(bool useRealistic) {
    if (!useRealistic) {
      final positions = PlayerPosition.values;
      return positions[_random.nextInt(positions.length)];
    }

    // Realistic distribution based on typical squad composition
    final weights = [
      10.0, // Goalkeeper (GK) - fewer needed
      25.0, // Defender (DEF) - many needed
      30.0, // Midfielder (MID) - most needed
      25.0, // Forward (FOR) - many needed
      10.0, // Wing-back or utility (if additional positions exist)
    ];

    final positions = [
      PlayerPosition.goalkeeper,
      PlayerPosition.defender,
      PlayerPosition.midfielder,
      PlayerPosition.forward,
      PlayerPosition.midfielder, // Extra midfielder for balance
    ];

    return _utils.weightedChoice(positions, weights);
  }

  /// Generates overall skill rating based on distribution
  int _generateOverallSkill(SkillDistribution distribution) {
    return _utils.generateNormalInt(
      mean: distribution.meanSkill,
      standardDeviation: distribution.standardDeviation,
      min: distribution.minSkill,
      max: distribution.maxSkill,
    );
  }

  /// Generates nationality (domestic vs foreign)
  String _generateNationality(Country country, int domesticPercentage) {
    final isDomestic = _random.nextInt(100) < domesticPercentage;
    
    if (isDomestic) {
      return country.code;
    } else {
      // Generate foreign nationality from nearby or historically connected countries
      return _generateForeignNationality(country);
    }
  }

  /// Generates a foreign nationality based on country connections
  String _generateForeignNationality(Country country) {
    // Simplified approach - would be more sophisticated in full implementation
    final commonForeignNationalities = {
      'GB': ['IE', 'FR', 'ES', 'PT', 'NL'],
      'ES': ['AR', 'BR', 'PT', 'FR', 'IT'],
      'DE': ['NL', 'AT', 'CH', 'PL', 'TR'],
      'IT': ['AR', 'BR', 'FR', 'ES', 'HR'],
      'FR': ['AL', 'MA', 'SN', 'CI', 'CM'],
      'BR': ['AR', 'UY', 'PT', 'ES', 'IT'],
      'AR': ['BR', 'UY', 'CL', 'PE', 'ES'],
      'NL': ['BE', 'DE', 'SR', 'CW', 'MA'],
      'PT': ['BR', 'AO', 'MZ', 'CV', 'ES'],
      'US': ['MX', 'CA', 'JM', 'TT', 'HN'],
    };

    final foreignOptions = commonForeignNationalities[country.code] ?? ['BR', 'AR', 'ES', 'IT', 'FR'];
    return foreignOptions[_random.nextInt(foreignOptions.length)];
  }

  /// Validates player configuration
  bool validatePlayerConfig(PlayerConfig config) {
    // Check age distribution
    if (config.ageDistribution.minAge >= config.ageDistribution.maxAge) {
      return false;
    }
    
    if (config.ageDistribution.peakAge < config.ageDistribution.minAge ||
        config.ageDistribution.peakAge > config.ageDistribution.maxAge) {
      return false;
    }

    // Check skill distribution
    if (config.skillDistribution.minSkill >= config.skillDistribution.maxSkill) {
      return false;
    }

    if (config.skillDistribution.meanSkill < config.skillDistribution.minSkill ||
        config.skillDistribution.meanSkill > config.skillDistribution.maxSkill) {
      return false;
    }

    // Check domestic player percentage
    if (config.domesticPlayerPercentage < 0 || config.domesticPlayerPercentage > 100) {
      return false;
    }

    return true;
  }
}
