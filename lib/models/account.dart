class Account {
  const Account({required this.id, required this.email, this.createdAt});

  final int id;
  final String email;
  final String? createdAt;

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: int.parse(json['id'].toString()),
      email: json['email'].toString(),
      createdAt: json['created_at']?.toString(),
    );
  }
}
