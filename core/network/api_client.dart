import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'network_exceptions.dart';

class ApiClient {
  final String baseUrl;
  final http.Client _client;

  ApiClient({required this.baseUrl, http.Client? client}) 
      : _client = client ?? http.Client();

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  Future<dynamic> get(String endpoint) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
      );
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No hay conexión a internet');
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
        body: jsonEncode(body),
      );
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No hay conexión a internet');
    }
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await _client.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
        body: jsonEncode(body),
      );
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No hay conexión a internet');
    }
  }

  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await _client.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
      );
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No hay conexión a internet');
    }
  }

  dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonDecode(response.body);
      case 400:
        throw BadRequestException('Petición incorrecta', 400);
      case 401:
      case 403:
        throw UnauthorisedException('No autorizado', response.statusCode);
      case 404:
        throw NotFoundException('Recurso no encontrado', 404);
      case 500:
      default:
        throw FetchDataException(
            'Error ocurrido durante la comunicación con el servidor: ${response.statusCode}');
    }
  }
}
