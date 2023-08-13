import 'package:kotc/main.dart';

class RecomendationModel {
  //write
  //value
  //["tag 5"]

  //read
  //value
  //Map<String, int> : <tag, 5>

  static Future<void> setData(Map<String, int> map) async {
    List<String> recList = [];
    map.forEach((key, value) {
      recList.add("$key $value");
    });
    await sharedPreferences!.setStringList("recomendatinList", recList);
  }

  static Future<Map<String, int>> getData() async {
    Map<String, int> resultMap = {};
    try {
      List<String>? recList =
          sharedPreferences!.getStringList("recomendatinList");

      for (var element in recList!) {
        String tag = element.split(" ")[0];
        int count = int.parse(element.split(" ")[1]);
        resultMap.addAll({tag: count});
      }
    } catch (e) {
      print("recomendatin system error or no data");
    }
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    print(resultMap);
    return resultMap;
  }
}
