import 'package:flutter/material.dart';

class Student {
  final String id;
  final String name;
  final String province;
  final String town;
  final String university;
  final String course;
  final List<String> interests;
  final String travelDate;
  final bool verified;
  final double lat;
  final double lng;
  final Color color;

  const Student({
    required this.id,
    required this.name,
    required this.province,
    required this.town,
    required this.university,
    required this.course,
    required this.interests,
    required this.travelDate,
    this.verified = false,
    this.lat = -25.4658,
    this.lng = 30.9853,
    this.color = const Color(0xFF4338CA),
  });

  String get initials {
    final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    return (parts[0][0] + (parts.length > 1 ? parts[1][0] : '')).toUpperCase();
  }

  /// Privacy: other students only see "Sipho M."
  String get shortName {
    final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.length < 2) return name;
    return '${parts[0]} ${parts[1][0]}.';
  }
}

class Message {
  final String from; // 'me' or a display name
  final String text;
  final DateTime time;
  Message(this.from, this.text) : time = DateTime.now();
  bool get mine => from == 'me';
}

class BusOption {
  final String operator;
  final String depart;
  final String arrive;
  final String price;
  final String tag;
  const BusOption(this.operator, this.depart, this.arrive, this.price, [this.tag = '']);
}
