/// List extension'ları
extension ListExtensions<T> on List<T> {
  /// İlk elemanı döner, yoksa null
  T? get firstOrNull => isEmpty ? null : first;

  /// Son elemanı döner, yoksa null
  T? get lastOrNull => isEmpty ? null : last;

  /// Şarta uyan ilk elemanı döner, yoksa null
  T? firstWhereOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }

  /// Index güvenli erişim
  T? elementAtOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }

  /// Listeyi gruplara ayırır
  Map<K, List<T>> groupBy<K>(K Function(T) keyFunction) {
    final map = <K, List<T>>{};
    for (final element in this) {
      final key = keyFunction(element);
      map.putIfAbsent(key, () => []).add(element);
    }
    return map;
  }

  /// Belirtilen sayıda parçaya böler
  List<List<T>> chunk(int size) {
    final chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      chunks.add(sublist(i, i + size > length ? length : i + size));
    }
    return chunks;
  }

  /// Tekrarlayan elemanları kaldırır
  List<T> unique([Object Function(T)? keyFunction]) {
    if (keyFunction == null) {
      return toSet().toList();
    }
    final seen = <Object>{};
    return where((element) => seen.add(keyFunction(element))).toList();
  }
}

/// Nullable List extension'ları
extension NullableListExtensions<T> on List<T>? {
  /// Null veya boş mu?
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Null veya boş değil mi?
  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;

  /// Null ise boş liste döner
  List<T> orEmpty() => this ?? [];
}

