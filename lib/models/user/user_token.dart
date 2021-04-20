class UserToken {
  String? id;
  String? accessToken;
  String? refreshToken;
  String? accessExpiresDate;
  String? refreshExpiresDate;

  UserToken({
    this.id,
    this.accessToken,
    this.refreshToken,
    this.accessExpiresDate,
    this.refreshExpiresDate,
  });

  factory UserToken.fromMap(Map<String, dynamic> json) => UserToken(
    id: json["id"],
    accessToken: json["accessToken"],
    refreshToken: json["refreshToken"],
    accessExpiresDate: json["accessExpiresDate"],
    refreshExpiresDate: json["refreshExpiresDate"],
  );

  factory UserToken.fromServerMap(Map<String, dynamic> json) => UserToken(
    id: "0",
    accessToken: json["access"]["token"],
    refreshToken: json["refresh"]["token"],
    accessExpiresDate: json["access"]["expires"],
    refreshExpiresDate: json["refresh"]["expires"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "accessToken": accessToken,
    "refreshToken": refreshToken,
    "accessExpiresDate": accessExpiresDate,
    "refreshExpiresDate": refreshExpiresDate,
  };
}
