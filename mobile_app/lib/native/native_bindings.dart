import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

typedef InitEngineNative = Int32 Function(Pointer<Utf8> modelPath);
typedef InitEngineDart = int Function(Pointer<Utf8> modelPath);

typedef ProcessAudioNative = Pointer<Utf8> Function(Pointer<Float> buffer, Int32 length);
typedef ProcessAudioDart = Pointer<Utf8> Function(Pointer<Float> buffer, int length);

class NativeEngine {
  late final DynamicLibrary _nativeLib;
  late final InitEngineDart _initEngine;
  late final ProcessAudioDart _processAudio;

  NativeEngine() {
    _nativeLib = Platform.isAndroid
        ? DynamicLibrary.open('libjagar_native.so')
        : DynamicLibrary.process();

    _initEngine = _nativeLib
        .lookup<NativeFunction<InitEngineNative>>('init_native_engine')
        .asFunction();

    _processAudio = _nativeLib
        .lookup<NativeFunction<ProcessAudioNative>>('process_audio_buffer')
        .asFunction();
  }

  int initialize(String modelPath) {
    final nativeString = modelPath.toNativeUtf8();
    final result = _initEngine(nativeString);
    malloc.free(nativeString);
    return result;
  }

  String processBuffer(List<double> samples) {
    final pointer = malloc<Float>(samples.length);
    final nativeList = pointer.asTypedList(samples.length);
    for (var i = 0; i < samples.length; i++) {
      nativeList[i] = samples[i];
    }

    final resultPointer = _processAudio(pointer, samples.length);
    final resultString = resultPointer.toDartString();
    
    malloc.free(pointer);
    return resultString;
  }
}
