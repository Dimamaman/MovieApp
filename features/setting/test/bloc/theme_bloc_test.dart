import 'package:bloc_test/bloc_test.dart';
import 'package:feature_setting/feature_setting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/test_helper.dart';

void main() {
  late MockSharedPrefHelper mockPrefHelper;

  setUp(() {
    mockPrefHelper = MockSharedPrefHelper();
  });

  group('ThemeBloc', () {
    test('initial state has isDarkTheme = false', () {
      final bloc = ThemeBloc(prefHelper: mockPrefHelper);
      expect(bloc.state, const ThemeState(isDarkTheme: false));
    });

    blocTest<ThemeBloc, ThemeState>(
      'emits ThemeState(true) when GetTheme and saved value is true',
      build: () {
        when(() => mockPrefHelper.getValueDarkTheme())
            .thenAnswer((_) async => true);
        return ThemeBloc(prefHelper: mockPrefHelper);
      },
      act: (bloc) => bloc.add(GetTheme()),
      expect: () => [
        const ThemeState(isDarkTheme: true),
      ],
    );

    blocTest<ThemeBloc, ThemeState>(
      'emits ThemeState(false) when GetTheme and saved value is false',
      build: () {
        when(() => mockPrefHelper.getValueDarkTheme())
            .thenAnswer((_) async => false);
        return ThemeBloc(prefHelper: mockPrefHelper);
      },
      act: (bloc) => bloc.add(GetTheme()),
      expect: () => [
        const ThemeState(isDarkTheme: false),
      ],
    );

    blocTest<ThemeBloc, ThemeState>(
      'emits ThemeState(true) when ThemeChanged to dark',
      build: () {
        when(() => mockPrefHelper.saveValueDarkTheme(true))
            .thenAnswer((_) async {});
        return ThemeBloc(prefHelper: mockPrefHelper);
      },
      act: (bloc) => bloc.add(const ThemeChanged(isDarkTheme: true)),
      expect: () => [
        const ThemeState(isDarkTheme: true),
      ],
    );

    blocTest<ThemeBloc, ThemeState>(
      'emits ThemeState(false) when ThemeChanged to light',
      build: () {
        when(() => mockPrefHelper.saveValueDarkTheme(false))
            .thenAnswer((_) async {});
        return ThemeBloc(prefHelper: mockPrefHelper);
      },
      act: (bloc) => bloc.add(const ThemeChanged(isDarkTheme: false)),
      expect: () => [
        const ThemeState(isDarkTheme: false),
      ],
    );
  });
}

