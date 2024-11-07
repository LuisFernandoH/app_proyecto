import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('lib/assets/images/intro.mp4')
      ..initialize().then((_) {
        setState(() {}); // Refresca la pantalla cuando el video esté listo
        _controller.setVolume(1.0); // Ajusta el volumen al 100%
        _controller.play(); // Empieza a reproducir el video automáticamente
      });

    // Escucha el estado del video para saber cuándo termina
    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        // Redirige a la pantalla principal cuando el video termine
        Navigator.pushReplacementNamed(context, 'home');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            ? ClipRect( // Limita el área del video
                child: Transform.scale(
                  scale: 1.5, // Cambia este valor para ajustar el zoom
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                ),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
