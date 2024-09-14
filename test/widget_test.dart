import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:farmers_mart/main.dart';
import 'package:farmers_mart/screens/loading_page.dart';
import 'package:farmers_mart/screens/login_page.dart';
import 'package:farmers_mart/screens/signup_page.dart';

void main() {
  testWidgets('LoadingPage has correct text and gradient',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoadingPage()));

    expect(find.text('Farmer\'s Mart'), findsOneWidget);

    final container = tester.widget<Container>(find.byType(Container));
    expect(container.decoration, isA<BoxDecoration>());
    final boxDecoration = container.decoration as BoxDecoration;
    expect(boxDecoration.gradient, isA<LinearGradient>());
  });

  testWidgets('LoginPage has correct widgets', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));

    expect(find.text('Welcome to Farmer\'s Mart'), findsOneWidget);
    expect(
        find.text('Login or Sign up to access your account'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.byType(ElevatedButton),
        findsNWidgets(4)); // Login + 3 social buttons
    expect(find.text('Don\'t have an account? Sign Up'), findsOneWidget);
  });

  testWidgets('SignUpPage has correct widgets', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignUpPage()));

    expect(find.text('Welcome to Farmer\'s Mart'), findsOneWidget);
    expect(find.text('Sign up to access your account'), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.text('Verify Number'), findsOneWidget);
    expect(find.byType(ElevatedButton),
        findsNWidgets(4)); // Verify + 3 social buttons
    expect(find.text('Already have an account? Login'), findsOneWidget);
  });

  testWidgets('FarmersMartApp has correct initial route',
      (WidgetTester tester) async {
    await tester.pumpWidget(FarmersMartApp());

    expect(find.byType(LoadingPage), findsOneWidget);
  });

  testWidgets('LoadingPage navigates to LoginPage after delay',
      (WidgetTester tester) async {
    await tester.pumpWidget(FarmersMartApp());

    expect(find.byType(LoadingPage), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
  });
}
