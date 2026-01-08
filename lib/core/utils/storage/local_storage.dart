import "dart:async";

import "package:shared_preferences/shared_preferences.dart";

/// Store simple [Types] locally as key-value pairs.
abstract interface class LocalStorageAbs {
  /// Initialize.
  FutureOr<void> init();

  /// Store the [value] locally paired to [key].
  Future<void> store<T>(final String key, {required T value});

  /// Retrieve the value paired to [key].
  FutureOr<T?> use<T>(final String key);

  /// Remove the value paired to [key].
  Future<void> remove(final String key);

  /// Remove all values.
  Future<void> clearAll();
}

/// For synchronous data retrieval from local storage.
///
/// Example:
/// ```dart
/// await LocalStorageSync.instance.store("user_id", "uuid_for_user_id");
/// final String? user_id = LocalStorageSync.instance.use("user_id");
/// ```
final class LocalStorageSync implements LocalStorageAbs {
  LocalStorageSync._();

  static final LocalStorageSync _instance = LocalStorageSync._();

  factory LocalStorageSync() => _instance;

  static late final SharedPreferences _pref;

  @override
  Future<void> init() async => _pref = await SharedPreferences.getInstance();

  @override
  Future<bool> store<T>(String key, {required T value}) async {
    switch (value) {
      case int _:
        return _pref.setInt(key, value);
      case double _:
        return _pref.setDouble(key, value);
      case String _:
        return _pref.setString(key, value);
      case bool _:
        return _pref.setBool(key, value);
      case List<String> _:
        return _pref.setStringList(key, value);
    }
    throw StateError("Can't store value of type $T");
  }

  @override
  T? use<T>(String key) {
    switch (T) {
      case const (int):
        return _pref.getInt(key) as T?;
      case const (double):
        return _pref.getDouble(key) as T?;
      case const (String):
        return _pref.getString(key) as T?;
      case const (bool):
        return _pref.getBool(key) as T?;
      case const (List<String>):
        return _pref.getStringList(key) as T?;
    }
    throw StateError("Expecting invalid type $T");
  }

  @override
  Future<bool> remove(String key) => _pref.remove(key);

  @override
  Future<void> clearAll() => _pref.clear();
}

/// Wrapper for lazy-loaded local storage values with caching
class LocalValue<T> {
  T? _value;
  final String _key;
  final LocalStorageSync _ls;

  LocalValue({
    T? value,
    required String key,
    required LocalStorageSync ls,
  })  : _ls = ls,
        _key = key,
        _value = value;

  T? get v {
    if (_value != null) return _value!;
    return _value = _ls.use(_key);
  }

  set v(T? v) {
    _value = v;
    _ls.store(_key, value: _value);
  }
}
