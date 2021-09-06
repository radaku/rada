import 'package:flutter/material.dart';

class Slide {
  final String imageUrl;
  final String title;
  final String description;

  Slide({
    @required this.imageUrl,
    @required this.title,
    @required this.description,
  });
}

final slideList = [
  Slide(
    imageUrl: 'assets/images/rada5.png',
    title: 'What Is Rada',
    description: 'RADA is a student developed mobile health application that helps students access information about sexual and reproductive health, professional counseling and peer counseling services and a helpline when in an emergency situation within the University',
  ),
  Slide(
    imageUrl: 'assets/images/rada1.jpg',
    title: 'Getting You Informed',
    description: 'Information can be thought of as the resolution of uncertainty; it is that which answers the question of "What an entity is" and thus defines both its essence and nature of its characteristics. The concept of information has different meanings in different contexts.',
  ),
  Slide(
    imageUrl: 'assets/images/rada4.jpg',
    title: 'Better Graduates To The Society',
    description: 'Many people know that they want to attend college, but dont know exactly why, or how it will enrich their lives. Below are some of the many benefits of earning a college degree',
  ),
];
