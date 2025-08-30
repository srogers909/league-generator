# ⚽ Soccer Data Generator

A comprehensive and sophisticated data generation module for soccer simulation games built in Dart. Generate realistic leagues, teams, players, and stadiums with culturally authentic data and advanced statistical distributions.

[![Dart](https://img.shields.io/badge/Dart-3.8+-blue.svg)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Tests](https://img.shields.io/badge/Tests-Passing-brightgreen.svg)](test/)

## 🌟 Features

### 🏆 Comprehensive League Generation
- **Multi-Country Support**: Built-in support for 20+ countries with authentic league structures
- **Realistic Divisions**: Generate multiple divisions with proper team counts and hierarchies
- **Cup Competitions**: Automatically generate domestic cups and league cups
- **Historical Data**: Create leagues with configurable historical depth

### 🏟️ Advanced Team Generation
- **Reputation-Based Attributes**: Teams have realistic reputation ranges (30-85)
- **Geographic Distribution**: Teams distributed across major cities within countries
- **Cultural Authenticity**: Traditional naming patterns for each country
- **Stadium Integration**: Each team gets a uniquely generated stadium

### 👥 Sophisticated Player Generation
- **Variable Squad Sizes**: Teams have different squad sizes (18-32 players) based on reputation
- **Realistic Age Distribution**: Statistical age curves with configurable parameters
- **Skill Distributions**: Advanced skill generation with proper statistical spread
- **Position Accuracy**: Realistic position distributions for authentic team compositions
- **Domestic/International Mix**: Configurable percentages of domestic vs international players

### 🏟️ Stadium Generation
- **Capacity Realism**: Stadium capacities based on real-world distributions
- **Historical Context**: Optional generation of stadium histories and renovations
- **Team Correlation**: Stadium sizes correlate with team reputation and city size

### ⚙️ Advanced Configuration System
- **Granular Control**: Fine-tune every aspect of generation
- **Country-Specific Defaults**: Pre-configured settings for different countries
- **Reproducible Generation**: Seed-based generation for consistent results
- **JSON Serialization**: Save and load generation configurations

## 🚀 Quick Start

### Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  soccer_data_generator:
    path: ../generator  # Adjust path as needed
```

### Basic Usage

```dart
import 'package:soccer_data_generator/soccer_data_generator.dart';

void main() async {
  // Get a country (Brazil in this example)
  final country = CountryRepository.getCountryByCode('BR')!;
  
  // Create default configuration
  final config = GenerationConfig.defaultForCountry(country);
  
  // Generate a complete league
  final leagueGenerator = LeagueGenerator(seed: 42);
  final league = await leagueGenerator.generateCompleteLeague(
    country: country,
    config: config,
  );
  
  print('Generated ${league.name}');
  print('Teams: ${league.teams.length}');
  
  // Check squad sizes (will vary between teams!)
  for (final team in league.teams) {
    print('${team.name}: ${team.players.length} players');
  }
}
```

## 📖 Detailed Usage

### Country Selection

The generator supports multiple countries with authentic soccer cultures:

```dart
// Get all available countries
final allCountries = CountryGenerator.getAllCountries();

// Get countries with strong soccer traditions
final strongSoccerCountries = CountryGenerator.getStrongSoccerCountries();

// Get specific country
final brazil = CountryRepository.getCountryByCode('BR')!;
final england = CountryRepository.getCountryByCode('GB')!;
final germany = CountryRepository.getCountryByCode('DE')!;
```

**Supported Countries:**
- 🇧🇷 Brazil (`BR`) - Série A, Série B, traditional Brazilian naming
- 🏴󠁧󠁢󠁥󠁮󠁧󠁿 England (`GB`) - Premier League, Championship, League One, League Two
- 🇩🇪 Germany (`DE`) - Bundesliga, 2. Bundesliga, 3. Liga
- 🇪🇸 Spain (`ES`) - La Liga, Segunda División
- 🇮🇹 Italy (`IT`) - Serie A, Serie B, Serie C
- 🇫🇷 France (`FR`) - Ligue 1, Ligue 2
- 🇦🇷 Argentina (`AR`) - Primera División, Primera B Nacional
- And many more...

### Variable Squad Size System 🔥

One of the most exciting features is the **Variable Squad Size System**, which creates realistic squad variations:

```dart
final config = GenerationConfig.defaultForCountry(country);

// Variable squad sizes are enabled by default
print('Variable squads: ${config.playerConfig.useVariableSquadSizes}'); // true
print('Size range: ${config.playerConfig.minSquadSize}-${config.playerConfig.maxSquadSize}'); // 18-32
print('Reputation influence: ${config.playerConfig.reputationInfluence}'); // 0.6

final league = await leagueGenerator.generateCompleteLeague(
  country: country,
  config: config,
);

// Results in varied squad sizes like:
// Manchester City: 28 players (high reputation = larger squad)
// Burnley: 19 players (lower reputation = smaller squad)
// Liverpool: 27 players
// Brighton: 21 players
```

#### How Variable Squad Sizes Work

1. **Team Reputation**: Each team gets a reputation score (30-85)
2. **Reputation Influence**: Higher reputation → larger squad (configurable 0.0-1.0)
3. **Statistical Distribution**: Uses normal distribution with random variation
4. **Realistic Bounds**: Ensures all squads stay within 18-32 player range
5. **Authentic Results**: Creates "shallow" and "bloated" squads naturally

### Custom Configuration

Create highly customized generation parameters:

```dart
final customConfig = GenerationConfig(
  country: country,
  leagueConfig: LeagueConfig(
    divisions: 4,              // Generate 4 divisions
    teamsPerDivision: 20,      // 20 teams per division
    generateCups: true,        // Include cup competitions
    nameFormat: 'Custom League',
    historicalYears: 10,       // 10 years of history
  ),
  teamConfig: TeamConfig(
    useRealisticDistribution: true,
    minReputation: 25,         // Lower minimum reputation
    maxReputation: 90,         // Higher maximum reputation
    generateHistory: true,
    useTraditionalNames: true,
  ),
  playerConfig: PlayerConfig(
    ageDistribution: AgeDistribution(
      minAge: 16,
      maxAge: 40,
      peakAge: 26,
      standardDeviation: 4.5,
    ),
    skillDistribution: SkillDistribution(
      meanSkill: 60.0,          // Slightly higher average skill
      standardDeviation: 12.0,
      minSkill: 25,
      maxSkill: 95,
    ),
    domesticPlayerPercentage: 80,  // 80% domestic players
    useVariableSquadSizes: true,   // Enable variable squad sizes
    minSquadSize: 20,              // Minimum 20 players
    maxSquadSize: 30,              // Maximum 30 players
    averageSquadSize: 25,          // Average of 25 players
    reputationInfluence: 0.7,      // Strong reputation influence
    generatePersonalities: true,
    useRealisticPositions: true,
  ),
  stadiumConfig: StadiumConfig(
    minCapacity: 8000,
    maxCapacity: 75000,
    useRealisticCapacities: true,
    generateHistory: true,
  ),
  seed: 12345,  // For reproducible results
);
```

### Individual Component Generation

Generate specific components independently:

#### Teams Only
```dart
final teamGenerator = TeamGenerator(seed: 42);
final teams = teamGenerator.generateTeams(
  country: country,
  config: config.teamConfig,
  count: 20,
);
```

#### Players for a Specific Team
```dart
final playerGenerator = PlayerGenerator(seed: 42);
final players = playerGenerator.generatePlayersForTeam(
  country: country,
  config: config.playerConfig,
  squadSize: 25,  // Or use generateSquadSize for variable sizes
);
```

#### Variable Squad Size Calculation
```dart
final teamReputation = 75;  // High reputation team
final squadSize = playerGenerator.generateSquadSize(
  teamReputation: teamReputation,
  config: config.playerConfig,
);
print('Squad size for reputation $teamReputation: $squadSize players');
// Output: Squad size for reputation 75: 27 players
```

#### Stadiums
```dart
final stadiumGenerator = StadiumGenerator(seed: 42);
final stadium = stadiumGenerator.generateStadium(
  country: country,
  config: config.stadiumConfig,
  teamReputation: 75,
);
```

## 🔧 Configuration Reference

### GenerationConfig
The main configuration class that orchestrates all generation settings.

```dart
class GenerationConfig {
  final Country country;           // Target country
  final LeagueConfig leagueConfig; // League settings
  final TeamConfig teamConfig;     // Team settings
  final PlayerConfig playerConfig; // Player settings
  final StadiumConfig stadiumConfig; // Stadium settings
  final int? seed;                 // Random seed
}
```

### LeagueConfig
Controls league structure and competition generation.

| Property | Default | Description |
|----------|---------|-------------|
| `divisions` | Country-specific | Number of professional divisions |
| `teamsPerDivision` | Country-specific | Teams in top division |
| `generateCups` | `true` | Generate domestic cup competitions |
| `nameFormat` | `"{Country} Premier League"` | League naming pattern |
| `historicalYears` | `5` | Years of historical data |

### TeamConfig
Controls team generation and characteristics.

| Property | Default | Description |
|----------|---------|-------------|
| `useRealisticDistribution` | `true` | Distribute teams geographically |
| `minReputation` | `30` | Minimum team reputation (0-100) |
| `maxReputation` | `85` | Maximum team reputation (0-100) |
| `generateHistory` | `true` | Generate team histories |
| `useTraditionalNames` | `true` | Use cultural naming patterns |

### PlayerConfig ⭐
The most comprehensive configuration with advanced features.

| Property | Default | Description |
|----------|---------|-------------|
| `useVariableSquadSizes` | `true` | 🔥 Enable different squad sizes per team |
| `minSquadSize` | `18` | Minimum players in any squad |
| `maxSquadSize` | `32` | Maximum players in any squad |
| `averageSquadSize` | `25` | Target average across all teams |
| `reputationInfluence` | `0.6` | How much reputation affects squad size (0.0-1.0) |
| `domesticPlayerPercentage` | `75` | Percentage of domestic players |
| `useRealisticPositions` | `true` | Realistic position distributions |
| `generatePersonalities` | `true` | Generate player personalities |

### AgeDistribution
Controls player age generation using statistical distributions.

| Property | Default | Description |
|----------|---------|-------------|
| `minAge` | `16` | Minimum player age |
| `maxAge` | `40` | Maximum player age |
| `peakAge` | `26` | Peak of age distribution curve |
| `standardDeviation` | `4.5` | Spread of age distribution |

### SkillDistribution
Controls player skill generation with realistic curves.

| Property | Default | Description |
|----------|---------|-------------|
| `meanSkill` | `55.0` | Average skill level (0-100) |
| `standardDeviation` | `15.0` | Skill distribution spread |
| `minSkill` | `20` | Minimum skill level |
| `maxSkill` | `95` | Maximum skill level |

## 🧪 Testing and Examples

### Running Tests

The project includes comprehensive tests demonstrating all features:

```bash
# Run all tests
dart test

# Run specific test suites
dart test test/generator_basic_test.dart      # Basic functionality
dart test test/variable_squad_test.dart       # Variable squad sizes
dart test test/integration_test.dart          # Integration tests
dart test test/complete_system_test.dart      # Full system demo
```

### Example: Variable Squad Size Demo

Run the complete system test to see variable squad sizes in action:

```bash
dart test test/complete_system_test.dart
```

**Sample Output:**
```
=== Variable Squad Size System Demo ===

Country: Brazil
Configuration:
  - Variable Squad Sizes: true
  - Min Squad Size: 18
  - Max Squad Size: 32
  - Average Squad Size: 25
  - Reputation Influence: 0.6

Generated Teams and Squad Sizes:
══════════════════════════════════════════════════
São Paulo FC              | 28 players
Flamengo                  | 27 players
Santos                    | 26 players
Grêmio                    | 24 players
...
Curitiba EC               | 19 players
Salvador                  | 18 players

══════════════════════════════════════════════════
RESULTS SUMMARY:
Total Teams: 20
Total Players: 458
Average Squad Size: 22.9
Smallest Squad: 18 players (Salvador)
Largest Squad: 28 players (São Paulo FC)
✓ Variable squad sizes: YES
✓ Has "shallow" squads (≤20): YES
✓ Has "bloated" squads (≥26): YES
```

## 🔄 Integration with UI

The generator integrates seamlessly with the Flutter UI and BLoC architecture:

```dart
// In your BLoC
final league = await _leagueGenerator.generateCompleteLeague(
  country: selectedCountry,
  config: config,
);

// UI displays variable squad information automatically
final displayText = config.playerConfig.useVariableSquadSizes 
    ? '${config.playerConfig.minSquadSize}-${config.playerConfig.maxSquadSize} players (varies by team reputation)'
    : '${config.playerConfig.averageSquadSize} players (fixed)';
// Output: "18-32 players (varies by team reputation)"
```

## 🎯 Best Practices

### Performance Tips
- Use seeds for reproducible generation during testing
- Generate data in batches for large datasets
- Cache country data to avoid repeated lookups

### Realistic Configuration
- Keep reputation ranges between 30-85 for realism
- Use default age/skill distributions unless specific needs
- Enable variable squad sizes for authentic team variation
- Set domestic player percentage based on country's import/export rules

### Memory Management
- Generate leagues incrementally for large datasets
- Dispose of generators when no longer needed
- Use appropriate squad size ranges to control memory usage

## 🤝 Contributing

We welcome contributions! Here's how to get started:

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/amazing-feature`
3. **Make your changes** and add tests
4. **Run the test suite**: `dart test`
5. **Commit your changes**: `git commit -m 'Add amazing feature'`
6. **Push to the branch**: `git push origin feature/amazing-feature`
7. **Open a Pull Request**

### Development Setup

```bash
# Clone the repository
git clone <repository-url>
cd soccer-engine-dart-full/generator

# Install dependencies
dart pub get

# Run code generation
dart run build_runner build

# Run tests
dart test
```

### Adding New Countries

To add support for a new country:

1. Add country data to `src/data/countries/`
2. Update `CountryRepository` with the new country
3. Add appropriate naming patterns in `src/data/names/`
4. Add tests for the new country
5. Update documentation

### Testing Guidelines

- Write tests for all new features
- Include integration tests for complex functionality
- Test with multiple countries and configurations
- Verify statistical distributions are reasonable

## 📋 Roadmap

### Version 1.1.0 Goals
- Player contract generation
- Advanced stadium features (naming, location data)
- Performance optimizations for large leagues
- Export/import functionality for generated data

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- **Documentation**: Check this README and inline code documentation
- **Issues**: Report bugs or request features via GitHub Issues
- **Testing**: Run `dart test test/complete_system_test.dart` for a full demo
- **Examples**: Check the `test/` directory for comprehensive examples
