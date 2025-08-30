import 'dart:math';
import 'package:soccer_engine/soccer_engine.dart';
import '../models/country.dart';
import '../models/generation_config.dart';
import 'team_generator.dart';
import 'player_generator.dart';

/// Generator for creating league structures and competitions
class LeagueGenerator {
  final Random _random;
  final TeamGenerator _teamGenerator;
  final PlayerGenerator _playerGenerator;

  LeagueGenerator({int? seed}) 
      : _random = Random(seed),
        _teamGenerator = TeamGenerator(seed: seed),
        _playerGenerator = PlayerGenerator(seed: seed);

  /// Generates a complete league system for a country
  Future<League> generateLeague({
    required Country country,
    required GenerationConfig config,
  }) async {
    final leagueConfig = config.leagueConfig;
    
    // Generate teams for the league
    final teams = _teamGenerator.generateTeams(
      country: country,
      config: config.teamConfig,
      count: leagueConfig.teamsPerDivision,
    );

    // Create the league
    final league = League(
      id: _generateLeagueId(),
      name: leagueConfig.nameFormat,
      country: country.code,
      teams: teams,
      // Additional league properties will be added as they become available
    );

    return league;
  }

  /// Generates a complete league with teams and players using variable squad sizes
  Future<League> generateCompleteLeague({
    required Country country,
    required GenerationConfig config,
  }) async {
    final leagueConfig = config.leagueConfig;
    final playerConfig = config.playerConfig;
    final teamConfig = config.teamConfig;
    
    // Generate base teams first (without players)
    final baseTeams = _teamGenerator.generateTeams(
      country: country,
      config: teamConfig,
      count: leagueConfig.teamsPerDivision,
    );
    
    // Generate reputation values for each team (since Team model doesn't store it)
    final teamReputations = <String, int>{};
    for (final team in baseTeams) {
      final reputation = _generateTeamReputation(teamConfig);
      teamReputations[team.id] = reputation;
    }
    
    // Generate teams with players using variable squad sizes
    final completeTeams = <Team>[];
    int totalPlayersGenerated = 0;
    
    for (final baseTeam in baseTeams) {
      final teamReputation = teamReputations[baseTeam.id] ?? teamConfig.minReputation;
      
      // Calculate squad size based on reputation
      final squadSize = _playerGenerator.generateSquadSize(
        teamReputation: teamReputation,
        config: playerConfig,
      );
      
      // Generate players for this team
      final players = _playerGenerator.generatePlayersForTeam(
        country: country,
        config: playerConfig,
        squadSize: squadSize,
      );
      
      // Create complete team with players
      final completeTeam = baseTeam.copyWith(players: players);
      completeTeams.add(completeTeam);
      totalPlayersGenerated += players.length;
    }
    
    // Create the complete league
    final league = League(
      id: _generateLeagueId(),
      name: leagueConfig.nameFormat,
      country: country.code,
      teams: completeTeams,
    );

    return league;
  }

  /// Generates team reputation using the same logic as TeamGenerator
  int _generateTeamReputation(TeamConfig config) {
    // Use same logic as TeamGenerator._generateReputation
    final mean = (config.minReputation + config.maxReputation) / 2;
    final stdDev = (config.maxReputation - config.minReputation) / 4;
    
    // Generate reputation using normal distribution
    double reputation = mean.toDouble();
    for (int i = 0; i < 12; i++) {
      reputation += (_random.nextDouble() - 0.5) * stdDev * 0.5;
    }
    
    return reputation.round().clamp(config.minReputation, config.maxReputation);
  }

  /// Generates multiple divisions for a league system
  List<League> generateDivisions({
    required Country country,
    required GenerationConfig config,
  }) {
    final divisions = <League>[];
    final leagueConfig = config.leagueConfig;

    for (int i = 0; i < leagueConfig.divisions; i++) {
      final divisionName = _generateDivisionName(
        baseFormat: leagueConfig.nameFormat,
        divisionLevel: i + 1,
        country: country,
      );

      final teams = _teamGenerator.generateTeams(
        country: country,
        config: config.teamConfig,
        count: leagueConfig.teamsPerDivision,
      );

      final division = League(
        id: _generateLeagueId(),
        name: divisionName,
        country: country.code,
        teams: teams,
      );

      divisions.add(division);
    }

    return divisions;
  }

