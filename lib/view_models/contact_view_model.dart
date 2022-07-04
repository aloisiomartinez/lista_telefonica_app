import 'dart:math';

import 'package:flutter/material.dart';

import '../models/contact.dart';

class ContactViewModel {
  ContactViewModel(Contact contact)
      : name = contact.name,
        number = contact.number,
        favoriteIcon = contact.isFavorite ? Icons.star : Icons.star_outline,
        favoriteIconColor = contact.isFavorite ? Colors.yellow : Colors.grey{
    final url = contact.picture;
    image = url != null ? NetworkImage(url) : null;

    final materialColor =
        Colors.primaries[Random().nextInt(Colors.primaries.length)];
    backgroundColor = materialColor.withOpacity(0.4);
    foregroundColor = materialColor.shade800;

    final names = contact.name.split(' ');
    identifier = names.first.characters.first + names.last.characters.first;
  }

  final String name;
  final String number;
  final IconData favoriteIcon;
  final Color favoriteIconColor;

  String identifier = '';

  NetworkImage? image;
  Color? backgroundColor;
  Color? foregroundColor;
}
