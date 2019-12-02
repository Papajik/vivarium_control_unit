enum Condition { good, bad }

class Location {
  final String id;
  final String name;
  final Condition condition;

  const Location({this.id, this.name, this.condition});

  Location.fromMap(Map<String, dynamic> data, String id)
      : this(
            id: id,
            name: data["name"],
            condition: Condition.values[data["condition"]]);
}
