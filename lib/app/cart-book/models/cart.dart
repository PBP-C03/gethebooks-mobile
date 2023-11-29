// To parse this JSON data, do
//
//     final cart = cartFromJson(jsonString);

import 'dart:convert';

List<Cart> cartFromJson(String str) => List<Cart>.from(json.decode(str).map((x) => Cart.fromJson(x)));

String cartToJson(List<Cart> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Cart {
    String model;
    int pk;
    Fields fields;

    Cart({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    int user;
    int totalAmount;
    int totalHarga;

    Fields({
        required this.user,
        required this.totalAmount,
        required this.totalHarga,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        totalAmount: json["total_amount"],
        totalHarga: json["total_harga"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "total_amount": totalAmount,
        "total_harga": totalHarga,
    };
}
