import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rhythm/consts/text_style.dart';
import 'package:rhythm/consts/colors.dart';
import 'package:rhythm/controllers/player_controller.dart';
import "package:on_audio_query/on_audio_query.dart";
import 'package:rhythm/views/player.dart';
// Import the search screen

class Home extends StatelessWidget {
  Home({super.key});

  final controller = Get.put(PlayerController());

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());

    return Scaffold(
      backgroundColor: bgDarkColor,
      appBar: AppBar(
        backgroundColor: bgDarkColor,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: whiteColor),
            onPressed: () {},
          ),
        ],
        leading: Icon(Icons.sort_rounded, color: whiteColor),
        title: Text(
          "Rhythm",
          style: ourStyle(
            family: nataile,
            size: 18,
          ),
        ),
      ),
      body: FutureBuilder<List<SongModel>>(
        future: controller.audioQuery.querySongs(
          ignoreCase: true,
          orderType: OrderType.ASC_OR_SMALLER,
          sortType: null,
          uriType: UriType.EXTERNAL,
        ),
        builder:
            (BuildContext context, AsyncSnapshot<List<SongModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No Song Found",
                style: ourStyle(),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  var song = snapshot.data![index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: Obx(
                      () => ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        tileColor: bgColor,
                        title: Text(
                          song.title, // Use the song title
                          style: ourStyle(
                              color: whiteColor, family: bold, size: 12),
                        ),
                        subtitle: Text(
                          song.artist ??
                              "Unknown Artist", // Use the song artist
                          style: ourStyle(
                              color: whiteColor, family: regular, size: 12),
                        ),
                        leading: QueryArtworkWidget(
                          id: snapshot.data![index].id,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: const Icon(
                            Icons.music_note,
                            color: whiteColor,
                            size: 32,
                          ),
                        ), //fordisplaying image of music
                        trailing: controller.playIndex == index &&
                                controller.isPlaying.value
                            ? const Icon(
                                Icons.play_arrow,
                                color: whiteColor,
                                size: 26,
                              )
                            : null,
                        onTap: () {
                          Get.to(() => Player(
                                data: [song],
                              ));
                          controller.playSong(snapshot.data![index].uri, index);
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
