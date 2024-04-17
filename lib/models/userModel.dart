class MyUser {
  String? uid;
  String? fullname;
  String? email;
  String? phoneNumber;
  String? address;
  bool? isBuyer = true;
  bool? isVendor;
  bool? isAdmin;
  String? referralCode;
  String? profilePhoto;
  String? referralLink;

  MyUser({
    this.uid,
    this.address,
    this.email,
    this.phoneNumber,
    this.fullname,
    this.isAdmin,
    this.isBuyer,
    this.isVendor,
    this.profilePhoto,
    this.referralCode,
    this.referralLink,
  });

  factory MyUser.fromJson(Map<String, dynamic> json) => MyUser(
        uid: json["uid"],
        fullname: json["fullname"],
        email: json["email"],
        phoneNumber: json["phonenumber"],
        isAdmin: json["isAdmin"],
        isBuyer: json["isBuyer"],
        isVendor: json["isVendor"],
        profilePhoto: json["profile photo"],
        address: json["address"],
        referralCode: json["referral code"],
        referralLink: json["referral link"],
      );
}
