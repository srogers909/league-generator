import 'package:test/test.dart';
import 'package:tactics_fc_generator/soccer_data_generator.dart';

void main() {
  group('Variable Squad Size Tests', () {
    test('generateSquadSize should vary based on team reputation', () {
      final playerGenerator = PlayerGenerator(seed: 12345);
      
      // Test configuration with variable squad sizes enabled
      const config = PlayerConfig(
        ageDistribution: AgeDistribution.realistic(),
        skillDistribution: SkillDistribution.realistic(),
        generatePersonalities: true,
        useRealisticPositions: true,
        domesticPlayerPercentage: 75,
        useVariableSquadSizes: true,
        minSquadSize: 18,
        maxSquadSize: 32,
        averageSquadSize: 25,
        reputationInfluence: 0.6,
      );
      
      // Test with low reputation team
      final lowRepSquadSize = playerGenerator.generateSquadSize(
        teamReputation: 30,
        config: config,
      );
      
      // Test with high reputation team
      final highRepSquadSize = playerGenerator.generateSquadSize(
        teamReputation: 85,
        config: config,
      );
      
      // Test with medium reputation team
      final mediumRepSquadSize = playerGenerator.generateSquadSize(
        teamReputation: 55,
        config: config,
      );
      
      print('Low reputation (30) squad size: $lowRepSquadSize');
      print('Medium reputation (55) squad size: $mediumRepSquadSize');
      print('High reputation (85) squad size: $highRepSquadSize');
      
      // High reputation teams should generally have larger squads
      expect(lowRepSquadSize, greaterThanOrEqualTo(config.minSquadSize));
      expect(lowRepSquadSize, lessThanOrEqualTo(config.maxSquadSize));
      expect(highRepSquadSize, greaterThanOrEqualTo(config.minSquadSize));
      expect(highRepSquadSize, lessThanOrEqualTo(config.maxSquadSize));
      expect(mediumRepSquadSize, greaterThanOrEqualTo(config.minSquadSize));
      expect(mediumRepSquadSize, lessThanOrEqualTo(config.maxSquadSize));
    });
    
    test('generateSquadSize should respect configuration bounds', () {
      final playerGenerator = PlayerGenerator(seed: 12345);
      
      const config = PlayerConfig(
        ageDistribution: AgeDistribution.realistic(),
        skillDistribution: SkillDistribution.realistic(),
        generatePersonalities: true,
        useRealisticPositions: true,
        domesticPlayerPercentage: 75,
        useVariableSquadSizes: true,
        minSquadSize: 20,
        maxSquadSize: 30,
        averageSquadSize: 25,
        reputationInfluence: 0.8,
      );
      
      // Test with extreme reputation values
      for (int reputation = 0; reputation <= 100; reputation += 10) {
        final squadSize = playerGenerator.generateSquadSize(
          teamReputation: reputation,
          config: config,
        );
        
        expect(squadSize, greaterThanOrEqualTo(config.minSquadSize));
        expect(squadSize, lessThanOrEqualTo(config.maxSquadSize));
      }
    });
    
    test('generateSquadSize should return fixed size when variable squads disabled', () {
      final playerGenerator = PlayerGenerator(seed: 12345);
      
      const config = PlayerConfig(
        ageDistribution: AgeDistribution.realistic(),
        skillDistribution: SkillDistribution.realistic(),
        generatePersonalities: true,
        useRealisticPositions: true,
        domesticPlayerPercentage: 75,
        useVariableSquadSizes: false, // Disabled
        minSquadSize: 18,
        maxSquadSize: 32,
        averageSquadSize: 25,
        reputationInfluence: 0.6,
      );
      
      // All teams should get the same squad size regardless of reputation
      final lowRepSquadSize = playerGenerator.generateSquadSize(
        teamReputation: 30,
        config: config,
      );
      
      final highRepSquadSize = playerGenerator.generateSquadSize(
        teamReputation: 85,
        config: config,
      );
      
      expect(lowRepSquadSize, equals(config.averageSquadSize));
      expect(highRepSquadSize, equals(config.averageSquadSize));
    });
    
    test('generateCompleteLeague should create teams with variable squad sizes', () async {
      final leagueGenerator = LeagueGenerator(seed: 12345);
      final england = CountryRepository.getCountryByCode('GB')!;
      
      final config = GenerationConfig.defaultForCountry(england);
      
      final league = await leagueGenerator.generateCompleteLeague(
        country: england,
        config: config,
      );
      
      expect(league.teams, hasLength(20)); // Default Premier League size
      
      // Check that teams have different squad sizes
      final squadSizes = league.teams.map((t) => t.players.length).toList();
      print('Squad sizes: $squadSizes');
      
      // Should have variation in squad sizes
      final minSquadSize = squadSizes.reduce((a, b) => a < b ? a : b);
      final maxSquadSize = squadSizes.reduce((a, b) => a > b ? a : b);
      
      expect(maxSquadSize, greaterThan(minSquadSize));
      
      // All squad sizes should be within configured bounds
      for (final size in squadSizes) {
        expect(size, greaterThanOrEqualTo(config.playerConfig.minSquadSize));
        expect(size, lessThanOrEqualTo(config.playerConfig.maxSquadSize));
      }
      
      // Total players should be roughly around expected amount
      final totalPlayers = squadSizes.reduce((a, b) => a + b);
      print('Total players generated: $totalPlayers');
      expect(totalPlayers, greaterThan(400)); // Should be reasonable amount
      expect(totalPlayers, lessThan(650)); // But not too many
    });
  });
}
