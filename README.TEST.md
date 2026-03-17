1. flutter_test — ASOSIY TEST FUNKSIYALAR

main()                  — Barcha testlarning kirish nuqtasi. Har bir test fayli void main() bilan boshlanadi.
group('nom', () {})     — Testlarni mantiqiy guruhlarga ajratadi. Masalan group('CrewBloc - Movie', ...).
test('nom', () {})      — Oddiy unit test. UI bilan aloqasi yo'q, faqat logika tekshiradi.
testWidgets('nom', (tester) {}) — Widget test. Flutter UI widgetlarini render qilib tekshiradi.
setUp(() {})            — Har bir test OLDIDAN ishga tushadi. Mock obyektlarni qayta yaratish uchun.
setUpAll(() {})         — Barcha testlar oldidan BIR MARTA ishga tushadi. registerFallbackValue kabi global sozlashlar uchun.
addTearDown(() {})      — Joriy test tugagandan keyin tozalik qiladi (masalan FlutterError.onError ni asl holiga qaytarish).
expect(actual, matcher) — Testning asosiy tekshiruv funksiyasi. actual qiymatni matcher bilan solishtiradi.

2. MATCHERLAR — expect ichida solishtirish uchun

findsOneWidget          — Ekranda aynan 1 ta widget topilishini tekshiradi.
findsNothing            — Ekranda hech narsa topilmasligini tekshiradi.
findsNWidgets(n)        — Aynan n ta widget topilishini tekshiradi.
findsAtLeastNWidgets(n) — Kamida n ta widget topilishini tekshiradi.
isA<Type>()             — Obyekt berilgan tipga tegishli ekanligini tekshiradi. Masalan isA<CrewNoData>().
isTrue / isFalse        — Boolean qiymatni tekshiradi.


3. FINDERLAR — widgetlarni topish uchun

find.text('Pay')                     — Ekranda "Pay" matni bo'lgan widgetni topadi.
find.byType(DateWidget)              — Berilgan tip bo'yicha widgetni topadi.
find.byIcon(Icons.star)              — Berilgan ikonka bo'yicha widgetni topadi.
find.byWidgetPredicate((w) => ...)   — O'z shartingiz bilan widgetni topadi.
find.ancestor(of: ..., matching: ...) — Berilgan widgetning ota-onasini topadi.


4. WidgetTester — tester.xxx funksiyalari

tester.pumpWidget(widget)            — Widgetni test muhitiga render qiladi (birinchi marta chiqarish).
tester.pump(Duration)                — Berilgan vaqtcha animatsiya/timerni ilgari suradi. Masalan pump(Duration(seconds: 1)).
tester.pumpAndSettle()               — Barcha animatsiyalar to'liq tugaguncha kutadi. Animatsiya to'xtamasa timeout beradi.
tester.tap(finder)                   — Topilgan widgetni bosadi (tap qiladi).
tester.tap(finder, warnIfMissed: false) — Widgetni bosadi, hit-test muvaffaqiyatsiz bo'lsa ham xato bermaydi.
tester.widget<T>(finder)             — Topilgan widgetni T tipidagi obyekt sifatida oladi.
tester.ensureVisible(finder)         — Widgetni scroll qilib ekranga ko'rinadigan qiladi.
tester.element(finder)               — Widgetning Element ini qaytaradi (BuildContext olish uchun).


5. MOCKTAIL — SOXTA OBYEKTLAR

class MockRepository extends Mock implements Repository {}
— Repository ning soxta versiyasini yaratadi. Haqiqiy API chaqirilmaydi.

when(() => mock.method(any())).thenAnswer((_) async => data)
— Mock metod chaqirilganda berilgan javobni qaytaradi.

when(() => mock.method(any())).thenThrow(exception)
— Mock metod chaqirilganda xatolik tashlaydi.

any()
— Har qanday argumentni qabul qiladi (argument qiymati muhim emas).

verify(() => mock.method(...)).called(1)
— Metod aynan 1 marta chaqirilganini tekshiradi.

verifyNever(() => mock.method(...))
— Metod hech qachon chaqirilmaganini tekshiradi.

registerFallbackValue(value)
— any() ishlatilganda fallback qiymat ro'yxatdan o'tkaziladi.


6. BLOC_TEST — BLoC testlari uchun

blocTest<Bloc, State>(
'tavsif',
build: ()  — BLoC obyektni yaratadi va mock sozlamalarini qiladi,
act: (bloc) — BLoC ga event yuboradi. Masalan bloc.add(LoadCrew(1, true)),
expect: ()  — BLoC chiqarishi kerak bo'lgan state lar ketma-ketligini tekshiradi,
)

MockBloc<Event, State>                      — BLoC ning soxta versiyasini yaratadi.
BlocProvider<Bloc>.value(value: mockBloc)   — Test widgetlariga mock BLoC ni taqdim etadi.
MultiBlocProvider(providers: [...])          — Bir nechta BLoC ni birgalikda taqdim etadi.

7. FlutterError boshqarish (test ichida)

final originalOnError = FlutterError.onError;
FlutterError.onError = (details) {
if (details.exceptionAsString().contains('overflowed')) return;
originalOnError?.call(details);
};
addTearDown(() => FlutterError.onError = originalOnError);
— Test muhitidagi layout overflow xatolarini bostiradi, test fail bo'lmasligi uchun.
