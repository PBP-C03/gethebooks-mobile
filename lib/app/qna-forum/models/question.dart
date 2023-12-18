// To parse this JSON data, do
//
//     final question = questionFromJson(jsonString);

import 'dart:convert';

List<Question> questionFromJson(String str) => List<Question>.from(json.decode(str).map((x) => Question.fromJson(x)));

String questionToJson(List<Question> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Question {
    String model;
    int pk;
    Fields fields;

    Question({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Question.fromJson(Map<String, dynamic> json) => Question(
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
    String title;
    int book;
    String content;
    DateTime createdAt;
    List<dynamic> answer;

    Fields({
        required this.user,
        required this.title,
        required this.book,
        required this.content,
        required this.createdAt,
        required this.answer,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        title: json["title"],
        book: json["book"],
        content: json["content"],
        createdAt: DateTime.parse(json["created_at"]),
        answer: List<dynamic>.from(json["answer"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "title": title,
        "book": book,
        "content": content,
        "created_at": createdAt.toIso8601String(),
        "answer": List<dynamic>.from(answer.map((x) => x)),
    };
}
