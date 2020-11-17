class Camera {
  final bool active;
  final String address;

  const Camera({this.active, this.address});

  Camera.fromJSON(Map<String, dynamic> data)
      : this(
      active: data['active'].toString() == 'true' ? true : false,
      address: data['address'].toString());

  @override
  String toString() => '{active: $active, address: $address}';

  Map<String, dynamic> toJson() => {
    'active':active,
    'address':address,
  };

}