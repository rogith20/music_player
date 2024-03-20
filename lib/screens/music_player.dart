import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:music_player/models/audio_visualiser.dart';
import 'package:music_player/models/playlist_provider.dart';
import 'package:provider/provider.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({Key? key}) : super(key: key);
  String formatTime(Duration duration) {
    String minsec = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    String formattedTime = '${duration.inMinutes}:$minsec';
    return formattedTime;
  }

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayListProvider>(
      builder: (context, value, child) {
        final playList = value.playlist;
        final currentSong = playList[value.currentSongIndex ?? 0];
        final isPlaying = value.isPlaying;

        if (isPlaying) {
          _controller.repeat();
        } else {
          _controller.stop();
        }

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black26, currentSong.color],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.transparent,
              title: const Text(
                'N O W   P L A Y I N G',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              centerTitle: true,
            ),
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _controller.value * 2.0 * math.pi,
                          child: Image.asset(
                            'assets/disc.png',
                            height: 350,
                            width: 350,
                          ),
                        );
                      },
                    ),
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _controller.value * 2.0 * math.pi,
                          child: CircleAvatar(
                            radius: 75,
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage(currentSong.albumCover),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(250, 0, 0, 250),
                      child: Image.asset(
                        "assets/stylus_alt.png",
                        width: 140,
                        height: 140,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  currentSong.songName,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  currentSong.author,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w300),
                ),
                Column(
                  children: [
                    Slider(
                      min: 0,
                      max: value.totalDuration.inSeconds
                          .toDouble()
                          .clamp(0, 500),
                      value: value.currentDuration.inSeconds.toDouble(),
                      activeColor: currentSong.color.withOpacity(1),
                      onChanged: (double double) {},
                      onChangeEnd: (double double) {
                        value.seek(Duration(seconds: double.toInt()));
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.formatTime(value.currentDuration),
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            widget.formatTime(value.totalDuration),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.skip_previous,
                          size: 35, color: Colors.white70),
                      onPressed: () {
                        value.prevSong();
                      },
                    ),
                    IconButton(
                        icon: value.isPlaying
                            ? const Icon(Icons.pause_circle,
                                size: 50, color: Colors.white70)
                            : const Icon(Icons.play_circle,
                                size: 50, color: Colors.white70),
                        onPressed: () {
                          value.both();
                        }),
                    IconButton(
                      icon: const Icon(Icons.skip_next,
                          size: 35, color: Colors.white70),
                      onPressed: () {
                        value.nextSong();
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: AudioVisualizer(
                        controller: _controller,
                        songColor: Provider.of<PlayListProvider>(context)
                            .playlist[Provider.of<PlayListProvider>(context)
                                .currentSongIndex!]
                            .color),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
