part of yandex_mapkit;

/// Driving route.
/// A route consists of multiple sections
/// Each section has a corresponding annotation that describes the action at the beginning of the section.
class MasstransitRoute extends Equatable {

  /// Route geometry.
  final List<Point> geometry;

  /// The route metadata.
  final MasstransitWeight weight;

  const MasstransitRoute._(this.geometry, this.weight);

  factory MasstransitRoute._fromJson(Map<dynamic, dynamic> json) {
    return MasstransitRoute._(
      Polyline._fromJson(json['polyline']).points,
      MasstransitWeight._fromJson(json['weight']),
    );
  }

  @override
  List<Object> get props => <Object>[
    geometry,
    weight,
  ];

  @override
  bool get stringify => true;
}