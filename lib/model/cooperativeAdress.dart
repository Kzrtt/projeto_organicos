class CooperativeAdress {
  final String complement;
  final String street;
  final String city;
  final String state;
  final String zipCode;

  CooperativeAdress({
    required this.complement,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
  });

  static CooperativeAdress fromJson(Map<String, dynamic> json) {
    return CooperativeAdress(
      complement: json['complement'],
      street: json['street'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zipCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'complement': complement,
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
    };
  }
}
