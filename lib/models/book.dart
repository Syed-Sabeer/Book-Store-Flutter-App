import 'package:cloud_firestore/cloud_firestore.dart';

class books{
  String name;
  String author;
  String description;
  String image;
  String language;
  String length;
  String publisher;
  String price;
  Timestamp createdOn;
  Timestamp updatedOn;

books({
    required this.name,
    required this.author,
  required this.description,
  required this.image,
  required this.language,
  required this.length,
  required this.publisher,
  required this.price,
  required this.createdOn,
  required this.updatedOn,
});

books.fromJson(Map<String, Object?> json)
    : this(
    name: json['name']! as String,
    author: json['author']! as String,
  description: json['description']! as String,
  image: json['image']! as String,
  language: json['language']! as String,
  length: json['length']! as String,
  publisher: json['publisher']! as String,
  price: json['price']! as String,
  createdOn: json['createdOn']! as Timestamp,
  updatedOn: json['updatedOn']! as Timestamp
);

books copyWith({
    String? name,
  String? author,
  String? description,
  String? image,
  String? language,
  String? length,
  String? publisher,
  String? price,
  Timestamp? createdOn,
  Timestamp? updatedOn

}) {
  return books (
    name: name ?? this.name,
    author: author ?? this.author,
    description: description ?? this.description,
    image: image ?? this.image,
    language: language ?? this.language,
    length: length ?? this.length,
    publisher: publisher ?? this.publisher,
    price: price ?? this.price,
    createdOn: createdOn ?? this.createdOn,
    updatedOn: updatedOn ?? this.updatedOn,
  );
}

Map<String, Object?> toJson(){
  return {
    'name': name,
    'author': author,
    'description': description,
    'image': image,
    'language': language,
    'length': length,
    'publisher': publisher,
    'price': price,
    'createdOn': createdOn,
    'updatedOn': updatedOn

  };
}

}