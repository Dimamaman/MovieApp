import 'package:equatable/equatable.dart';

class ThemeState extends Equatable {
  final bool isDarkTheme;

  const ThemeState({required this.isDarkTheme});

  @override
  List<Object> get props => [isDarkTheme];
}

