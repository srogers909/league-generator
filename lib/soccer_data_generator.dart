/// A comprehensive data generation module for soccer simulation games
library tactics_fc_generator;

// Export models
export 'src/models/country.dart';
export 'src/models/generation_config.dart';

// Export generators (will be implemented)
export 'src/generators/country_generator.dart';
export 'src/generators/league_generator.dart';
export 'src/generators/team_generator.dart';
export 'src/generators/player_generator.dart';
export 'src/generators/stadium_generator.dart';

// Export data repositories
export 'src/data/countries/country_repository.dart';
export 'src/data/names/name_repository.dart';

// Export utilities
export 'src/utils/generation_utils.dart';
export 'src/utils/name_utils.dart';
