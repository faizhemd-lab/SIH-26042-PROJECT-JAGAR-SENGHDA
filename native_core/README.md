# Native Core Execution Engines (`native_core`)

This directory contains the optimized native C/C++ execution engines interfacing with Flutter via **Dart FFI**. The architecture is designed to execute 100% offline on low-cost Android hardware ($\le 2\text{GB}$ RAM) with zero cloud dependencies.

---

## 1. Native Subsystem Budget & Benchmarks

| Subsystem Component | Core Technology | Target RAM | Processing Latency | Architecture & Implementation Notes |
| :--- | :--- | :--- | :--- | :--- |
| **Speech-to-Text (ASR)** | `whisper.cpp` (INT8 Quantized) | $\approx 120\text{ MB}$ | $\approx 600\text{ms} - 800\text{ms}$ | Background C++ thread execution; transcribes spoken Hindi instruction into text streams. |
| **Translation Engine** | `onnxruntime-android` (IndicTrans2 / NLLB INT8) | $\approx 250\text{ MB}$ | $\approx 350\text{ms} - 450\text{ms}$ | INT8 quantized model; embeds Ho, Santhali, and Mundari morphological pivot rules. |
| **Text-to-Speech (TTS)** | Piper TTS (VITS-based ONNX Engine) | $\approx 70\text{ MB}$ | $\approx 250\text{ms} - 350\text{ms}$ | Generates high-clarity 22.05 kHz mono audio streams. |
| **Database & Assets** | SQLite (WAL Mode) | $\approx 30\text{ MB}$ | $\approx 10\text{ms}$ | Holds FLN lessons, dynamic vernacular dictionaries, and vector worksheet templates. |
| **Presentation / UI** | Flutter Native (ARM C++/FFI) | $\approx 80\text{ MB}$ | 60 FPS | OpenGL ES rendering pipeline. |
| **TOTAL OVERHEAD** | **Complete System (100% Offline)** | **$\approx 550\text{ MB RAM}$** | **$\approx 1.41\text{s} - 1.85\text{s}$ Total** | **Maintains sub-1s per-stage interaction latency under constraints**. |

---

## 2. Directory Structure

```text
native_core/
├── whisper_cpp/           # C++ Whisper engine bindings and INT8 GGML model weights
│   ├── CMakeLists.txt     # Cross-compilation rules for Android NDK
│   └── whisper.cpp        # Native C++ Whisper implementation
├── vad/                   # Voice Activity Detection (Silero VAD ONNX model)
└── tts_translation/       # Quantized NLLB/IndicTrans2 & Piper TTS ONNX runtimes
