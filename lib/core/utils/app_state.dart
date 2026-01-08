/// Base sealed class for representing app state in Bloc pattern
sealed class AppState<T> {
  const AppState();
}

/// Loading state - when data is being fetched
final class Loading<T> extends AppState<T> {
  const Loading();
}

/// Loaded state - when data has been successfully fetched
final class Loaded<T> extends AppState<T> {
  final T data;

  const Loaded({required this.data});
}

/// Error state - when an error occurred
final class Error<T> extends AppState<T> {
  final String message;

  const Error({required this.message});
}
