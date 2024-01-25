import 'dart:ffi';
import 'dart:io';

import 'ffigen_app_bindings_generated.dart';

/// A very short-lived native function.
///
/// For very short-lived functions, it is fine to call them on the main isolate.
/// They will block the Dart execution while running the native function, so
/// only do this for native functions which are guaranteed to be short-lived.

const String _libName = 'ffigen_app';

/// The dynamic library in which the symbols for [FfigenAppBindings] can be found.
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dylib].
final FfigenAppBindings _bindings = FfigenAppBindings(_dylib);

class A implements Finalizable {
  Pointer<Void> handle;
  static final _finalizer = NativeFinalizer(_bindings.releaseAPtr.cast());

  A(this.handle);

  factory A.generate() {
    // Create the native instance (std::shared_ptr<A>*)
    final AInstance = _bindings.create_A();
    // AHandle.handle is the std::shared_ptr<A>* instance
    final AHandle = A(AInstance);
    // Register the finalizer for AHandle
    _finalizer.attach(AHandle, AInstance.cast(), detach: AHandle);
    // Return the A object on the Dart side
    return AHandle;
  }

  int getValue() {
    return _bindings.get_Value(handle);
  }

  int getUseCount() {
    return _bindings.refCount(handle);
  }

  void setValue(int val) {
    _bindings.set_Value(handle, val);
  }
}

class A_Container implements Finalizable {
  Pointer<Void> handle;
  static final _finalizer =
      NativeFinalizer(_bindings.releaseAContainerPtr.cast());

  A_Container(this.handle);

  factory A_Container.generate() {
    final AContainerInstance = _bindings.create_A_Container();
    final AContainerHandle = A_Container(AContainerInstance);
    _finalizer.attach(AContainerHandle, AContainerInstance.cast(),
        detach: AContainerHandle);
    return AContainerHandle;
  }

  void storeObject(A_Container container, A target) {
    _bindings.storePtr(container.handle, target.handle);
  }

  A getObject(A_Container container, int idx) {
    return A(_bindings.getPtr(container.handle, idx));
  }
}
