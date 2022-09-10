class RatingModel {
  int id;
  String email;
  String cumulativeRating;

  RatingModel({this.id, this.email, this.cumulativeRating});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'cumulativeRating': cumulativeRating,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'cumulativeRating': cumulativeRating,
    };
  }

  @override
  String toString() {
    return 'RatingModel{id: $id, email: $email, cumulativeRating: $cumulativeRating}';
  }
}
