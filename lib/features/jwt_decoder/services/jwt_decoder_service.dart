import 'dart:convert';
import 'package:injectable/injectable.dart';

@lazySingleton
class JwtDecoderService {
  /// Decodes a Base64Url encoded JWT part (Header or Payload) into a Map
  Map<String, dynamic>? decodePart(String part) {
    try {
      // base64Url.normalize adds the required '=' padding if it's missing
      final String normalized = base64Url.normalize(part);
      final String decodedString = utf8.decode(base64Url.decode(normalized));
      return jsonDecode(decodedString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Formats a JSON map into a pretty-printed string
  String formatJson(Map<String, dynamic> jsonMap) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(jsonMap);
  }
}
