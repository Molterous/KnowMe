import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';

abstract class PortfolioRemoteDataSource {
  Future<Map<String, dynamic>> getPortfolioData();
}

class PortfolioRemoteDataSourceImpl implements PortfolioRemoteDataSource {
  final http.Client client;

  const PortfolioRemoteDataSourceImpl(this.client);

  @override
  Future<Map<String, dynamic>> getPortfolioData() async {
    try {
      final response = await client.get(
        Uri.parse('/assets/data/portfolio_data.json'),
      );

      if (response.statusCode != 200) {
        throw NetworkException(
          'Remote fetch failed with status ${response.statusCode}.',
        );
      }

      return jsonDecode(response.body) as Map<String, dynamic>;
    } on NetworkException {
      rethrow;
    } on FormatException {
      throw const ParseException('Failed to parse remote portfolio data.');
    } catch (e) {
      throw NetworkException('Network error: $e');
    }
  }
}
