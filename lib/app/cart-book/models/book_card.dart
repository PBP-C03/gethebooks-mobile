// To parse this JSON data, do
//
//     final Book_Cart = Book_CartFromJson(jsonString);

import 'dart:convert';

List<Book_Cart> Book_CartFromJson(String str) => List<Book_Cart>.from(json.decode(str).map((x) => Book_Cart.fromJson(x)));

String bookCartToJson(List<Book_Cart> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Book_Cart {
    String model;
    int pk;
    Fields fields;

    Book_Cart({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Book_Cart.fromJson(Map<String, dynamic> json) => Book_Cart(
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
    int amount;
    int book;
    int carts;
    int subtotal;
    String notes;
    dynamic nota;

    Fields({
        required this.amount,
        required this.book,
        required this.carts,
        required this.subtotal,
        required this.notes,
        required this.nota,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        amount: json["amount"],
        book: json["book"],
        carts: json["carts"],
        subtotal: json["subtotal"],
        notes: json["notes"],
        nota: json["nota"],
    );

    Map<String, dynamic> toJson() => {
        "amount": amount,
        "book": book,
        "carts": carts,
        "subtotal": subtotal,
        "notes": notes,
        "nota": nota,
    };
}
