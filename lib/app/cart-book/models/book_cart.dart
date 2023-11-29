// To parse this JSON data, do
//
//     final bookcart = bookcartFromJson(jsonString);

import 'dart:convert';

List<Bookcart> bookcartFromJson(String str) => List<Bookcart>.from(json.decode(str).map((x) => Bookcart.fromJson(x)));

String bookcartToJson(List<Bookcart> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Bookcart {
    String model;
    int pk;
    Fields fields;

    Bookcart({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Bookcart.fromJson(Map<String, dynamic> json) => Bookcart(
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
    int? carts;
    int subtotal;
    String notes;
    int? nota;

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
