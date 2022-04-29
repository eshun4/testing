// ignore_for_file: file_names, unnecessary_this, prefer_collection_literals, unnecessary_new

class Podcast {
  String? name;
  String? podUrl;
  String? album;
  String? imageUrl;
  String? imgColor;
  String? description;
  List<String>? images;
  String? youTubeURL;
  String? script;

  Podcast(
      {this.name,
      this.podUrl,
      this.album,
      this.imageUrl,
      this.imgColor,
      this.description,
      this.images,
      this.youTubeURL,
      this.script});

  Podcast.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    podUrl = json['pod_url'];
    album = json['album'];
    imageUrl = json['image_Url'];
    imgColor = json['img_color'];
    description = json['description'];
    images = json['images'].cast<String>();
    youTubeURL = json['youTubeURL'];
    script = json['script'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['pod_url'] = this.podUrl;
    data['album'] = this.album;
    data['image_Url'] = this.imageUrl;
    data['img_color'] = this.imgColor;
    data['description'] = this.description;
    data['images'] = this.images;
    data['youTubeURL'] = this.youTubeURL;
    data['script'] = this.script;
    return data;
  }
}
