// To parse this JSON data, do
//
//     final nota = notaFromJson(jsonString);

import 'dart:convert';

List<Nota> notaFromJson(String str) => List<Nota>.from(json.decode(str).map((x) => Nota.fromJson(x)));

String notaToJson(List<Nota> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Nota {
    String model;
    int pk;
    Fields fields;

    Nota({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Nota.fromJson(Map<String, dynamic> json) => Nota(
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
    DateTime date;
    int totalAmount;
    int totalHarga;
    String alamat;
    String layanan;

    Fields({
        required this.user,
        required this.date,
        required this.totalAmount,
        required this.totalHarga,
        required this.alamat,
        required this.layanan,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        date: DateTime.parse(json["date"]),
        totalAmount: json["total_amount"],
        totalHarga: json["total_harga"],
        alamat: json["alamat"],
        layanan: json["layanan"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "total_amount": totalAmount,
        "total_harga": totalHarga,
        "alamat": alamat,
        "layanan": layanan,
    };
}
