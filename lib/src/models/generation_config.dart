import 'package:json_annotation/json_annotation.dart';
import 'country.dart';

part 'generation_config.g.dart';

/// Configuration for generating soccer data for a specific country/league
@JsonSerializable()
class GenerationConfig {
  /// The target country for generation
  final Country country;
  
  /// League generation settings
  final LeagueConfig leagueConfig;
  
  /// Team generation settings
  final TeamConfig teamConfig;
  
  /// Player generation settings
  final PlayerConfig playerConfig;
  
  /// Stadium generation settings
  final StadiumConfig stadiumConfig;
  
  /// Random seed for reproducible generation
  final int? seed;

  const GenerationConfig({
    required this.country,
    required this.leagueConfig,
    required this.teamConfig,
    required this.playerConfig,
    required this.stadiumConfig,
    this.seed,
  });

  factory GenerationConfig.fromJson(Map<String, dynamic> json) => 
      _$GenerationConfigFromJson(json);
  Map<String, dynamic> toJson() => _$GenerationConfigToJson(this);

  /// Creates a default configuration for a given country
  factory GenerationConfig.defaultForCountry(Country country) {
    return GenerationConfig(
      country: country,
      leagueConfig: LeagueConfig.defaultForCountry(country),
      teamConfig: const TeamConfig.defaultConfig(),
      playerConfig: const PlayerConfig.defaultConfig(),
      stadiumConfig: const StadiumConfig.defaultConfig(),
    );
  }
}

/// Configuration for league generation
@JsonSerializable()
class LeagueConfig {
  /// Number of divisions to generate
  final int divisions;
  
  /// Teams per division
  final int teamsPerDivision;
  
  /// Whether to generate cup competitions
  final bool generateCups;
  
  /// League name format (e.g., "{country} Premier League")
  final String nameFormat;
  
  /// Historical data depth in years
  final int historicalYears;

  const LeagueConfig({
    required this.divisions,
    required this.teamsPerDivision,
    required this.generateCups,
    required this.nameFormat,
    required this.historicalYears,
  });

  factory LeagueConfig.fromJson(Map<String, dynamic> json) => 
      _$LeagueConfigFromJson(json);
  Map<String, dynamic> toJson() => _$LeagueConfigToJson(this);

  factory LeagueConfig.defaultForCountry(Country country) {
    return LeagueConfig(
      divisions: country.leagueStructure.professionalDivisions,
      teamsPerDivision: country.leagueStructure.topDivisionTeams,
      generateCups: true,
      nameFormat: '${country.name} Premier League',
      historicalYears: 5,
    );
  }
}

/// Configuration for team generation
@JsonSerializable()
class TeamConfig {
  /// Whether to use realistic city-based team distribution
  final bool useRealisticDistribution;
  
  /// Minimum team reputation (0-100)
  final int minReputation;
  
  /// Maximum team reputation (0-100)
  final int maxReputation;
  
  /// Whether to generate team histories
  final bool generateHistory;
  
  /// Whether to use traditional naming patterns
  final bool useTraditionalNames;

  const TeamConfig({
    required this.useRealisticDistribution,
    required this.minReputation,
    required this.maxReputation,
    required this.generateHistory,
    required this.useTraditionalNames,
  });

  factory TeamConfig.fromJson(Map<String, dynamic> json) => 
      _$TeamConfigFromJson(json);
  Map<String, dynamic> toJson() => _$TeamConfigToJson(this);

  const TeamConfig.defaultConfig()
      : useRealisticDistribution = true,
        minReputation = 30,
        maxReputation = 85,
        generateHistory = true,
        useTraditionalNames = true;
}

/// Configuration for player generation
@JsonSerializable()
class PlayerConfig {
  /// Age distribution settings
  final AgeDistribution ageDistribution;
  
  /// Skill distribution settings
  final SkillDistribution skillDistribution;
  
  /// Whether to generate player personalities
  final bool generatePersonalities;
  
  /// Whether to use realistic position distributions
  final bool useRealisticPositions;
  
