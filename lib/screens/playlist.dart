import 'package:flutter/material.dart';
import 'package:music_player/models/playlist_provider.dart';
import 'package:music_player/models/song.dart';
import 'package:music_player/screens/music_player.dart';
import 'package:provider/provider.dart';

class PlayList extends StatefulWidget {
  const PlayList({Key? key}) : super(key: key);

  @override
  State<PlayList> createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {
  late final dynamic playlistProvider;

  @override
  void initState() {
    super.initState();
    playlistProvider = Provider.of<PlayListProvider>(context, listen: false);
  }

  void goToSong(int songIndex) {
    playlistProvider.currentSongIndex = songIndex;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MusicPlayer(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black26, Colors.blueGrey],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Center(
              child: Text(
                'M Y   P L A Y L I S T',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          body: Consumer<PlayListProvider>(builder: (context, value, child) {
            final List<Song> playList = value.playlist;
            return ListView.builder(
                itemCount: playList.length,
                itemBuilder: (context, index) {
                  final Song song = playList[index];
                  return ListTile(
                    title: Text(
                      song.songName,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      song.author,
                      style: const TextStyle(
                          color: Colors.white54,
                          overflow: TextOverflow.ellipsis),
                    ),
                    leading: AspectRatio(
                      aspectRatio: 1.0,
                      child: Image.asset(
                        song.albumCover,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // trailing: Icon(
                    //   Icons.favorite_border,
                    //   color: Colors.white24,
                    // ),
                    onTap: () => goToSong(index),
                  );
                });
          })),
    );
  }
}
