part of yandex_mapkit;

class MasstransitWeight extends Equatable {

  /// Time to travel, not considering traffic.
  final LocalizedValue time;

  /// Distance to travel.
  final LocalizedValue distance;

  MasstransitWeight._(this.time, this.distance);

  factory MasstransitWeight._fromJson(Map<dynamic, dynamic> json) {
    return MasstransitWeight._(
      LocalizedValue._fromJson(json['time']),
      LocalizedValue._fromJson(json['distance']),
    );
  }

  @override
  List<Object> get props => <Object>[
    time,
    distance,
  ];

  @override
  bool get stringify => true;
}