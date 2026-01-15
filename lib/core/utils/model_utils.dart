class ModelUtils {
  /// Convert raw model output to readable text
  static String processModelOutput(List<dynamic> output) {
    if (output.isEmpty) return '';
    return output.join(' ').replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  /// Normalize tensor values
  static List<double> normalizeTensor(List<dynamic> tensor) {
    final values = tensor.map((e) => (e as num).toDouble()).toList();
    final max = values.reduce((a, b) => a > b ? a : b);
    final min = values.reduce((a, b) => a < b ? a : b);
    final range = max - min;

    if (range == 0) {
      return List<double>.filled(values.length, 0.0);
    }

    return values.map((v) => (v - min) / range).toList();
  }

  /// Apply softmax to output probabilities
  static List<double> softmax(List<double> logits) {
    final maxLogit = logits.reduce((a, b) => a > b ? a : b);
    final expValues = logits.map((x) {
      return 2.718281828459045 * (x - maxLogit);
    }).toList();
    final sum = expValues.reduce((a, b) => a + b);
    return expValues.map((x) => x / sum).toList();
  }

  /// Get top N predictions
  static List<Map<String, dynamic>> getTopPredictions(
    List<double> probabilities, {
    int topN = 5,
  }) {
    final predictions = <Map<String, dynamic>>[];

    for (int i = 0; i < probabilities.length; i++) {
      predictions.add({
        'index': i,
        'probability': probabilities[i],
      });
    }

    predictions.sort(
      (a, b) => (b['probability'] as double).compareTo(a['probability'] as double),
    );

    return predictions.take(topN).toList();
  }

  /// Check if tensor is valid
  static bool isValidTensor(List<dynamic> tensor) {
    if (tensor.isEmpty) return false;
    return tensor.every((element) => element is num);
  }

  /// Flatten tensor
  static List<double> flattenTensor(List<dynamic> tensor) {
    final flattened = <double>[];

    void flatten(dynamic value) {
      if (value is List) {
        for (final item in value) {
          flatten(item);
        }
      } else if (value is num) {
        flattened.add(value.toDouble());
      }
    }

    flatten(tensor);
    return flattened;
  }
}
