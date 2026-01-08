typedef LazyInterface<T> = Map<Type, T Function()>;

/// Dependency injection container for managing app dependencies
class AppInjector {
  const AppInjector._();

  /// The static storage of all the lazy interfaces.
  static final LazyInterface _lazy = LazyInterface();

  /// The static storage of all the singletons.
  static final Map<Type, dynamic> _singleton = <Type, dynamic>{};

  /// Register a lazy interface.
  static void lazy<T extends Object>(T Function() callback) {
    _lazy[T] = callback;
    return;
  }

  /// Register a singleton.
  static void singleton<T extends Object>(final T instance) {
    _singleton[T] = instance;
  }

  /// Get the instance of a registered lazy interface.
  static T get<T>() {
    final T? instance = _lazy[T]?.call() ?? _singleton[T];
    if (instance == null) throw StateError("Register [$T] before accessing it");
    return instance;
  }
}
