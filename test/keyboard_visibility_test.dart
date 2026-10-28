import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:keep_keyboard_popup_menu/keep_keyboard_popup_menu.dart';

void main() {
  setUp(() => KeyboardVisibilityTesting.setVisibilityForTesting(true));

  Future<void> openMenu(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: KeepKeyboardPopupMenuButton(
          menuItemBuilder: (context, closePopup) => [
            KeepKeyboardPopupMenuItem(
              child: const Text('Menu action'),
              onTap: closePopup,
            ),
          ],
        ),
      ),
    ));
    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();
    expect(find.text('Menu action'), findsOneWidget);
  }

  testWidgets('keyboard hidden event closes an open menu', (tester) async {
    await openMenu(tester);
    KeyboardVisibilityTesting.setVisibilityForTesting(false);
    await tester.pumpAndSettle();
    expect(find.text('Menu action'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('menu action closes the popup', (tester) async {
    await openMenu(tester);
    await tester.tap(find.text('Menu action'));
    await tester.pumpAndSettle();
    expect(find.text('Menu action'), findsNothing);
    await tester.pumpWidget(const SizedBox());
    KeyboardVisibilityTesting.setVisibilityForTesting(false);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
