class UserEntity {
  final String id;
  final String email;
  final String? name;
  final String username;
  final String avatarUrl;

  UserEntity({
    required this.name,
    required this.email,
    required this.id,
    this.username = "evgeni",
    this.avatarUrl = "",
  });

  factory UserEntity.fromApi(Map map) {
    return UserEntity(name: map['name'], email: map['email'], id: map['_id']);
  }
}
