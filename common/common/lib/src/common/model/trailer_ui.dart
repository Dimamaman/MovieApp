import 'package:equatable/equatable.dart';

class TrailerUI extends Equatable {
  final String id;
  final String title;
  final String youtubeId;
  final String youtubeUrl;

  const TrailerUI({
    required this.id,
    required this.title,
    required this.youtubeId,
    required this.youtubeUrl,
  });

  @override
  List<Object> get props => [id, title, youtubeId, youtubeUrl];
}

