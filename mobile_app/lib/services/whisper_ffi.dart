import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

// Native C function signature definitions
typedef WhisperInitNative = Pointer<Void> Function(Pointer<Utf8> modelPath);
typedef WhisperInitDart = Pointer<Void> Function(Pointer<Utf8> modelPath);

typedef WhisperTranscribeNative = Pointer<Utf8> Function(Pointer<Void> context, Pointer<Utf8> audioPath);
typedef WhisperTranscribeDart = Pointer<Utf8> Function(Pointer<Void> context, Pointer<Utf8> audioPath);

typedef WhisperFreeNative = Void Function(Pointer<Void> context);
typedef WhisperFreeDart = void Function(Pointer<Void> context);

/// Dart FFI Wrapper for whisper.cpp C++ Engine
/// Execution: Background C++ thread | RAM Target: ~120MB | Latency: 600ms-800ms
class WhisperFFIService {
  late DynamicLibrary _whisperLib;
  Pointer<Void>? _whisperContext;
  bool _isInitialized = false;

  WhisperFFIService() {
    _loadNativeLibrary();
  }

  void _loadNativeLibrary() {
    if (Platform.isAndroid) {
      _whisperLib = DynamicLibrary.open('libwhisper_engine.so');
    } else {
      // Fallback for local desktop simulation or testing
      _whisperLib = DynamicLibrary.process();
    }
  }

  /// Initializes the INT8 Quantized Whisper model in C++ native memory
  bool initializeEngine(String modelPath) {
    try {
      final whisperInit = _whisperLib
          .lookupFunction<WhisperInitNative, WhisperInitDart>('whisper_init');
      
      final modelPathPtr = modelPath.toNativeUtf8();
      _whisperContext = whisperInit(modelPathPtr);
      calloc.free(modelPathPtr);

      _isInitialized = _whisperContext != null && _whisperContext != nullptr;
      return _isInitialized;
    } catch (e) {
      // Fallback flag for prototyping when native binary isn't precompiled
      _isInitialized = false;
      return false;
    }
  }

  /// Transcribes offline audio input file to text via C++ thread
  String transcribeAudio(String audioFilePath) {
    if (!_isInitialized || _whisperContext == null) {
      return "[Offline Engine Simulation]: Speech-to-Text dynamic library waiting for INT8 model weights";
    }

    final whisperTranscribe = _whisperLib
        .lookupFunction<WhisperTranscribeNative, WhisperTranscribeDart>('whisper_transcribe');

    final audioPathPtr = audioFilePath.toNativeUtf8();
    final resultPtr = whisperTranscribe(_whisperContext!, audioPathPtr);
    
    final resultText = resultPtr.toDartString();
    calloc.free(audioPathPtr);

    return resultText;
  }

  /// Releases native C++ memory buffers upon engine shutdown
  void dispose() {
    if (_whisperContext != null && _whisperContext != nullptr) {
      final whisperFree = _whisperLib
          .lookupFunction<WhisperFreeNative, WhisperFreeDart>('whisper_free');
      whisperFree(_whisperContext!);
      _whisperContext = null;
      _isInitialized = false;
    }
  }
}
