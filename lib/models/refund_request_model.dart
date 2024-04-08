class RefundRequest {
  String? requestID;
  String? orderID;
  String? reason;
  String? addedDetails;
  String? refundStatus;
  String? userID;

  RefundRequest({
    this.orderID,
    this.reason,
    this.addedDetails,
    this.refundStatus,
    this.requestID,
    this.userID,
  });

  factory RefundRequest.fromData(Map<String, dynamic> data) {
    return RefundRequest(
      orderID: data['orderID'] ?? '',
      reason: data['reason'] ?? '',
      requestID: data['requestID'],
      addedDetails: data['added details'] ?? '',
      refundStatus: data['refund status'] ?? '',
      userID: data['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderID': orderID,
      'requestID': requestID,
      'reason': reason,
      'added details': addedDetails,
      'refund status': refundStatus,
      'userID': userID,
    };
  }
}

class CancellationRequest {
  String? userID;
  String? requestID;
  String? orderID;
  String? reason;
  String? cancellationStatus;

  CancellationRequest({
    this.orderID,
    this.reason,
    this.cancellationStatus,
    this.requestID,
    this.userID,
  });

  factory CancellationRequest.fromData(Map<String, dynamic> data) {
    return CancellationRequest(
      orderID: data['orderID'] ?? '',
      reason: data['reason'] ?? '',
      requestID: data['requestID'],
      cancellationStatus: data['cancellation status'],
      userID: data["userID"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderID': orderID,
      'requestID': requestID,
      'reason': reason,
      'cancellation': cancellationStatus,
      'userID': userID
    };
  }
}
