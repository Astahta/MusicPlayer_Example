class Song {
  final String trackName, artistName, artworkUrl60, artworkUrl30, previewUrl, artistViewUrl, collectionName;

  Song({required this.trackName, required this.artistName,
    required this.artworkUrl60, required this.artworkUrl30,
    required this.artistViewUrl, required this.previewUrl,
    required this.collectionName});

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      trackName: json['trackName']??"",
      artistName: json['artistName']??"",
      artworkUrl60: json['artworkUrl60']??"",
      artworkUrl30: json['artworkUrl30']??"",
      artistViewUrl: json['artistViewUrl']??"",
      previewUrl: json['previewUrl']??"",
      collectionName: json['collectionName']??"",
    );
  }
  static List<Song> fromJsonList(List list) {
    return list.map((item) => Song.fromJson(item)).toList();
  }

}
