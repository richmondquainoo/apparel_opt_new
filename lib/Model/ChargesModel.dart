
class ChargesModel{
  int? id;
  String? fee;
  double? amount;
  String? type;
  String? dateCreated;
  String? createdBy;


  ChargesModel({this.id, this.fee, this.amount, this.type, this.dateCreated,
      this.createdBy});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fee': fee,
      'amount': amount,
      'type': type,
      'dateCreated': dateCreated,
      'createdBy': createdBy,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fee': fee,
      'amount': amount,
      'type': type,
      'dateCreated': dateCreated,
      'createdBy': createdBy,
    };
  }

  @override
  String toString() {
    return 'ChargesModel{id: $id, fee: $fee, amount: $amount, type: $type, dateCreated: $dateCreated, createdBy: $createdBy}';
  }
}