class CategoryModel {
  String? playlistId;
  String? title;
  String? thumbnail;
  // DateTime? timestamp;

  CategoryModel({
    this.playlistId,
    this.title,
    this.thumbnail,
    // this.timestamp,
  });
  CategoryModel.fromJson( Map<String, dynamic> json) {
    playlistId = json['playlistId'];
    title = json['title'];
    thumbnail = json['thumbnail'];
    // timestamp = json['timestamp'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['playlistId'] = playlistId;
    data['title'] = title;
    data['thumbnail'] = thumbnail;
   // data['timestamp'] = timestamp;
    return data;
  }

}