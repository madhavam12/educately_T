import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class RandomFact {
  Future fetchFact() async {
    int gg = Random().nextInt(100);
    final response = await http.get(
      Uri.parse('http://numbersapi.com/$gg'),
    );
    if (response.statusCode == 200) {
      print('fsd');

      print(response.body);
    }

    return response.body.toString();
  }
}
