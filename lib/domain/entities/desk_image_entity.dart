class DeskImageEntity {
  final String? id;
  final String imageUrl;
  final String caption;
  final String deskId;
  final double? rotation;
  DeskImageEntity({
    required this.imageUrl,
    required this.caption,
    required this.deskId,
    this.id,
    this.rotation,
  });

  factory DeskImageEntity.fromApi(Map map) {
    return DeskImageEntity(
      imageUrl: map['imageUrl'],
      caption: map['caption'],
      deskId: map['deskId'],
      id: map['_id'],
      rotation: map['rotation'],
    );
  }
}
