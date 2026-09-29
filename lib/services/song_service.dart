import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/song_model.dart';

class SongService {
  static Future<List<SongModel>> fetchDeezerSongs() async {
    const url = 'https://api.deezer.com/chart/0/tracks';
    
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> tracks = data['data'];

        return tracks.map((json) => SongModel.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat lagu');
      }
    } catch (e) {
      throw Exception('Kesalahan jaringan: $e');
    }
  }
}