  /// Generates cup competitions for a country
  List<League> generateCupCompetitions({
    required Country country,
    required GenerationConfig config,
    required List<Team> allTeams,
  }) {
    final cups = <League>[];
    
    if (!config.leagueConfig.generateCups) {
      return cups;
    }

    // Generate domestic cup
    final domesticCup = _generateDomesticCup(
      country: country,
      teams: allTeams,
    );
    cups.add(domesticCup);

    // Generate league cup if the country has multiple divisions
    if (config.leagueConfig.divisions > 1) {
      final leagueCup = _generateLeagueCup(
        country: country,
        teams: allTeams,
      );
      cups.add(leagueCup);
    }

    return cups;
  }

  /// Generates a domestic cup competition
  League _generateDomesticCup({
    required Country country,
    required List<Team> teams,
  }) {
    return League(
      id: _generateLeagueId(),
      name: '${country.name} Cup',
      country: country.code,
      teams: teams,
    );
  }

  /// Generates a league cup competition
  League _generateLeagueCup({
    required Country country,
    required List<Team> teams,
  }) {
    return League(
      id: _generateLeagueId(),
      name: '${country.name} League Cup',
      country: country.code,
      teams: teams,
    );
  }

  /// Generates a division name based on the level
  String _generateDivisionName({
    required String baseFormat,
    required int divisionLevel,
    required Country country,
  }) {
    switch (divisionLevel) {
      case 1:
        return baseFormat;
      case 2:
        return _getSecondDivisionName(country);
      case 3:
        return _getThirdDivisionName(country);
      case 4:
        return _getFourthDivisionName(country);
      default:
        return '${country.name} Division $divisionLevel';
    }
  }

  /// Gets culturally appropriate second division names
  String _getSecondDivisionName(Country country) {
    switch (country.code) {
      case 'GB':
        return 'Championship';
      case 'ES':
        return 'Segunda División';
      case 'DE':
        return '2. Bundesliga';
      case 'IT':
        return 'Serie B';
      case 'FR':
        return 'Ligue 2';
      case 'BR':
        return 'Série B';
      case 'AR':
        return 'Primera B Nacional';
      case 'NL':
        return 'Eerste Divisie';
      case 'PT':
        return 'Segunda Liga';
      case 'US':
        return 'USL Championship';
      default:
        return '${country.name} Second Division';
    }
  }

  /// Gets culturally appropriate third division names
  String _getThirdDivisionName(Country country) {
    switch (country.code) {
      case 'GB':
        return 'League One';
      case 'ES':
        return 'Segunda División B';
      case 'DE':
        return '3. Liga';
      case 'IT':
        return 'Serie C';
      case 'FR':
        return 'National';
      default:
        return '${country.name} Third Division';
    }
  }

  /// Gets culturally appropriate fourth division names
  String _getFourthDivisionName(Country country) {
    switch (country.code) {
      case 'GB':
        return 'League Two';
      case 'ES':
        return 'Tercera División';
      case 'DE':
        return 'Regionalliga';
      case 'IT':
        return 'Serie D';
      case 'FR':
        return 'National 2';
      default:
        return '${country.name} Fourth Division';
    }
  }

  /// Generates a unique league ID
  String _generateLeagueId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    const length = 8;
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(_random.nextInt(chars.length)),
      ),
    );
  }

  /// Calculates appropriate league structure based on country population
  LeagueStructure calculateOptimalStructure(Country country) {
    // This would ideally use real population data
    // For now, return the country's default structure
    return country.leagueStructure;
  }

  /// Validates league configuration for a country
  bool validateLeagueConfig({
    required Country country,
    required LeagueConfig config,
  }) {
    // Check if teams per division is reasonable
    if (config.teamsPerDivision < 8 || config.teamsPerDivision > 30) {
      return false;
    }

    // Check if number of divisions is reasonable
    if (config.divisions < 1 || config.divisions > 6) {
      return false;
    }

    // Check if structure matches country's typical structure
    final countryStructure = country.leagueStructure;
    if (config.teamsPerDivision != countryStructure.topDivisionTeams) {
      // Allow some flexibility but warn if very different
      final difference = (config.teamsPerDivision - countryStructure.topDivisionTeams).abs();
      if (difference > 4) {
        return false;
      }
    }

    return true;
  }
}
