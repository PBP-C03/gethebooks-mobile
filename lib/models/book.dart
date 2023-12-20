// To parse this JSON data, do
//
//     final book = bookFromJson(jsonString);

// ignore_for_file: constant_identifier_names

import 'dart:convert';

List<Book> bookFromJson(String str) => List<Book>.from(json.decode(str).map((x) => Book.fromJson(x)));

String bookToJson(List<Book> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Book {
    int pk;
    Model model;
    Fields fields;

    Book({
        required this.pk,
        required this.model,
        required this.fields,
    });

    factory Book.fromJson(Map<String, dynamic> json) => Book(
        pk: json["pk"],
        model: modelValues.map[json["model"]]!,
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "pk": pk,
        "model": modelValues.reverse[model],
        "fields": fields.toJson(),
    };
}

class Fields {
    dynamic isbn;
    String title;
    String author;
    int year;
    String publisher;
    String image;
    int price;
    int stocks;

    Fields({
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

enum Model {
    BOOK_BOOK
}

final modelValues = EnumValues({
    "book.book": Model.BOOK_BOOK
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
