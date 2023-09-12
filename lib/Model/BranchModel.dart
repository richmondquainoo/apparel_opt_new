class BranchModel {
  String? branch;

  BranchModel({this.branch});

  Map<String, dynamic> toMap() {
    return {'branch': branch};
  }

  Map<String, dynamic> toJson() {
    return {'branch': branch};
  }

  @override
  String toString() {
    return 'BranchModel{branch: $branch}';
  }
}
