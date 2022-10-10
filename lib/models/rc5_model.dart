import 'dart:convert';

class Rc5Model {
  final String encryptionKey;
  final String inputFileName;
  final String outputFileName;
  final Rc5Action action;

  Rc5Model({
    required this.encryptionKey,
    required this.inputFileName,
    required this.outputFileName,
    required this.action,
  });

  factory Rc5Model.fromJson(Map<String, dynamic> json) {
    final encryptionKey = json['encryptionKey'];
    final inputFileName = json['inputFileName'];
    final outputFileName = json['outputFileName'];
    final action = json['action'];

    return Rc5Model(
        encryptionKey: encryptionKey,
        inputFileName: inputFileName,
        outputFileName: outputFileName,
        action: action);
  }

  String toJson() {
    final json = <String, dynamic>{};
    json['encryptionKey'] = encryptionKey;
    json['inputFileName'] = inputFileName;
    json['outputFileName'] = outputFileName;
    json['action'] = action.name;

    return jsonEncode(json);
  }
}

enum Rc5Action {
  encrypt,
  decrypt,
}
