import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../../application/events/model/events_model.dart';
import '../../../../constant/app_urls.dart';

class EventCarouselSlider extends StatefulWidget {
  final String? youtubeUrl;
  final List<Images>? images;
  const EventCarouselSlider({super.key, this.youtubeUrl, this.images});

  @override
  State<EventCarouselSlider> createState() => _EventCarouselSliderState();
}

class _EventCarouselSliderState extends State<EventCarouselSlider> {
  @override
  void didUpdateWidget(covariant EventCarouselSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.youtubeUrl != oldWidget.youtubeUrl) {
      // Dispose old controller
      _youtubeController?.dispose();
      _youtubeController = null;
      _youtubeId = null;
      initPlayer();
      setState(() {});
    }
  }

  CarouselController? _carouselController;
  YoutubePlayerController? _youtubeController;
  String? _youtubeId;
  int? _currentIndex = 0;
  bool get hasYoutube => _youtubeId != null;

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  void initPlayer() {
    if (widget.youtubeUrl != null && widget.youtubeUrl!.isNotEmpty) {
      _youtubeId = YoutubePlayer.convertUrlToId(widget.youtubeUrl!);
      if (_youtubeId != null) {
        _youtubeController = YoutubePlayerController(
          initialVideoId: _youtubeId!,
          flags: YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
            disableDragSeek: true,
            loop: false,
            showLiveFullscreenButton: false,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _carouselController?.dispose();
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final itemCount = (widget.images?.length ?? 0) + (hasYoutube ? 1 : 0);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 8),
        CarouselSlider.builder(
          itemCount: itemCount,
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height * 0.28,
            enlargeCenterPage: true,
            autoPlay: false,
            viewportFraction: 0.96,
            enlargeFactor: 0.2,
            enableInfiniteScroll: false,
            onPageChanged: (index, reason) {
              if (hasYoutube && index != 0) {
                _youtubeController?.pause();
              }
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          itemBuilder: (context, index, realIndex) {
            if (hasYoutube && index == 0) {
              return YoutubePlayer(
                controller: _youtubeController!,
                showVideoProgressIndicator: false,
                progressIndicatorColor: theme.colorScheme.primary.withAlpha(
                  200,
                ),
                progressColors: ProgressBarColors(
                  playedColor: theme.colorScheme.primary.withAlpha(150),
                  handleColor: theme.colorScheme.primary,
                ),
              );
            }
            final img = widget.images?[index - (hasYoutube ? 1 : 0)];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: img != null && img.imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(AppUrls.imageUrl + img.imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
            );
          },
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            itemCount,
            (index) => Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index
                    ? theme.colorScheme.primary
                    : theme.colorScheme.primary.withOpacity(0.4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
