/// Repository for name data used in generation
class NameRepository {
  
  /// Gets first names for a specific language and gender
  static List<String> getFirstNames({
    required String language,
    required String gender,
  }) {
    final allNames = _firstNamesByLanguage[language] ?? _firstNamesByLanguage['en']!;
    
    switch (gender.toLowerCase()) {
      case 'male':
        return allNames['male'] ?? [];
      case 'female':
        return allNames['female'] ?? [];
      case 'any':
      default:
        return [...(allNames['male'] ?? []), ...(allNames['female'] ?? [])];
    }
  }

  /// Gets last names for a specific language
  static List<String> getLastNames(String language) {
    return _lastNamesByLanguage[language] ?? _lastNamesByLanguage['en']!;
  }

  /// Gets city names for a specific country
  static List<String> getCityNames(String countryCode) {
    return _citiesByCountry[countryCode] ?? _citiesByCountry['default']!;
  }

  // Private data storage
  static const Map<String, Map<String, List<String>>> _firstNamesByLanguage = {
    'en': {
      'male': [
        'James', 'John', 'Robert', 'Michael', 'William', 'David', 'Richard', 'Joseph',
        'Thomas', 'Christopher', 'Charles', 'Daniel', 'Matthew', 'Anthony', 'Mark',
        'Steven', 'Paul', 'Andrew', 'Joshua', 'Kenneth', 'Kevin', 'Brian', 'George'
      ],
      'female': [
        'Mary', 'Patricia', 'Jennifer', 'Linda', 'Elizabeth', 'Barbara', 'Susan',
        'Jessica', 'Sarah', 'Karen', 'Nancy', 'Lisa', 'Betty', 'Helen', 'Sandra',
        'Donna', 'Carol', 'Ruth', 'Sharon', 'Michelle', 'Laura', 'Kimberly'
      ]
    },
    'es': {
      'male': [
        'Antonio', 'Jose', 'Manuel', 'Francisco', 'David', 'Juan', 'Javier', 'Daniel',
        'Carlos', 'Miguel', 'Rafael', 'Pedro', 'Angel', 'Alejandro', 'Fernando'
      ],
      'female': [
        'Maria', 'Carmen', 'Ana', 'Isabel', 'Pilar', 'Dolores', 'Teresa', 'Rosa',
        'Francisca', 'Antonia', 'Mercedes', 'Esperanza', 'Angela', 'Josefa'
      ]
    },
  };

  static const Map<String, List<String>> _lastNamesByLanguage = {
    'en': [
      'Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis',
      'Rodriguez', 'Martinez', 'Hernandez', 'Lopez', 'Gonzalez', 'Wilson', 'Anderson',
      'Thomas', 'Taylor', 'Moore', 'Jackson', 'Martin', 'Lee', 'Perez', 'Thompson'
    ],
    'es': [
      'Garcia', 'Rodriguez', 'Lopez', 'Martinez', 'Gonzalez', 'Hernandez', 'Perez',
      'Sanchez', 'Ramirez', 'Cruz', 'Flores', 'Gomez', 'Diaz', 'Reyes'
    ],
  };

  static const Map<String, List<String>> _citiesByCountry = {
    'GB': [
      'London', 'Manchester', 'Liverpool', 'Birmingham', 'Leeds', 'Sheffield', 
      'Bristol', 'Newcastle', 'Brighton', 'Southampton'
    ],
    'ES': [
      'Madrid', 'Barcelona', 'Sevilla', 'Valencia', 'Bilbao', 'Málaga', 
      'Zaragoza', 'Las Palmas', 'Granada', 'Getafe'
    ],
    'DE': [
      'Berlin', 'München', 'Hamburg', 'Köln', 'Frankfurt', 'Stuttgart', 
      'Düsseldorf', 'Dortmund', 'Essen', 'Bremen'
    ],
    'default': [
      'Capital City', 'Port City', 'Mountain View', 'River City', 'Central City',
      'East City', 'West City', 'North City', 'South City', 'Old Town'
    ],
  };
}
