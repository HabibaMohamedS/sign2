// lib/flex_delegate.dart
import 'dart:ffi';
import 'package:tflite_flutter/tflite_flutter.dart';

/// A minimal Flex‐ops delegate (pulled from tflite_flutter_helper internals).
class FlexDelegate extends Delegate {
  Pointer<Void>? _delegateAddress;

  @override
  Pointer<Void> createDelegate() {
    _delegateAddress = _createFlexDelegate();
    return _delegateAddress!;
  }

  @override
  void delete() {
    if (_delegateAddress != null) {
      _deleteFlexDelegate(_delegateAddress!);
      _delegateAddress = null;
    }
  }

  @override
  Pointer<Void>? get base => _delegateAddress;

  // FFI bindings to the native TensorFlow Lite library:
  static late final Pointer<Void> Function() _createFlexDelegate =
      DynamicLibrary.process()
          .lookupFunction<Pointer<Void> Function(), Pointer<Void> Function()>(
    'TfLiteFlexDelegateCreate',
  );

  static late final void Function(Pointer<Void>) _deleteFlexDelegate =
      DynamicLibrary.process()
          .lookupFunction<Void Function(Pointer<Void>), void Function(Pointer<Void>)>(
    'TfLiteFlexDelegateDelete',
  );
}
