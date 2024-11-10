import 'package:http/http.dart';
import 'dart:convert'; // Para decodificar o JSON

class AdviceData {
  AdviceData(this._advice);

  final String _advice;

  String get advice {
    return _advice;
  }
}

class AdviceModel {
  Future<AdviceData> loadAdviceFromServer() async {
    final uri = Uri.parse('https://api.adviceslip.com/advice');
    final response = await get(uri);

    if (response.statusCode != 200) {
      throw ('Failed to update resourse');
    }
    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    
    return AdviceData(jsonResponse['slip']['advice']);
  }
}