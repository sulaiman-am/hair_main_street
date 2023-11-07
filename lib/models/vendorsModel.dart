class Vendors {
  String? userID;
  String? shopName;
  Map? accountInfo;
  Map? contactInfo;
  bool? isVerified;
  dynamic createdAt;

  Vendors(
      {this.accountInfo,
      this.createdAt,
      this.contactInfo,
      this.isVerified,
      this.shopName,
      this.userID});
}
