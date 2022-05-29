import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player_example/widgets/api_base_helper.dart';
import 'package:music_player_example/widgets/audio_widget.dart';
import 'package:music_player_example/models/song.dart';
import 'package:dio/dio.dart';

import '../../constants.dart';

class MusicPlayerPage extends StatefulWidget {
  @override
  _MusicPlayerPageState createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {

  //Init HTTP handler using custom API helper
  ApiBaseHelper api = ApiBaseHelper();
  late List<Song> itemList;
  //Define song async snapshot
  late Future<List<Song>> _future;
  //Timer for debounching serach bar
  Timer? _debounce;
  //Define search bar controller
  TextEditingController searchController = TextEditingController();
  //Init Audio Player
  AudioPlayer audioPlayer = AudioPlayer();
  //flag for current index of played song
  int idxSong = -99;


  @override
  void initState() { //init search using default term : jack johnson
    super.initState();
    _future = _fetchItems("jack johnson."); // init async snapshot
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    //create layout page
    return Scaffold(
        backgroundColor: BasePalette.primary,
        body: Container(
            height: height,
            color: BasePalette.primary,
            child:SafeArea(
                child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child:Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(height: 50,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 5),
                                      Text("Music Player - Itunes", style: TextStyle(color: BasePalette.accent, fontFamily: "NeoSansBold", fontSize: 16),),
                                      const SizedBox(height: 5),
                                    ],
                                  )
                                ],
                              ),
                              _searchBar(),
                            ],
                          )
                      ),
                      Expanded(
                          flex: 6,
                          child: _body()
                      )
                    ])
            )
        )
    );
  }

  Widget _searchBar(){
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft:Radius.circular(10),
          bottomRight: Radius.circular(10)
        ),
        gradient: LinearGradient(
            colors: [BasePalette.accent, BasePalette.accent],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(0.8, 0.0),
            stops: const [0.0, 1.0],
            tileMode: TileMode.clamp
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5), // changes position of shadow
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) {
          _onSearchChanged(value);
        },
        controller: searchController,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            //labelText: "Search",
            hintText: "Search",
            prefixIcon: Icon(Icons.search, color: BasePalette.accent,),
            // border: InputBorder.none,
            // enabledBorder: OutlineInputBorder(
            //   borderSide: BorderSide(color: Colors.grey, width: 0.0),
            // ),
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(12.0)))
        ),
      ),
    );
  }

  //Search TextField Listener Method
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    //implement debounce technique to limit a function from getting called too frequently
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      //Call Fetch Data Method
      setState(() {
        _future = _fetchItems(query);
      });
    });
  }

  Widget _body(){
    //implement Listview using Refresh Indicator
    return RefreshIndicator(
        //call refresh handler
        onRefresh: _pullRefresh,
        //async List view
        child: FutureBuilder<List<Song>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasData) { // data found
              print(snapshot.data);
              // Get Data Snapshot from future
              // Display the result using List Song Builder
              List<Song>? songs = snapshot.data;
              if(songs!.isEmpty)  return const Center(child: Text('media not found')); // empty list handler
              //generate list view using itemsListSong Method
              return itemsListSong(songs);
            } else if (snapshot.hasError) { // request or snapshot error or technical issue
              return Center(child:Text("${snapshot.error}"));
            }
            // first handler for empty data
            return const Center(
                child: CircularProgressIndicator()
            );
          },
        )
    );
  }

  //pull refresh listener
  //fetch song from itune api using default term
  Future<void> _pullRefresh() async {
    //async process to update future data snapshot
    setState(() {
      _future = _fetchItems("jack johnson"); // jack jason is default term
    });
  }

  Future<List<Song>> _fetchItems(String query) async{
    //Request to itunes endpoint API
    Response? response = await api.getHTTP("search?term="+query+"&media=music");
    if (response != null) {
      //convert string of result to map of json
      Map res = json.decode(response.data);
      print(res);
      //get results values
      List data = res["results"];
      //return parsed song from json to list of song
      return data.map((item) => Song.fromJson(item)).toList();
    } else {
      //result not found or error
      return List.empty();
    }
  }

  ListView itemsListSong(List<Song>? items) {
    //List View Generator
    return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: items!.length,
        itemBuilder: (context, index) {
          // add Gesture Detector and listener
          return GestureDetector( //You need to make my child interactive
              onTap: () {
                // play(items[index].previewUrl);
                setState(() {
                  idxSong = index;
                });
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context){
                      return AudioWidget(
                        totalTime: Duration(minutes: 1, seconds: 15),
                        song: items[index],
                        audioPlayer: audioPlayer,
                        trackSelected: idxSong,
                      );
                    }
                );
              },
              child: _tile(items[index], index)
          );
        });
  }

  play(url) async {
    audioPlayer.setUrl(url, isLocal: false);
    // int durationMilisecond = await audioPlayer.getDuration();
    // Duration duration = Duration(milliseconds: durationMilisecond);
    // print("sukses"+duration.inSeconds.toString());
    int result = await audioPlayer.play(url);
    // int a = await audioPlayer.getDuration();
    // print("onDurationChange "+a.toString());
    if (result == 1) {
      // success
      // int duration = await audioPlayer.getDuration();
      // int cur = await audioPlayer.getCurrentPosition();
      // print("sukses " + duration.toString()+ " cur: "+ cur.toString());
    }
  }

  //Item Tile Layout
  Container _tile(Song song, int idx){
    return Container(
      //Create margin
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        // Style and decoration Box
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
              bottomLeft: Radius.circular(10.0)
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 5), // changes position of shadow
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20,),
        // Content of Tile
        child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  //Left Side
                  //Image of 60x60 artwork track
                  Expanded(
                      flex:1,
                      child: FadeInImage.assetNetwork(placeholder: 'assets/images/music-blue.png', image: song.artworkUrl60) //Image.network()//Icon(Icons.perm_contact_cal, size: 60, color: BasePalette.accent,)
                  ),
                  //Right Side
                  //Info of the track
                  Expanded(
                      flex: 4,
                      child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(song.trackName, style: TextStyle(
                                  fontSize: 16.0,
                                  color: BasePalette.accent,
                                  fontFamily: "NeoSansBold")),
                              Text(song.artistName),
                              Text(song.collectionName)
                            ],
                          )
                      )
                  ),
                  idx == idxSong? const Expanded(child: Icon(Icons.volume_up_rounded)):const SizedBox(width: 100,)
                ],
              )]
        )
    );
  }
}
