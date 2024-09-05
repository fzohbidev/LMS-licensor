/// Group model that represents a user group in the data layer.
class GroupModel {
  final int id;
  final String name;
  final String description;

  // Constructor for creating a GroupModel instance.
  GroupModel({
    required this.id,
    required this.name,
    required this.description,
  });

  // Factory constructor to create a GroupModel instance from a JSON object.
  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  // Method to convert a GroupModel instance into a JSON object.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  @override
  // Equatable properties to compare instances.
  List<Object> get props => [id, name, description];
}
