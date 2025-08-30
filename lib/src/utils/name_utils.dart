import 'dart:math';

/// Utility class for name generation and manipulation
class NameUtils {
  final Random _random;

  NameUtils({int? seed}) : _random = Random(seed);

  /// Generates a random first name based on language/culture
  String generateFirstName({
    required String language,
    required String gender, // 'male', 'female', 'any'
  }) {
    final names = _getFirstNames(language, gender);
    return names[_random.nextInt(names.length)];
  }

  /// Generates a random last name based on language/culture
  String generateLastName({required String language}) {
    final names = _getLastNames(language);
    return names[_random.nextInt(names.length)];
  }

  /// Generates a full name with proper cultural formatting
  String generateFullName({
    required String language,
    required String gender,
    List<String>? titlePrefixes,
  }) {
    final firstName = generateFirstName(language: language, gender: gender);
    final lastName = generateLastName(language: language);
    
    // Some cultures use title prefixes
    if (titlePrefixes != null && titlePrefixes.isNotEmpty && _random.nextDouble() < 0.1) {
      final title = titlePrefixes[_random.nextInt(titlePrefixes.length)];
      return '$title $firstName $lastName';
    }
    
    return '$firstName $lastName';
  }

  // Private helper methods

  List<String> _getFirstNames(String language, String gender) {
    switch (language.toLowerCase()) {
      case 'en':
        return gender == 'female' 
            ? _englishFemaleNames 
            : gender == 'male' 
              ? _englishMaleNames 
              : [..._englishMaleNames, ..._englishFemaleNames];
      case 'es':
        return gender == 'female' 
            ? _spanishFemaleNames 
            : gender == 'male' 
              ? _spanishMaleNames 
              : [..._spanishMaleNames, ..._spanishFemaleNames];
      default:
        return _englishMaleNames; // Fallback
    }
  }

  List<String> _getLastNames(String language) {
    switch (language.toLowerCase()) {
      case 'en': return _englishLastNames;
      case 'es': return _spanishLastNames;
      default: return _englishLastNames; // Fallback
    }
  }

  // Name databases - simplified for demo purposes
  static const _englishMaleNames = [
    'James', 'John', 'Robert', 'Michael', 'William', 'David', 'Richard', 'Joseph',
    'Thomas', 'Christopher', 'Charles', 'Daniel', 'Matthew', 'Anthony', 'Mark',
    'Steven', 'Paul', 'Andrew', 'Joshua', 'Kenneth', 'Kevin', 'Brian', 'George'
  ];

  static const _englishFemaleNames = [
    'Mary', 'Patricia', 'Jennifer', 'Linda', 'Elizabeth', 'Barbara', 'Susan',
    'Jessica', 'Sarah', 'Karen', 'Nancy', 'Lisa', 'Betty', 'Helen', 'Sandra',
    'Donna', 'Carol', 'Ruth', 'Sharon', 'Michelle', 'Laura', 'Kimberly'
  ];

  static const _englishLastNames = [
    'Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis',
    'Rodriguez', 'Martinez', 'Hernandez', 'Lopez', 'Gonzalez', 'Wilson', 'Anderson',
    'Thomas', 'Taylor', 'Moore', 'Jackson', 'Martin', 'Lee', 'Perez', 'Thompson'
  ];

  static const _spanishMaleNames = [
    'Antonio', 'Jose', 'Manuel', 'Francisco', 'David', 'Juan', 'Javier', 'Daniel',
    'Carlos', 'Miguel', 'Rafael', 'Pedro', 'Angel', 'Alejandro', 'Fernando'
  ];

  static const _spanishFemaleNames = [
    'Maria', 'Carmen', 'Ana', 'Isabel', 'Pilar', 'Dolores', 'Teresa', 'Rosa',
    'Francisca', 'Antonia', 'Mercedes', 'Esperanza', 'Angela', 'Josefa'
  ];

  static const _spanishLastNames = [
    'Garcia', 'Rodriguez', 'Lopez', 'Martinez', 'Gonzalez', 'Hernandez', 'Perez',
    'Sanchez', 'Ramirez', 'Cruz', 'Flores', 'Gomez', 'Diaz', 'Reyes'
  ];
}
