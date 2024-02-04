class AppUserModel {
  late final String uId;
  late final String name;
  late final String token;
  String? phone;
  String? email;
  String? image;
  String? bio;
  String? cover;

  AppUserModel({
    this.email,
    required this.name,
    required this.uId,
    this.phone,
    this.token = '',
    this.image,
    this.bio,
    this.cover,
  });

  AppUserModel.fromJson(Map<String, dynamic>? json) {
    email = json!['email'];
    name = json['name'];
    token = json['token'] ?? '';
    phone = json['phone'];
    image = json['image'];
    cover = json['cover'];
    uId = json['uId'];
    bio = json['bio'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'uId': uId,
      'email': email,
      'token': token,
      'cover': cover,
      'image': image,
      'bio': bio,
    };
  }
}
