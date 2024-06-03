// ignore_for_file: file_names

class MyUser {
  String? uid;
  String? fullname;
  String? email;
  String? phoneNumber;
  Address? address;
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
        address:
            json["address"] != null ? Address.fromJson(json["address"]) : null,
        referralCode: json["referral code"],
        referralLink: json["referral link"],
      );
}

class Address {
  String? addressID;
  String? address;

  Address({this.address, this.addressID});

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        address: json['address'],
        addressID: json['addressID'],
      );
}
