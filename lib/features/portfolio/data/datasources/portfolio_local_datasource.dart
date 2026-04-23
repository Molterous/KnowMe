import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../core/error/exceptions.dart';

abstract class PortfolioLocalDataSource {
  Future<Map<String, dynamic>> getPortfolioData();
}

class PortfolioLocalDataSourceImpl implements PortfolioLocalDataSource {
  @override
  Future<Map<String, dynamic>> getPortfolioData() async {
    try {
      final raw = await rootBundle.loadString('assets/data/portfolio_data.json');
      return jsonDecode(raw) as Map<String, dynamic>;
    } on Exception catch (e) {
      if (e.toString().contains('Unable to load asset')) {
        throw const AssetException('Failed to load portfolio data asset.');
      }
      rethrow;
    } catch (_) {
      throw const ParseException('Failed to parse portfolio data.');
    }
  }
}
