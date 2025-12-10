import 'package:flutter/material.dart';
import 'package:depd_mvvm_2025/model/model.dart';
import 'package:depd_mvvm_2025/data/response/api_response.dart';
import 'package:depd_mvvm_2025/data/response/status.dart';
import 'package:depd_mvvm_2025/repository/internasional_repository.dart';

class InternationalViewModel with ChangeNotifier {
  final _repo = InternationalRepository();

  // COUNTRY LIST
  ApiResponse<List<Country>> countryList = ApiResponse.notStarted();

  void setCountryList(ApiResponse<List<Country>> response) {
    countryList = response;
    notifyListeners();
  }

  Future getInternationalCountries(String keyword) async {
    setCountryList(ApiResponse.loading());
    _repo.fetchInternationalDestination(keyword).then((value) {
      setCountryList(ApiResponse.completed(value));
    }).onError((error, _) {
      setCountryList(ApiResponse.error(error.toString()));
    });
  }

  // COST LIST
  ApiResponse<List<Costs>> costList = ApiResponse.notStarted();

  void setCostList(ApiResponse<List<Costs>> response) {
    costList = response;
    notifyListeners();
  }

  bool isLoading = false;
  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future checkInternationalCost({
    required String origin,
    required String originType,
    required String destination,
    required int weight,
    required String courier,
  }) async {
    setLoading(true);
    setCostList(ApiResponse.loading());

    _repo
        .checkInternationalCost(
          origin: origin,
          originType: originType,
          destination: destination,
          weight: weight,
          courier: courier,
        )
        .then((value) {
          setCostList(ApiResponse.completed(value));
          setLoading(false);
        })
        .onError((error, _) {
          setCostList(ApiResponse.error(error.toString()));
          setLoading(false);
        });
  }
}
