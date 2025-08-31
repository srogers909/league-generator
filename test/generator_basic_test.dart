import 'package:test/test.dart';
import 'package:tactics_fc_generator/soccer_data_generator.dart';
import 'package:tactics_fc_engine/soccer_engine.dart';

void main() {
  group('Soccer Data Generator Tests', () {
    test('should get all countries', () {
      final countries = CountryGenerator.getAllCountries();
      
      expect(countries, isNotEmpty);
      expect(countries.length, greaterThan(5));
      
      // Check that England is included
      final england = countries.firstWhere((c) => c.code == 'GB');
      expect(england.name, equals('England'));
      expect(england.strongSoccerCulture, isTrue);
    });

    test('should get strong soccer countries', () {
      final strongCountries = CountryGenerator.getStrongSoccerCountries();
      
      expect(strongCountries, isNotEmpty);
      expect(strongCountries.every((c) => c.strongSoccerCulture), isTrue);
    });

    test('should create generation config for country', () {
      final england = CountryGenerator.getCountryByCode('GB');
      expect(england, isNotNull);
      
      final config = GenerationConfig.defaultForCountry(england!);
      
      expect(config.country, equals(england));
      expect(config.leagueConfig.teamsPerDivision, equals(20));
      expect(config.teamConfig.useRealisticDistribution, isTrue);
      expect(config.playerConfig.domesticPlayerPercentage, equals(75));
    });

    test('should generate team names', () {
      final england = CountryGenerator.getCountryByCode('GB')!;
      final config = GenerationConfig.defaultForCountry(england);
      final teamGen = TeamGenerator(seed: 42); // Fixed seed for reproducible tests
      
      final teams = teamGen.generateTeams(
        country: england,
        config: config.teamConfig,
        count: 5,
      );
      
      expect(teams, hasLength(5));
      expect(teams.every((t) => t.name.isNotEmpty), isTrue);
      expect(teams.every((t) => t.overallRating >= 0), isTrue);
      
      // Check that team names are unique
      final names = teams.map((t) => t.name).toSet();
      expect(names, hasLength(5));
    });

    test('should generate league structure', () {
      final england = CountryGenerator.getCountryByCode('GB')!;
      final config = GenerationConfig.defaultForCountry(england);
      final leagueGen = LeagueGenerator(seed: 42);
      
      final divisions = leagueGen.generateDivisions(
        country: england,
        config: config,
      );
      
      expect(divisions, isNotEmpty);
      expect(divisions.first.name, contains('Premier League'));
      expect(divisions.first.teams, hasLength(20));
      
      if (divisions.length > 1) {
        expect(divisions[1].name, equals('Championship'));
      }
    });

    test('should validate league configuration', () {
      final england = CountryGenerator.getCountryByCode('GB')!;
      final leagueGen = LeagueGenerator();
      
      // Valid config
      final validConfig = LeagueConfig(
        divisions: 4,
        teamsPerDivision: 20,
        generateCups: true,
        nameFormat: 'Premier League',
        historicalYears: 5,
      );
      
      expect(leagueGen.validateLeagueConfig(
        country: england,
        config: validConfig,
      ), isTrue);
      
      // Invalid config (too few teams)
      final invalidConfig = LeagueConfig(
        divisions: 4,
        teamsPerDivision: 5,
        generateCups: true,
        nameFormat: 'Premier League',
        historicalYears: 5,
      );
      
      expect(leagueGen.validateLeagueConfig(
        country: england,
        config: invalidConfig,
      ), isFalse);
    });

    test('should generate players with realistic distributions', () {
      final england = CountryGenerator.getCountryByCode('GB')!;
      final config = GenerationConfig.defaultForCountry(england);
      final playerGen = PlayerGenerator(seed: 42);
      
      final players = playerGen.generatePlayersForTeam(
        country: england,
        config: config.playerConfig,
        squadSize: 25,
      );
      
      expect(players, hasLength(25));
      expect(players.every((p) => p.name.isNotEmpty), isTrue);
      expect(players.every((p) => p.age >= 16 && p.age <= 40), isTrue);
      expect(players.every((p) => p.overallRating >= 20 && p.overallRating <= 95), isTrue);
      
      // Check position distribution
      final positions = players.map((p) => p.position).toList();
      expect(positions.contains(PlayerPosition.goalkeeper), isTrue);
      expect(positions.contains(PlayerPosition.defender), isTrue);
      expect(positions.contains(PlayerPosition.midfielder), isTrue);
      expect(positions.contains(PlayerPosition.forward), isTrue);
    });

    test('should generate stadium data', () {
      final england = CountryGenerator.getCountryByCode('GB')!;
      final config = GenerationConfig.defaultForCountry(england);
      final stadiumGen = StadiumGenerator(seed: 42);
      
      final stadium = stadiumGen.generateStadium(
        country: england,
        config: config.stadiumConfig,
        teamName: 'Manchester United',
        cityName: 'Manchester',
        teamReputation: 85,
      );
      
      expect(stadium['name'], isNotEmpty);
      expect(stadium['capacity'], greaterThan(5000));
      expect(stadium['capacity'], lessThan(80000));
      expect(stadium['city'], equals('Manchester'));
      expect(stadium['country'], equals('GB'));
      expect(stadium['atmosphere'], greaterThanOrEqualTo(40));
      expect(stadium['atmosphere'], lessThanOrEqualTo(95));
    });

    test('should validate player configuration', () {
      final playerGen = PlayerGenerator();
      
      // Valid config
      const validConfig = PlayerConfig.defaultConfig();
      expect(playerGen.validatePlayerConfig(validConfig), isTrue);
      
      // Invalid config (bad age distribution)
      const invalidConfig = PlayerConfig(
        ageDistribution: AgeDistribution(
          minAge: 30,
          maxAge: 20, // Max less than min
          peakAge: 25,
          standardDeviation: 4.5,
        ),
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
      
      expect(playerGen.validatePlayerConfig(invalidConfig), isFalse);
    });
  });
}
