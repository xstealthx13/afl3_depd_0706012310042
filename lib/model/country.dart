part of 'model.dart';

class Country extends Equatable {
  final int? countryId;
  final String? countryName;
  final String? iso2; // optional
  final String? iso3; // optional

  const Country({
    this.countryId,
    this.countryName,
    this.iso2,
    this.iso3,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        countryId: (json['country_id'] is int) ? json['country_id'] as int : int.tryParse('${json['country_id'] ?? ''}'),
        countryName: json['country_name'] as String? ?? json['name'] as String?,
        iso2: json['iso2'] as String?,
        iso3: json['iso3'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'country_id': countryId,
        'country_name': countryName,
        'iso2': iso2,
        'iso3': iso3,
      };

  @override
  List<Object?> get props => [countryId, countryName, iso2, iso3];
}
