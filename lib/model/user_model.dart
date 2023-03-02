class UserModel {
  UserModel({
    this.emailAddress,
    this.phoneCode,
    this.phoneNumber,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    emailAddress = json["emailAddress"];
    phoneCode = json["phoneCode"];
    phoneNumber = json["phoneNumber"];
  }

  String? emailAddress;
  String? phoneCode;
  String? phoneNumber;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["emailAddress"] = emailAddress;
    map["phoneCode"] = phoneCode;
    map["phoneNumber"] = phoneNumber;
    return map;
  }
}
