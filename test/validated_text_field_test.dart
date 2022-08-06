import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';

import 'package:validated_text_field/validated_text_field.dart';

enum KekError {
  error1,
  error2,
  error3,
}

class Kek extends FormzInput<String, KekError> {
  Kek.pure() : super.pure('');
  Kek.dirty(super.value) : super.dirty();

  @override
  KekError? validator(String value) {
    if (value.contains('1')) return KekError.error1;
    if (value.contains('2')) return KekError.error2;
    if (value.contains('3')) return KekError.error3;
    return null;
  }
}

const _defaultKey = Key('tmp');

Widget _getValidatedField(ValidatedTextInputField field) => MaterialApp(
      key: null,
      title: '',
      home: Scaffold(
        key: null,
        body: Center(
          key: null,
          child: field,
        ),
      ),
    );

Widget _getDefaultField(Kek initialInput) => _getValidatedField(
      ValidatedTextInputField<Kek, KekError>(
        key: _defaultKey,
        initialInput: initialInput,
        standardErrorText: 'failure',
        getErrorSpecificText: (error) => error.toString(),
      ),
    );

void main() {
  testWidgets(
    'ValidatedTextInputField is correctly rendered.',
    (tester) async {
      await tester.pumpWidget(_getDefaultField(Kek.pure()));

      final fieldFinder = find.byKey(_defaultKey);
      expect(fieldFinder, findsOneWidget);
    },
  );

  testWidgets(
    'ValidatedTextInputField shows error message when invalid.',
    (tester) async {
      await tester.pumpWidget(_getDefaultField(Kek.dirty('hey1')));

      final errorFinder = find.textContaining(KekError.error1.toString());
      expect(errorFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Does not show error after inputting valid input.',
    (tester) async {
      await tester.pumpWidget(_getDefaultField(Kek.pure()));

      await tester.enterText(find.byKey(_defaultKey), 'this is a valid input.');

      await tester.pump();

      final error1Finder = find.textContaining(KekError.error1.toString());
      final error2Finder = find.textContaining(KekError.error2.toString());
      final error3Finder = find.textContaining(KekError.error3.toString());
      expect(error1Finder, findsNothing);
      expect(error2Finder, findsNothing);
      expect(error3Finder, findsNothing);
    },
  );

  testWidgets(
    'Does show error after invalid input.',
    (tester) async {
      await tester.pumpWidget(_getDefaultField(Kek.pure()));

      await tester.enterText(
          find.byKey(_defaultKey), 'this is 1 invalid input.');

      await tester.pump();

      final error1Finder = find.textContaining(KekError.error1.toString());
      expect(error1Finder, findsOneWidget);
    },
  );

  testWidgets(
    'Does not show error after invalid input corrected to valid.',
    (tester) async {
      await tester.pumpWidget(_getDefaultField(Kek.pure()));

      await tester.enterText(
          find.byKey(_defaultKey), 'this is 1 invalid input.');

      await tester.pump();

      await tester.enterText(find.byKey(_defaultKey), 'this is a valid input.');

      await tester.pump();

      final error1Finder = find.text(KekError.error1.toString());
      expect(error1Finder, findsNothing);
    },
  );

  testWidgets(
    'Does show error after valid input changed to invalid.',
    (tester) async {
      await tester.pumpWidget(_getDefaultField(Kek.pure()));

      await tester.enterText(find.byKey(_defaultKey), 'this is a valid input.');

      await tester.pump();

      await tester.enterText(
          find.byKey(_defaultKey), 'this is 1 invalid input.');

      await tester.pump();

      final error1Finder = find.textContaining(KekError.error1.toString());
      expect(error1Finder, findsOneWidget);
    },
  );

  testWidgets(
    'Does not show error after invalid input and hideErrorMessageUntilFirstSubmit is true and not submitted yet.',
    (tester) async {
      await tester.pumpWidget(_getValidatedField(ValidatedTextInputField(
        key: _defaultKey,
        initialInput: Kek.pure(),
        standardErrorText: 'failure',
        getErrorSpecificText: (error) => error.toString(),
        hideErrorMessageUntilFirstSubmit: true,
      )));

      await tester.enterText(
          find.byKey(_defaultKey), 'this is 1 invalid input.');

      await tester.pump();

      final error1Finder = find.textContaining(KekError.error1.toString());
      expect(error1Finder, findsNothing);
    },
  );

  testWidgets(
    'Does show error after invalid input submitted and hideErrrorMessageUntilFirstSubmit is true.',
    (tester) async {
      //TODO: write this test
      expect(true, false);
    },
  );
}
