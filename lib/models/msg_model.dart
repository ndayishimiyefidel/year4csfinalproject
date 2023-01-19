class newUserModel {
  final String owner_id;
  final String parent_id;
  final String time;
  final String text;
  final String name;
  final String imageUrl;
  final bool isOnline;

  newUserModel(
      {required this.owner_id,
      required this.parent_id,
      required this.time,
      required this.text,
      required this.name,
      required this.imageUrl,
      required this.isOnline});
}
