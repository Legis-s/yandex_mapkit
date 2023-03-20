part of yandex_mapkit;

class MasstransitSession {
  static const String _methodChannelName = 'yandex_mapkit/yandex_masstransit_session_';
  final MethodChannel _methodChannel;

  /// Unique session identifier
  final int id;
  bool _isClosed = false;

  /// Has the current session been closed
  bool get isClosed => _isClosed;

  MasstransitSession._({required this.id}) :
        _methodChannel = MethodChannel(_methodChannelName + id.toString());

  /// Retries current session
  ///
  /// After [MasstransitSession.close] has been called, all subsequent calls will return a [MasstransitSessionException]
  Future<void> retry() async {
    if (_isClosed) {
      throw MasstransitSessionException._('Session is closed');
    }

    await _methodChannel.invokeMethod<void>('retry');
  }

  /// Cancels current session
  ///
  /// After [MasstransitSession.close] has been called, all subsequent calls will return a [MasstransitSessionException]
  Future<void> cancel() async {
    if (_isClosed) {
      throw MasstransitSessionException._('Session is closed');
    }

    await _methodChannel.invokeMethod<void>('cancel');
  }

  /// Closes current session
  ///
  /// After first call, all subsequent calls will return a [MasstransitSessionException]
  Future<void> close() async {
    if (_isClosed) {
      throw MasstransitSessionException._('Session is closed');
    }

    await _methodChannel.invokeMethod<void>('close');

    _isClosed = true;
  }
}

class MasstransitSessionException extends SessionException {
  MasstransitSessionException._(String message) : super._(message);
}

/// Result of a request to build routes
/// If any error has occured then [routes] will be empty, otherwise [error] will be empty
class MasstransitSessionResult {
  /// Calculated routes
  final List<MasstransitRoute>? routes;

  /// Error message
  final String? error;

  MasstransitSessionResult._(this.routes, this.error);

  factory MasstransitSessionResult._fromJson(Map<dynamic, dynamic> json) {
    print(json);
    return MasstransitSessionResult._(
        json['routes']?.map<MasstransitRoute>((dynamic route) => MasstransitRoute._fromJson(route)).toList(),
        json['error']
    );
  }
}

/// Object containing the result of a route building request and
/// a [session] object for further working with newly made request
class MasstransitResultWithSession {
  /// Created session
  MasstransitSession session;

  /// Request result
  Future<MasstransitSessionResult> result;

  MasstransitResultWithSession._({
    required this.session,
    required this.result
  });
}