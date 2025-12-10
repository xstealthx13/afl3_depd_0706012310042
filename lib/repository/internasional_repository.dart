import 'dart:convert';

import 'package:depd_mvvm_2025/data/network/base_api_service.dart';
import 'package:depd_mvvm_2025/data/network/network_api_service.dart';
import 'package:depd_mvvm_2025/model/model.dart';

class InternationalRepository {
  final BaseApiServices _apiService = NetworkApiServices();

  // GET LIST OF COUNTRIES (international destination)
  Future<List<Country>> fetchInternationalDestination(String keyword) async {
    try {
      final response = await _apiService.getApiResponse(
        "/v2/internationalDestination?q=$keyword",
      );

      final results = response["rajaongkir"]["results"] as List<dynamic>;

      return results.map((e) => Country.fromJson(e)).toList();
    } catch (e) {
      throw Exception("Failed to fetch international destinations: $e");
    }
  }

  // GET INTERNATIONAL SHIPPING COST
  Future<List<Costs>> checkInternationalCost({
    required String origin,
    required String originType,
    required String destination,
    required int weight,
    required String courier,
  }) async {
    try {
      final reqBody = {
        "origin": origin,
        "originType": originType,
        "destination": destination,
        "weight": weight,
        "courier": courier,
      };

      final response = await _apiService.postApiResponse(
        "/v2/internationalCost",
        jsonEncode(reqBody),
      );

      final results = response["rajaongkir"]["results"] as List<dynamic>;

      if (results.isEmpty) return [];

      final costList = results[0]["costs"] as List<dynamic>? ?? [];

      return costList
          .map((item) => Costs(
                name: item["name"],
                code: item["code"],
                service: item["service"],
                description: item["description"],
                cost: item["cost"]?[0]?["value"],
                etd: item["cost"]?[0]?["etd"],
              ))
          .toList();
    } catch (e) {
      throw Exception("Failed to fetch international cost: $e");
    }
  }
}
