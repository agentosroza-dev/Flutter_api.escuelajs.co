import 'dart:convert';

List<Cat> categoryFromJson(String str) => List<Cat>.from(json.decode(str).map((x) => Cat.fromJson(x)));

String categoryToJson(List<Cat> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Cat {
    String id;
    String name;
    String slug;
    String image;
    String creationAt;
    String updatedAt;

    Cat({
        required this.id,
        required this.name,
        required this.slug,
        required this.image,
        required this.creationAt,
        required this.updatedAt,
    });

    factory Cat.fromJson(Map<String, dynamic> json) => Cat(
        id: json["id"].toString(),
        name: json["name"].toString(),
        slug: json["slug"].toString(),
        image: json["image"].toString(),
        creationAt: json["creationAt"].toString(),
        updatedAt: json["updatedAt"].toString(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "image": image,
        "creationAt": creationAt,
        "updatedAt": updatedAt,
    };
}
