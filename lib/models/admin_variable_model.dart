class AdminVariableModel {
  final num? convenienceFee;
  final num? expiredFee;
  final num? installmentDuration;

  const AdminVariableModel(
      {this.convenienceFee, this.expiredFee, this.installmentDuration});

  factory AdminVariableModel.fromJson(Map<String, dynamic> json) =>
      AdminVariableModel(
        convenienceFee: json["convenience fee"],
        expiredFee: json["expired fee"],
        installmentDuration: json["installment duration"],
      );

  Map<String, dynamic> toJson() => {
        "convenience fee": convenienceFee,
        "expired fee": expiredFee,
        "installment duration": installmentDuration,
      };
}
