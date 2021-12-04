import 'package:anime_recommendations_app/data/network/apis/animes/scrappers/anime_scraper.dart';
import 'package:anime_recommendations_app/data/network/constants/endpoints.dart';
import 'package:anime_recommendations_app/data/network/dio_client.dart';
import 'package:anime_recommendations_app/models/anime/anime_video.dart';
import 'package:dio/dio.dart';
import 'package:string_similarity/string_similarity.dart';

class AnilibriaAnimeScrapper extends AnimeScrapper {
  AnilibriaAnimeScrapper(DioClient dioClient) : super(dioClient);

  Future<List<AnimeVideo>> getLinksForAniById(String id, int episode) async {
    final payLoad = {"query": "release", "id": id};
    try {
      final uri = '${Endpoints.baseAnilibriaURL}';

      final resp = await dioClient.post(uri, data: FormData.fromMap(payLoad));

      var nl = <AnimeVideo>[];

      if (resp["status"]) {
        List<dynamic> playList = resp["data"]["playlist"];
        for (var element in playList) {
          if (element["id"].toString().compareTo(episode.toString()) == 0) {
            nl.add(AnimeVideo(
                src: element["sd"], totalEpisodes: playList.length.toString()));
            break;
          }
        }
      }
      return nl;
    } catch (e) {
      throw e;
    }
  }

  Future<String> searchAnime(String name) async {
    final url = '${Endpoints.baseAnilibriaURL}';
    String cleanedName = name.toLowerCase().replaceAll(RegExp(r'\W'), " ");
    final payLoad = {
      "query": "search",
      "search": cleanedName,
      "filter": "id,names,playlist"
    };

    var resp = await dioClient.post(url, data: FormData.fromMap(payLoad));
    if (resp["status"]) {
      List<String> names = [];
      List<dynamic> dataList = resp["data"];

      dataList.forEach((el) {
        print(el["names"]);
        names.add(el["names"].last);
      });
      return dataList[cleanedName.bestMatch(names).bestMatchIndex]["id"]
          .toString();
    }

    return "-1";
  }

  @override
  Future<String> getAnimeUrl(String name) async {
    String code = 'not_found';

    final url = '${Endpoints.baseAnilibriaURL}';
    String cleanedName = name.toLowerCase().replaceAll(RegExp(r'\W'), " ");
    final payLoad = {
      "query": "search",
      "search": cleanedName,
      "filter": "id,names,playlist,code"
    };

    var resp = await dioClient.post(url, data: FormData.fromMap(payLoad));
    if (resp["status"]) {
      List<String> names = [];
      List<dynamic> dataList = resp["data"];

      dataList.forEach((el) {
        names.add(el["names"].last);
      });
      if (dataList.isNotEmpty) {
        code = dataList[cleanedName.bestMatch(names).bestMatchIndex]['code'];
      }
    }

    return "https://www.anilibria.tv/release/$code.html";
  }
}
