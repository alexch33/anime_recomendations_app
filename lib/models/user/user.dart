class User {
  String id;
  String name;
  String role;
  String email;

  User({
    this.id,
    this.name,
    this.email,
    this.role,
  });

  factory User.fromMap(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    role: json["role"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "email": email,
    "role": role,
  };
}
