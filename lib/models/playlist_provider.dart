import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/models/song.dart';

class PlayListProvider extends ChangeNotifier {
  final List<Song> _playlist = [
    Song(
      songName: 'Anbenum',
      author: 'Anirudh Ravichander, Lothika',
      albumCover: 'assets/Anbenum.jpeg',
      audioPath: 'Anbenum.mp3',
      color: Colors.blue.shade200,
    ),
    Song(
      songName: 'Badass',
      author: 'Anirudh Ravichander',
      albumCover: 'assets/Badass.jpg',
      audioPath: 'Badass.mp3',
      color: const Color(0xFFFF0000).withOpacity(0.5),
    ),
    Song(
      songName: 'Bloody Sweet',
      author: 'Anirudh Ravichander, Siddharth Basrur',
      albumCover: 'assets/Bloody Sweet.jpeg',
      audioPath: 'Bloody Sweet.mp3',
      color: Colors.brown,
    ),
    Song(
      songName: 'Glimpse of Antony Das',
      author: 'Anirudh Ravichander',
      albumCover: 'assets/Glimpse of Antony Das.jpg',
      audioPath: 'Glimpse of Antony Das.mp3',
      color: Colors.grey,
    ),
    Song(
        songName: 'Glimpse of Harold Das',
        author: 'Anirudh Ravichander',
        albumCover: 'assets/Glimpse of Harold Das.jpg',
        audioPath: 'Glimpse of Harold Das.mp3',
        color: const Color(0xff486055)),
    Song(
      songName: 'Im Scared',
      author: 'Anirudh Ravichander',
      albumCover: 'assets/Im Scared.jpeg',
      audioPath: 'Im Scared.mp3',
      color: Colors.redAccent,
    ),
    Song(
      songName: 'Lokiverse 2.0',
      author: 'Anirudh Ravichander',
      albumCover: 'assets/Lokiverse 2.0.jpg',
      audioPath: 'Lokiverse 2.0.mp3',
      color: Colors.tealAccent,
    ),
    Song(
      songName: 'Naa Ready',
      author: 'Anirudh Ravichander',
      albumCover: 'assets/Naa Ready.jpg',
      audioPath: 'Naa Ready.mp3',
      color: Colors.amber,
    ),
    Song(
      songName: 'Ordinary Person',
      author: 'Anirudh Ravichander, Nikhita Gandhi',
      albumCover: 'assets/Ordinary Person.jpg',
      audioPath: 'Ordinary Person.mp3',
      color: Colors.white,
    ),
    Song(
      songName: 'Villain Yaaru',
      author: 'Anirudh Ravichander, Sakthisree Gopalan',
      albumCover: 'assets/Villain Yaaru.jpg',
      audioPath: 'Villain Yaaru.mp3',
      color: Colors.orangeAccent,
    ),
  ];

  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;
  PlayListProvider() {
    listenToDuration();
  }

  bool _isPlaying = false;

  void play() async {
    final String path = _playlist[_currentSongIndex!].audioPath;
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(path));
    _isPlaying = true;
    notifyListeners();
  }

  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  void both() async {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  void nextSong() {
    if (_currentSongIndex != null) {
      if (_currentSongIndex! < _playlist.length - 1) {
        currentSongIndex = _currentSongIndex! + 1;
      } else {
        currentSongIndex = 0;
      }
    }
  }

  void prevSong() async {
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    } else {
      if (_currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        currentSongIndex = _playlist.length - 1;
      }
    }
  }

  void listenToDuration() {
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      nextSong();
      notifyListeners();
    });
  }

  int? _currentSongIndex;
  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  set currentSongIndex(int? newIndex) {
    _currentSongIndex = newIndex;
    if (newIndex != null) {
      play();
    }

    notifyListeners();
  }
}
