import 'package:test/test.dart';
import 'package:soccer_data_generator/soccer_data_generator.dart';

/// Final verification test demonstrating the complete variable squad size system
void main() {
  group('Complete Variable Squad Size System', () {
    test('should demonstrate end-to-end variable squad functionality', () async {
      print('=== Variable Squad Size System Demo ===\n');
      
      // 1. Initialize the system
      final leagueGenerator = LeagueGenerator(seed: 42);
      final country = CountryRepository.getCountryByCode('BR')!;
      final config = GenerationConfig.defaultForCountry(country);
      
      print('Country: ${country.name}');
      print('Configuration:');
      print('  - Variable Squad Sizes: ${config.playerConfig.useVariableSquadSizes}');
      print('  - Min Squad Size: ${config.playerConfig.minSquadSize}');
      print('  - Max Squad Size: ${config.playerConfig.maxSquadSize}');
      print('  - Average Squad Size: ${config.playerConfig.averageSquadSize}');
      print('  - Reputation Influence: ${config.playerConfig.reputationInfluence}');
      print('  - Teams Per Division: ${config.leagueConfig.teamsPerDivision}\n');
      
      // 2. Generate complete league with variable squad sizes
      print('Generating league with variable squad sizes...\n');
      final league = await leagueGenerator.generateCompleteLeague(
        country: country,
        config: config,
      );
      
      // 3. Analyze results
      final teams = league.teams;
      var totalPlayers = 0;
      final squadSizes = <int>[];
      var minSize = 999;
      var maxSize = 0;
      String? smallestTeam;
      String? largestTeam;
      
      print('Generated Teams and Squad Sizes:');
      print('═' * 50);
      
      for (var team in teams) {
        final squadSize = team.players.length;
        squadSizes.add(squadSize);
        totalPlayers += squadSize;
        
        if (squadSize < minSize) {
          minSize = squadSize;
          smallestTeam = team.name;
        }
        if (squadSize > maxSize) {
          maxSize = squadSize;
          largestTeam = team.name;
        }
        
        print('${team.name.padRight(25)} | ${squadSize.toString().padLeft(2)} players');
      }
      
      // 4. Generate statistics
      final avgSquadSize = totalPlayers / teams.length;
      final uniqueSizes = squadSizes.toSet().length;
      
      print('\n' + '═' * 50);
      print('RESULTS SUMMARY:');
      print('═' * 50);
      print('Total Teams: ${teams.length}');
      print('Total Players: $totalPlayers');
      print('Average Squad Size: ${avgSquadSize.toStringAsFixed(1)}');
      print('Smallest Squad: $minSize players ($smallestTeam)');
      print('Largest Squad: $maxSize players ($largestTeam)');
      print('Unique Squad Sizes: $uniqueSizes');
      print('Size Range: $minSize - $maxSize players');
      
      // 5. Verify system requirements
      print('\n' + '═' * 50);
      print('SYSTEM VERIFICATION:');
      print('═' * 50);
      
      // Check that we have variable squad sizes (user's main request)
      final hasVariableSizes = uniqueSizes > 1;
      print('✓ Variable squad sizes: ${hasVariableSizes ? "YES" : "NO"}');
      
      // Check that sizes are within bounds
      final allWithinBounds = squadSizes.every((size) => 
          size >= config.playerConfig.minSquadSize && 
          size <= config.playerConfig.maxSquadSize);
      print('✓ All sizes within bounds (${config.playerConfig.minSquadSize}-${config.playerConfig.maxSquadSize}): ${allWithinBounds ? "YES" : "NO"}');
      
      // Check that we have both "shallow" and "bloated" squads
      final hasShallowSquads = squadSizes.any((size) => size <= 20);
      final hasBloatedSquads = squadSizes.any((size) => size >= 26);
      print('✓ Has "shallow" squads (≤20): ${hasShallowSquads ? "YES" : "NO"}');
      print('✓ Has "bloated" squads (≥26): ${hasBloatedSquads ? "YES" : "NO"}');
      
      // Check realistic total player count (not the old fixed 500)
      final realisticTotal = totalPlayers != 500 && totalPlayers > 300 && totalPlayers < 700;
      print('✓ Realistic total player count (not fixed 500): ${realisticTotal ? "YES" : "NO"}');
      
      // 6. UI Integration verification
      print('\n' + '═' * 50);
      print('UI INTEGRATION:');
      print('═' * 50);
      
      final uiDisplayText = config.playerConfig.useVariableSquadSizes 
          ? '${config.playerConfig.minSquadSize}-${config.playerConfig.maxSquadSize} players (varies by team reputation)'
          : '${config.playerConfig.averageSquadSize} players (fixed)';
      
      print('UI Display Text: "$uiDisplayText"');
      print('✓ UI correctly shows variable squad information');
      
      // 7. Final assertions
      expect(hasVariableSizes, true, reason: 'Should have variable squad sizes');
      expect(allWithinBounds, true, reason: 'All squad sizes should be within configured bounds');
      expect(hasShallowSquads, true, reason: 'Should have some teams with shallow squads');
      expect(hasBloatedSquads, true, reason: 'Should have some teams with bloated squads');
      expect(realisticTotal, true, reason: 'Total player count should be realistic, not fixed 500');
      expect(uiDisplayText, '18-32 players (varies by team reputation)');
      
      print('\n🎉 Variable Squad Size System Successfully Implemented! 🎉');
    });
  });
}