  /// Percentage of domestic players (0-100)
  final int domesticPlayerPercentage;
  
  /// Whether to use variable squad sizes based on team reputation
  final bool useVariableSquadSizes;
  
  /// Minimum squad size for any team
  final int minSquadSize;
  
  /// Maximum squad size for any team
  final int maxSquadSize;
  
  /// Average squad size across all teams
  final int averageSquadSize;
  
  /// How much team reputation influences squad size (0.0-1.0)
  final double reputationInfluence;

  const PlayerConfig({
    required this.ageDistribution,
    required this.skillDistribution,
    required this.generatePersonalities,
    required this.useRealisticPositions,
    required this.domesticPlayerPercentage,
    required this.useVariableSquadSizes,
    required this.minSquadSize,
    required this.maxSquadSize,
    required this.averageSquadSize,
    required this.reputationInfluence,
  });

  factory PlayerConfig.fromJson(Map<String, dynamic> json) => 
      _$PlayerConfigFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerConfigToJson(this);

  const PlayerConfig.defaultConfig()
      : ageDistribution = const AgeDistribution.realistic(),
        skillDistribution = const SkillDistribution.realistic(),
        generatePersonalities = true,
        useRealisticPositions = true,
        domesticPlayerPercentage = 75,
        useVariableSquadSizes = true,
        minSquadSize = 18,
        maxSquadSize = 32,
        averageSquadSize = 25,
        reputationInfluence = 0.6;
}

/// Configuration for stadium generation
@JsonSerializable()
class StadiumConfig {
  /// Minimum stadium capacity
  final int minCapacity;
  
  /// Maximum stadium capacity
  final int maxCapacity;
  
  /// Whether to use realistic capacity distribution
  final bool useRealisticCapacities;
  
  /// Whether to generate stadium histories
  final bool generateHistory;

  const StadiumConfig({
    required this.minCapacity,
    required this.maxCapacity,
    required this.useRealisticCapacities,
    required this.generateHistory,
  });

  factory StadiumConfig.fromJson(Map<String, dynamic> json) => 
      _$StadiumConfigFromJson(json);
  Map<String, dynamic> toJson() => _$StadiumConfigToJson(this);

  const StadiumConfig.defaultConfig()
      : minCapacity = 5000,
        maxCapacity = 80000,
        useRealisticCapacities = true,
        generateHistory = true;
}

/// Age distribution parameters for player generation
@JsonSerializable()
class AgeDistribution {
  /// Minimum player age
  final int minAge;
  
  /// Maximum player age
  final int maxAge;
  
  /// Peak age for player distribution
  final int peakAge;
  
  /// Standard deviation for age distribution
  final double standardDeviation;

  const AgeDistribution({
    required this.minAge,
    required this.maxAge,
    required this.peakAge,
    required this.standardDeviation,
  });

  factory AgeDistribution.fromJson(Map<String, dynamic> json) => 
      _$AgeDistributionFromJson(json);
  Map<String, dynamic> toJson() => _$AgeDistributionToJson(this);

  const AgeDistribution.realistic()
      : minAge = 16,
        maxAge = 40,
        peakAge = 26,
        standardDeviation = 4.5;
}

/// Skill distribution parameters for player generation
@JsonSerializable()
class SkillDistribution {
  /// Mean skill level (0-100)
  final double meanSkill;
  
  /// Standard deviation for skill distribution
  final double standardDeviation;
  
  /// Minimum skill level
  final int minSkill;
  
  /// Maximum skill level
  final int maxSkill;

  const SkillDistribution({
    required this.meanSkill,
    required this.standardDeviation,
    required this.minSkill,
    required this.maxSkill,
  });

  factory SkillDistribution.fromJson(Map<String, dynamic> json) => 
      _$SkillDistributionFromJson(json);
  Map<String, dynamic> toJson() => _$SkillDistributionToJson(this);

  const SkillDistribution.realistic()
      : meanSkill = 55.0,
        standardDeviation = 15.0,
        minSkill = 20,
        maxSkill = 95;
}
