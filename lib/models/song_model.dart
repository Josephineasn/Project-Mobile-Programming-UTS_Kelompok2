class SongModel {
  final String title;
  final String artist;
  final String albumCover;
  final String audioUrl;

  SongModel({
    required this.title,
    required this.artist,
    required this.albumCover,
    required this.audioUrl,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      title: json['title'] ?? 'Unknown Title',
      artist: json['artist']['name'] ?? 'Unknown Artist',
      albumCover: json['album']['cover_medium'] ?? '',
      audioUrl: json['preview'] ?? '',
    );
  }
}