import 'package:flutter/material.dart';

class Song {
  final String songName;
  final String author;
  final String albumCover;
  final String audioPath;
  final Color color;

  Song({
    required this.songName,
    required this.author,
    required this.albumCover,
    required this.audioPath,
    required this.color,
  });
}
