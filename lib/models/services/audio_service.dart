import 'package:audioplayers/audioplayers.dart';

class SuffixAudioService {
  late AudioPlayer globalAudioPlayer;

  static SuffixAudioService? _instance;

  SuffixAudioService._internal();

  factory SuffixAudioService() {
    _instance ??= SuffixAudioService._internal();

    return _instance!;
  }

  initAudio() async {
    print("trying to play audio");
    globalAudioPlayer = AudioPlayer();
    await globalAudioPlayer
        .play(AssetSource("music/global_music2.mpeg", mimeType: "mp3"));
    globalAudioPlayer.setPlaybackRate(0.8);
    // globalAudioPlayer
    // globalAudioPlayer.pl
    // globalAudioPlayer.
  }

  stopAudio() {
    print("stopping audio......");
    globalAudioPlayer.stop();
  }
}
