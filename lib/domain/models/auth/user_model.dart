import '../../../core/base/models/base_model.dart';

class UserModel extends BaseModel<UserModel> {
  String? id;
  String? email;
  String? password;
  int? balance;
  bool? isFirstOrderInsufficientBalance;
  DateTime? createdDate;
  DateTime? lastAppEntryDate;

  UserModel({
    this.id,
    this.email,
    this.password,
    this.balance,
    this.isFirstOrderInsufficientBalance,
    this.createdDate,
    this.lastAppEntryDate,
  });

  UserModel.sign({required this.email, required this.password});

  @override
  UserModel fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      email: json["email"],
      password: json["password"],
      balance: json["balance"],
      isFirstOrderInsufficientBalance: json["isFirstOrderInsufficientBalance"],
      createdDate: json["createdDate"],
      lastAppEntryDate: json["lastAppEntryDate"],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "password": password,
      "balance": balance,
      "isFirstOrderInsufficientBalance": isFirstOrderInsufficientBalance,
      "createdDate": createdDate,
      "lastAppEntryDate": lastAppEntryDate,
    };
  }
}
