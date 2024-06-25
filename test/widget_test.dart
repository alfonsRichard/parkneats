import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/main.dart';

void main() {
  testWidgets('App navigation test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that we are on the SplashScreen initially.
    expect(find.text("PARK N' EATS"), findsOneWidget);

    // Wait for splash screen duration to pass.
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Verify that we are on the OnBoarding screen.
    expect(find.text("Welcome to Park N' Eats"), findsOneWidget);

    // Tap the 'Get Started' button.
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    // Verify that we are on the LoginPage.
    expect(find.text('Welcome Back!'), findsOneWidget);

    // Tap the 'Sign Up' link.
    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();

    // Verify that we are on the SignUpPage.
    expect(find.text('Create your account'), findsOneWidget);
  });
}
