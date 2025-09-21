class UserEntity {
  final String id;
  final String email;
  final String? name;

  UserEntity({required this.name, required this.email, required this.id});

  factory UserEntity.fromApi(Map map) {
    return UserEntity(name: map['name'], email: map['email'], id: map['_id']);
  }
}
