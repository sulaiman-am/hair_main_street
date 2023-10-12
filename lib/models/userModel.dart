class MyUser {
  String? uid;
  String? fullname;
  String? email;
  String? phoneNumber;
  String? address;
  bool? isBuyer = true;
  bool? isVendor;
  bool? isAdmin;

  MyUser(
      {this.uid,
      this.address,
      this.email,
      this.phoneNumber,
      this.fullname,
      this.isAdmin,
      this.isBuyer,
      this.isVendor});
}
