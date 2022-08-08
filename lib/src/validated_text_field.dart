import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

class ValidatedTextInputField<T extends FormzInput<String, E>, E>
    extends StatefulWidget {
  final T initialInput;
  final Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final String Function(E)? getErrorSpecificText;
  final String? fallbackErrorText;
  final TextInputType keyboardType;
  final int errorDisplayThreshold;
  final InputDecoration inputDecoration;
  final bool hideErrorMessageUntilFirstSubmit;
  const ValidatedTextInputField({
    Key? key,
    required this.initialInput,
    this.fallbackErrorText,
    this.inputDecoration = const InputDecoration(
      errorStyle: TextStyle(color: Colors.red),
    ),
    this.onChanged,
    this.onSubmitted,
    this.getErrorSpecificText,
    this.keyboardType = TextInputType.name,
    this.errorDisplayThreshold = 3,
    this.hideErrorMessageUntilFirstSubmit = false,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ValidatedTextInputFieldState<E> createState() =>
      _ValidatedTextInputFieldState<E>();
}

class _ValidatedTextInputFieldState<E> extends State<ValidatedTextInputField> {
  final _controller = TextEditingController();
  bool _isValid = false;
  bool _hasSubmitted = false;
  String? _errorMessage;

  @override
  void initState() {
    if (!widget.initialInput.pure) {
      _controller.text = widget.initialInput.value;
      _isValid = widget.initialInput.valid;
    }
    super.initState();
  }

  void _onTextChanged(String newValue) async {
    final E? validationResult = widget.initialInput.validator(newValue);
    setState(() {
      if (validationResult == null) {
        _isValid = true;
      } else {
        _isValid = false;
        if (newValue.length >= widget.errorDisplayThreshold) {
          _errorMessage = widget.getErrorSpecificText?.call(validationResult) ??
              widget.fallbackErrorText ??
              'failure';
        }
      }
    });

    widget.onChanged?.call(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: null,
      controller: _controller,
      onChanged: _onTextChanged,
      onSubmitted: (newVal) {
        if (!_hasSubmitted) {
          setState(() {
            _hasSubmitted = true;
          });
        }
        widget.onSubmitted?.call(newVal);
      },
      keyboardType: widget.keyboardType,
      decoration: widget.inputDecoration.copyWith(
        errorText: !_isValid &&
                _controller.text.isNotEmpty &&
                (!widget.hideErrorMessageUntilFirstSubmit || _hasSubmitted)
            ? _errorMessage
            : null,
      ),
    );
  }
}
