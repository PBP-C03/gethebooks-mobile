// To parse this JSON data, do
//
//     final review = reviewFromJson(jsonString);

import 'dart:convert';

List<Review> reviewFromJson(String str) => List<Review>.from(json.decode(str).map((x) => Review.fromJson(x)));

String reviewToJson(List<Review> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Review {
  String model;
  int pk;
  Fields fields;

  Review({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
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
  String username;
  int book;
  DateTime dateAdded;
  int rating;
  String review;

  Fields({
    required this.user,
    required this.username,
    required this.book,
    required this.dateAdded,
    required this.rating,
    required this.review,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
    user: json["user"],
    username: json["username"],
    book: json["book"],
    dateAdded: DateTime.parse(json["date_added"]),
    rating: json["rating"],
    review: json["review"],
  );

  Map<String, dynamic> toJson() => {
    "user": user,
    "username": username,
    "book": book,
    "date_added": "${dateAdded.year.toString().padLeft(4, '0')}-${dateAdded.month.toString().padLeft(2, '0')}-${dateAdded.day.toString().padLeft(2, '0')}",
    "rating": rating,
    "review": review,
  };
}
