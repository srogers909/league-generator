import 'dart:math';

/// Utility class for common generation operations
class GenerationUtils {
  final Random _random;

  GenerationUtils({int? seed}) : _random = Random(seed);

  /// Generates a unique ID string
  String generateId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final length = 12;
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(_random.nextInt(chars.length)),
      ),
    );
  }

  /// Generates a random integer using normal distribution
  int generateNormalInt({
    required double mean,
    required double standardDeviation,
    required int min,
    required int max,
  }) {
    final normalValue = _generateNormal(mean, standardDeviation);
    final clampedValue = normalValue.clamp(min.toDouble(), max.toDouble());
    return clampedValue.round();
  }

  /// Generates a random double using normal distribution
  double generateNormalDouble({
    required double mean,
    required double standardDeviation,
    required double min,
    required double max,
  }) {
    final normalValue = _generateNormal(mean, standardDeviation);
    return normalValue.clamp(min, max);
  }

  double? _nextGaussian;

  /// Generates a value using normal distribution (Box-Muller transform)
  double _generateNormal(double mean, double standardDeviation) {
    // Box-Muller transform for normal distribution
    if (_nextGaussian != null) {
      final result = _nextGaussian! * standardDeviation + mean;
      _nextGaussian = null;
      return result;
    }

    final u1 = _random.nextDouble();
    final u2 = _random.nextDouble();
    
    final z0 = sqrt(-2.0 * log(u1)) * cos(2.0 * pi * u2);
    final z1 = sqrt(-2.0 * log(u1)) * sin(2.0 * pi * u2);
    
    _nextGaussian = z1;
    return z0 * standardDeviation + mean;
  }

  /// Generates a weighted random choice from a list of options
  T weightedChoice<T>(List<T> options, List<double> weights) {
    assert(options.length == weights.length, 'Options and weights must have same length');
    assert(weights.every((w) => w >= 0), 'All weights must be non-negative');
    
    final totalWeight = weights.reduce((a, b) => a + b);
    assert(totalWeight > 0, 'Total weight must be positive');
    
    final randomValue = _random.nextDouble() * totalWeight;
    double currentWeight = 0;
    
    for (int i = 0; i < options.length; i++) {
      currentWeight += weights[i];
      if (randomValue <= currentWeight) {
        return options[i];
      }
    }
    
    // Fallback (should never reach here with valid weights)
    return options.last;
  }

  /// Generates a random value within a range using different distribution types
  double generateDistributedValue({
    required double min,
    required double max,
    DistributionType distribution = DistributionType.uniform,
    double? parameter,
  }) {
    switch (distribution) {
      case DistributionType.uniform:
        return min + _random.nextDouble() * (max - min);
      
      case DistributionType.normal:
        final mean = (min + max) / 2;
        final stdDev = parameter ?? (max - min) / 4;
        return generateNormalDouble(
          mean: mean,
          standardDeviation: stdDev,
          min: min,
          max: max,
        );
      
      case DistributionType.exponential:
        final lambda = parameter ?? 1.0;
        final exponentialValue = -log(_random.nextDouble()) / lambda;
        final normalizedValue = exponentialValue / 5.0; // Normalize to roughly 0-1
        return min + normalizedValue.clamp(0.0, 1.0) * (max - min);
      
      case DistributionType.beta:
        final alpha = parameter ?? 2.0;
        final beta = parameter ?? 2.0;
        final betaValue = _generateBeta(alpha, beta);
        return min + betaValue * (max - min);
    }
  }

  /// Generates a beta-distributed random variable
  double _generateBeta(double alpha, double beta) {
    // Simple implementation using gamma distributions
    final x = _generateGamma(alpha);
    final y = _generateGamma(beta);
    return x / (x + y);
  }

  /// Generates a gamma-distributed random variable
  double _generateGamma(double shape) {
    // Marsaglia and Tsang's method for shape >= 1
    if (shape >= 1.0) {
      final d = shape - 1.0 / 3.0;
      final c = 1.0 / sqrt(9.0 * d);
      
      while (true) {
        double x, v;
        do {
          x = _generateNormal(0, 1);
          v = 1.0 + c * x;
        } while (v <= 0);
        
        v = v * v * v;
        final u = _random.nextDouble();
        
        if (u < 1.0 - 0.0331 * x * x * x * x) {
          return d * v;
        }
        
        if (log(u) < 0.5 * x * x + d * (1.0 - v + log(v))) {
          return d * v;
        }
      }
    } else {
      // For shape < 1, use acceptance-rejection
      final gamma1 = _generateGamma(shape + 1.0);
      return gamma1 * pow(_random.nextDouble(), 1.0 / shape);
    }
  }

  /// Shuffles a list in place
  void shuffle<T>(List<T> list) {
    for (int i = list.length - 1; i > 0; i--) {
      final j = _random.nextInt(i + 1);
      final temp = list[i];
      list[i] = list[j];
      list[j] = temp;
    }
  }

  /// Returns a random subset of a list
  List<T> randomSubset<T>(List<T> list, int count) {
    assert(count <= list.length, 'Cannot select more items than available');
    final shuffled = List<T>.from(list);
    shuffle(shuffled);
    return shuffled.take(count).toList();
  }

  /// Generates a random boolean with given probability of being true
  bool randomBool([double probability = 0.5]) {
    return _random.nextDouble() < probability;
  }

  /// Generates a random date within a range
  DateTime randomDate(DateTime start, DateTime end) {
    final startMs = start.millisecondsSinceEpoch;
    final endMs = end.millisecondsSinceEpoch;
    final randomMs = startMs + _random.nextInt(endMs - startMs);
    return DateTime.fromMillisecondsSinceEpoch(randomMs);
  }
}

/// Enum for different distribution types
enum DistributionType {
  uniform,
  normal,
  exponential,
  beta,
}
