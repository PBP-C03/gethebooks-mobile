// To parse this JSON data, do
//
//     final uploadbook = uploadbookFromJson(jsonString);

import 'dart:convert';

List<Uploadbook> uploadbookFromJson(String str) => List<Uploadbook>.from(json.decode(str).map((x) => Uploadbook.fromJson(x)));

String uploadbookToJson(List<Uploadbook> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Uploadbook {
    String model;
    int pk;
    Fields fields;

    Uploadbook({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Uploadbook.fromJson(Map<String, dynamic> json) => Uploadbook(
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
    String isbn;
    String title;
    String author;
    int year;
    String publisher;
    String image;
    int price;
    int stocks;

    Fields({
        required this.user,
        required this.isbn,
        required this.title,
        required this.author,
        required this.year,
        required this.publisher,
        required this.image,
        required this.price,
        required this.stocks,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        isbn: json["isbn"],
        title: json["title"],
        author: json["author"],
        year: json["year"],
        publisher: json["publisher"],
        image: json["image"],
        price: json["price"],
        stocks: json["stocks"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "isbn": isbn,
        "title": title,
        "author": author,
        "year": year,
        "publisher": publisher,
        "image": image,
        "price": price,
        "stocks": stocks,
    };
}
