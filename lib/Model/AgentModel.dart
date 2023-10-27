class AgentModel{
  int? agentId;
  String? otherName;
  String? surname;
  String? phone;
  String? companyName;
  String? companyId;
  String? photo;
  String? dateCreated;
  String? role;
  double? latitude;
  double? longitude;
  String? token;
  String? address;

  AgentModel({
      this.agentId,
      this.otherName,
      this.surname,
      this.phone,
      this.companyName,
      this.companyId,
      this.photo,
      this.dateCreated,
      this.role,
      this.latitude,
      this.longitude,
      this.token,
      this.address
  });

  Map<String, dynamic> toMap(){
    return{
      'agentId':agentId,
      'otherName':otherName,
      'surname':surname,
      'phone':phone,
      'companyName':companyName,
      'companyId':companyId,
      'photo':photo,
      'dateCreated':dateCreated,
      'role':role,
      'latitude':latitude,
      'longitude':longitude,
      'token':token,
      'address':address,
    };
  }

  Map<String, dynamic> toJson(){
    return{
      'agentId':agentId,
      'otherName':otherName,
      'surname':surname,
      'phone':phone,
      'companyName':companyName,
      'companyId':companyId,
      'photo':photo,
      'dateCreated':dateCreated,
      'role':role,
      'latitude':latitude,
      'longitude':longitude,
      'token':token,
      'address':address,
    };
  }

  @override
  String toString() {
    return 'AgentModel{agentId: $agentId, otherName: $otherName, surname: $surname, phone: $phone, companyName: $companyName, companyId: $companyId, photo: $photo, dateCreated: $dateCreated, role: $role, latitude: $latitude, longitude: $longitude, token: $token, address: $address}';
  }
}