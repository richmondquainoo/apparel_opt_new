import 'dart:convert';

LikeModel likeModelFromJson(String str) => LikeModel.fromJson(json.decode(str));
List<LikeModel> likeListModelFromJson(String str) =>
    List<LikeModel>.from(json.decode(str).map((x) => LikeModel.fromJson(x)));
String likeModelToJson(LikeModel data) => json.encode(data.toJson());

class LikeModel {
  LikeModel({
    this.email,
    this.id,
    this.menuId,
    this.organization,
    this.branch,
    this.likes,
  });

  String email;
  int id;
  int menuId;
  String organization;
  String branch;
  int likes;

  factory LikeModel.fromJson(Map<String, dynamic> json) => LikeModel(
        email: json["email"],
        id: json["id"],
        menuId: json["menuId"],
        organization: json["organization"],
        branch: json["branch"],
        likes: json["likes"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "id": id,
        "menuId": menuId,
        "organization": organization,
        "branch": branch,
        "likes": likes,
      };

  Map<String, dynamic> toMap() => {
        "email": email,
        "id": id,
        "menuId": menuId,
        "organization": organization,
        "branch": branch,
        "likes": likes,
      };

  @override
  String toString() {
    return 'LikeModel{email: $email, id: $id, menuId: $menuId, organization: $organization, branch: $branch, likes: $likes}';
  }
}
