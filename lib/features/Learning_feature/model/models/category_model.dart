class CategoryModel {
  String? playlistId;
  String? title;
  String? thumbnail;

  CategoryModel({
    this.playlistId,
    this.title,
    this.thumbnail,
  });
  CategoryModel.fromJson( Map<String, dynamic> json) {
    playlistId = json['playlistId'];
    title = json['title'];
    thumbnail = json['thumbnail'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['playlistId'] = playlistId;
    data['title'] = title;
    data['thumbnail'] = thumbnail;
    return data;
  }

}