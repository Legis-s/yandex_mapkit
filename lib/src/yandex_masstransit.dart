part of yandex_mapkit;

/// Interface for the Bicycle router.
class YandexMasstransit {
  static const String _channelName = 'yandex_mapkit/yandex_masstransit';
  static const MethodChannel _channel = MethodChannel(_channelName);

  static int _nextSessionId = 0;

  /// Builds a route.
  static MasstransitResultWithSession requestRoutes({
    required List<RequestPoint> points
  }) {
    final params = <String, dynamic>{
      'sessionId': _nextSessionId++,
      'points': points.map((RequestPoint requestPoint) => requestPoint.toJson()).toList(),
    };
    final result = _channel
        .invokeMethod('requestRoutes', params)
        .then((result) => MasstransitSessionResult._fromJson(result));

    return MasstransitResultWithSession._(
        session: MasstransitSession._(id: params['sessionId']),
        result: result
    );
  }
}
