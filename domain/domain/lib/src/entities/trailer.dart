import 'package:equatable/equatable.dart';

class Trailer extends Equatable {
  final String id;
  final String title;
  final String youtubeId;
  final String youtubeUrl;

  const Trailer({
    required this.id,
    required this.title,
    required this.youtubeId,
    required this.youtubeUrl,
  });

  @override
  List<Object> get props => [id, title, youtubeId, youtubeUrl];
}

