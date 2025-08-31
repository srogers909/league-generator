import 'package:test/test.dart';
import 'package:tactics_fc_generator/soccer_data_generator.dart';

void main() {
  group('Variable Squad Size Integration Tests', () {
    late LeagueGenerator leagueGenerator;
    late Country testCountry;
    late GenerationConfig config;

    setUp(() {
      leagueGenerator = LeagueGenerator(seed: 42);
      testCountry = CountryRepository.getCountryByCode('BR')!;
      config = GenerationConfig.defaultForCountry(testCountry);
    });

    test('should generate league with variable squad sizes matching UI display format', () async {
      // Test with variable squad sizes enabled (default)
      expect(config.playerConfig.useVariableSquadSizes, true);
      expect(config.playerConfig.minSquadSize, 18);
      expect(config.playerConfig.maxSquadSize, 32);
      expect(config.playerConfig.averageSquadSize, 25);
      expect(config.playerConfig.reputationInfluence, 0.6);

      // Generate complete league using the same method as the UI BLoC
      final league = await leagueGenerator.generateCompleteLeague(
        country: testCountry,
        config: config,
      );

      final teams = league.teams;
      print('Generated ${teams.length} teams:');
      var totalPlayers = 0;
      final squadSizes = <int>[];
      
      for (var team in teams) {
        final squadSize = team.players.length;
        squadSizes.add(squadSize);
        totalPlayers += squadSize;
        print('${team.name}: $squadSize players');
      }

      // Verify variable squad sizes
      expect(teams.length, config.leagueConfig.teamsPerDivision);
      expect(squadSizes.every((size) => size >= config.playerConfig.minSquadSize), true);
      expect(squadSizes.every((size) => size <= config.playerConfig.maxSquadSize), true);
      expect(squadSizes.toSet().length > 1, true, reason: 'Should have different squad sizes');
      
      print('Squad sizes: $squadSizes');
      print('Total players: $totalPlayers');
      print('Average squad size: ${(totalPlayers / teams.length).toStringAsFixed(1)}');
      
      // Verify UI display format would work
      final uiDisplayText = config.playerConfig.useVariableSquadSizes 
          ? '${config.playerConfig.minSquadSize}-${config.playerConfig.maxSquadSize} players (varies by team reputation)'
          : '${config.playerConfig.averageSquadSize} players (fixed)';
      
      print('UI would display: "$uiDisplayText"');
      expect(uiDisplayText, '18-32 players (varies by team reputation)');
    });

    test('should verify UI display format for different configurations', () {
      // Test variable squad sizes display (default)
      final variableDisplayText = config.playerConfig.useVariableSquadSizes 
          ? '${config.playerConfig.minSquadSize}-${config.playerConfig.maxSquadSize} players (varies by team reputation)'
          : '${config.playerConfig.averageSquadSize} players (fixed)';
      
      print('Variable squads UI display: "$variableDisplayText"');
      expect(variableDisplayText, '18-32 players (varies by team reputation)');
      
      // Test what fixed squads would display
      final fixedDisplayText = false // useVariableSquadSizes = false
          ? '${config.playerConfig.minSquadSize}-${config.playerConfig.maxSquadSize} players (varies by team reputation)'
          : '${config.playerConfig.averageSquadSize} players (fixed)';
      
      print('Fixed squads UI display: "$fixedDisplayText"');
      expect(fixedDisplayText, '25 players (fixed)');
    });

    test('should demonstrate reputation influence on squad sizes', () async {
      final league = await leagueGenerator.generateCompleteLeague(
        country: testCountry,
        config: config,
      );

      final teams = league.teams;
      // Group teams by squad size to show distribution
      final sizeDistribution = <int, List<String>>{};
      for (var team in teams) {
        final size = team.players.length;
        sizeDistribution[size] ??= [];
        sizeDistribution[size]!.add(team.name);
      }

      print('\nSquad size distribution:');
      for (var entry in sizeDistribution.entries) {
        print('${entry.key} players: ${entry.value.length} teams (${entry.value.join(', ')})');
      }

      // Should have teams with different squad sizes (showing reputation influence)
      expect(sizeDistribution.keys.length > 1, true);
      expect(sizeDistribution.keys.every((size) => size >= 18 && size <= 32), true);
    });
  });
}
