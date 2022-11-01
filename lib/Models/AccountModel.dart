class AccountModal {
  String? userId;
  String? firstName;
  String? middleName;
  String? lastName;
  String? email;
  String? mobile;
  String? birthDate;
  String? addressNo;
  String? addressSuffix;
  String? addressLine1;
  String? addressLine2;
  String? addressLine3;
  String? region;
  String? zipCode;
  String? countryCode;
  String? gender;
  String? password;

  AccountModal({
    this.userId,
    this.firstName,
    this.middleName,
    this.lastName,
    this.email,
    this.mobile,
    this.birthDate,
    this.addressNo,
    this.addressSuffix,
    this.addressLine1,
    this.addressLine2,
    this.addressLine3,
    this.region,
    this.zipCode,
    this.countryCode,
    this.gender,
    this.password,
  });

  // accountModal.fromJson(Map<String, dynamic> json) {
  //   userId = json['userId'];
  //   firstName = json['firstName'];
  //   middleName = json['middleName'];
  //   lastName = json['lastName'];
  //   email = json['email'];
  //   mobile = json['mobile'];
  //   birthDate = json['birthDate'];
  //   addressNo = json['addressNo'];
  //   addressSuffix = json['addressSuffix'];
  //   addressLine1 = json['addressLine1'];
  //   addressLine2 = json['addressLine2'];
  //   addressLine3 = json['addressLine3'];
  //   region = json['region'];
  //   zipCode = json['zipCode'];
  //   countryCode = json['countryCode'];
  //   gender = json['gender'];
  //   password = json['password'];
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['firstName'] = firstName;
    data['middleName'] = middleName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['mobile'] = mobile;
    data['birthDate'] = birthDate;
    data['addressNo'] = addressNo;
    data['addressSuffix'] = addressSuffix;
    data['addressLine1'] = addressLine1;
    data['addressLine2'] = addressLine2;
    data['addressLine3'] = addressLine3;
    data['region'] = region;
    data['zipCode'] = zipCode;
    data['countryCode'] = countryCode;
    data['gender'] = gender;
    data['password'] = password;
    return data;
  }
}
