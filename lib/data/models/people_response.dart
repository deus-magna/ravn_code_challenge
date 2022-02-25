import 'dart:convert';

import 'package:equatable/equatable.dart';

PeopleResponse peopleFromJson(String str) =>
    PeopleResponse.fromJson(json.decode(str));

class PeopleResponse extends Equatable {
  const PeopleResponse({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory PeopleResponse.fromJson(Map<String, dynamic> json) => PeopleResponse(
        count: json['count'],
        next: json['next'],
        previous: json['previous'],
        results: List<People>.from(
          (json['results'] as List).map((x) => People.fromJson(x)),
        ),
      );

  final int count;
  final String next;
  final dynamic previous;
  final List<People> results;

  @override
  List<Object?> get props => [
        count,
        next,
        previous,
        results,
      ];
}

class People extends Equatable {
  People(
      {required this.name,
      required this.height,
      required this.mass,
      required this.hairColor,
      required this.skinColor,
      required this.eyeColor,
      required this.birthYear,
      required this.homeworld,
      required this.films,
      required this.species,
      required this.vehicles,
      required this.starships,
      required this.created,
      required this.edited,
      required this.url,
      this.subheader,
      this.vehiclesList});

  factory People.fromJson(Map<String, dynamic> json) => People(
        name: json['name'],
        height: json['height'],
        mass: json['mass'],
        hairColor: json['hair_color'],
        skinColor: json['skin_color'],
        eyeColor: json['eye_color'],
        birthYear: json['birth_year'],
        homeworld: json['homeworld'],
        films: List<String>.from((json['films'] as List).map((x) => x)),
        species: List<String>.from((json['species'] as List).map((x) => x)),
        vehicles: List<String>.from((json['vehicles'] as List).map((x) => x)),
        starships: List<String>.from((json['starships'] as List).map((x) => x)),
        created: DateTime.parse(json['created']),
        edited: DateTime.parse(json['edited']),
        url: json['url'],
      );

  final String name;
  final String height;
  final String mass;
  final String hairColor;
  final String skinColor;
  final String eyeColor;
  final String birthYear;
  final String homeworld;
  final List<String> films;
  final List<String> species;
  final List<String> vehicles;
  final List<String> starships;
  final DateTime created;
  final DateTime edited;
  final String url;
  String? subheader;
  List<String>? vehiclesList;

  @override
  List<Object?> get props => [
        name,
        height,
        mass,
        hairColor,
        skinColor,
        eyeColor,
        birthYear,
        homeworld,
        films,
        species,
        vehicles,
        starships,
        created,
        edited,
        url,
        subheader,
      ];
}
