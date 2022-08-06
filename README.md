# validated_text_field

A Flutter Widget that automatically validates its input and displays error messages given a [FormzInput](https://pub.dev/packages/formz) instance.

## Features

* Provides a ValidatedTextInputField Widget.

## Getting started

Add the dependency to the package to your ```pubspec.yaml```:

```yaml
dependencies:
   validated_text_field:
    git:
      url: https://github.com/julienandco/validated_text_field
      ref: main
```

## Usage

```dart
enum TestError {
  error1,
  error2,
  error3,
}

class TestData extends FormzInput<String, TestError> {
  TestData.pure() : super.pure('');
  TestData.dirty(super.value) : super.dirty();

  @override
  TestError? validator(String value) {
    if (value.contains('1')) return TestError.error1;
    if (value.contains('2')) return TestError.error2;
    if (value.contains('3')) return TestError.error3;
    return null;
  }
}

...
@override
Widet build(BuildContext context){
    return ValidatedTextField(
        initialInput: TestData.pure(),
        standardErrorText: 'unknown error',
        getErrorSpecificText: (error) => error.toString(),
        onChanged: (value) {
        print(value);
        },
    );
}

```

## Additional information

Feel free to contact me if you have any questions, open some pull requests, or want to contribute to this package.
