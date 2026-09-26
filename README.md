# SIH-26042-PROJECT-JAGAR-SENGHDA
🎓 Project Jagar Senghda
Team Name: CodeSwitch
Target Event: Smart India Hackathon (SIH) 2026
Problem Statement ID: 26042
Category: Smart Education | Software
Project Jagar Senghda is an edge-native, offline-first pedagogical adaptation and real-time voice translation assistant tailored for primary education in rural and tribal belts, particularly in states like Jharkhand. Designed specifically to bridge the severe L1 (Mother Tongue) to L2 (State Language) comprehension gap, the system empowers native Hindi-speaking educators to seamlessly teach indigenous students speaking Santhali, Mundari, and Ho.
By operating entirely offline on ultra-low-cost Android hardware (≤ 2GB RAM), the platform eliminates recurring cloud infrastructure costs and connectivity dependencies.
✨ Key Features & Innovations
 * 🗣️ 3-Tier Dialect Engine: Utilizes advanced Santhali-to-Ho morphological pivot mapping to effectively bridge gaps in ultra-low-resource languages.
 * 🧠 Pedagogical Interceptor Layer:
   * MLE Wrapper: Structurally formats sentences to align with early childhood education standards.
   * Jargon Simplifier: Dynamically detects abstract academic terms and maps them to child-friendly foundational vocabulary.
   * Local Metaphor Swapper: Replaces unfamiliar textbook analogies (e.g., "counting traffic lights") with culturally familiar rural contexts (e.g., "counting mahua flowers or sal leaves").
   * L1 / L2 Switching Control: Balances the ratio of the target dialect (L1) to the state language (L2) depending on the student's current learning phase.
 * 🔠 Dual-Script Engine: Automatically formats instructional text streams into dual-orthography outputs, pairing Devanagari (Hindi) with indigenous scripts like Ol Chiki (Santhali) or Warang Chiti (Ho).
 * 📱 Dual-Screen UI: Features a synchronized Teacher/Student user interface for coordinated classroom execution.
 * 📄 Automated FLN Worksheet Generator: Automatically builds offline, printable bilingual worksheets and tracking sheets strictly aligned with the NIPUN Bharat Mission. It tracks metrics like reading 45–60 words per minute and identifying numbers 1–99.
🏗️ System Architecture & Performance
The core system relies on tight execution budgets to prevent mobile operating systems from triggering Out-Of-Memory (OOM) background terminations on low-end hardware.
Real-Time Pipeline Specs
 * Speech-to-Text (STT): Powered by whisper.cpp utilizing an INT8 Quantized Whisper-Tiny model paired with a Silero VAD (Voice Activity Detection) layer.
 * RAM Footprint: ~120 MB.
 * Execution Latency: ~600ms - 800ms.
Tech Stack Breakdown
 * Frontend UI: Flutter Native (Dart)
 * Core Inference Engine: C++17 via JNI (Java Native Interface)
 * Local Database: SQLite (Write-Ahead Logging mode for fast asset delivery)
 * On-Device ML: ONNX Runtime Mobile for quantized neural network inference.
📈 Educational & Administrative Impact
 * Elimination of Transition Shock: Smooths the sudden academic shift from home languages to state instructional media, directly reducing early childhood dropout rates.
 * Teacher Empowerment: Provides immediate, on-the-fly pedagogical scaffolding, exact phoneme guides, and localized metaphors, allowing non-tribal educators to teach effectively in linguistically unfamiliar districts.
 * Policy Compliance: Directly satisfies state literacy mandates under the National Education Policy (NEP 2020) and the NIPUN Bharat Mission without requiring costly cloud software licenses.
🛠️ Installation & Setup (Local Development)
Prerequisites:
 * Android Studio (Flamingo or higher)
 * Flutter SDK (3.10.x+)
 * CMake (3.22.1+)
 * Android NDK
Build Instructions:
 * Clone the Repository:
   git clone https://github.com/CodeSwitch/Project-Jagar-Senghda.git
cd Project-Jagar-Senghda

 * Download ML Model Weights:
   Navigate to the models/ directory and run the initialization script to pull the quantized ONNX and GGML files.
   cd assets/models && ./fetch_models.sh

 * Compile C++ Audio Wrappers:
   cd android
./gradlew buildNdkBuild

 * Run the Flutter Application:
   flutter pub get
flutter run --release

📚 Academic Research & References
This project builds upon the foundational research of several state-of-the-art open-source machine learning frameworks:
 * Meta AI (NLLB Model): "No Language Left Behind" – Foundational multilingual neural machine translation techniques optimized for low-resource languages.
   * Reference: arXiv:2207.04672.
 * AI4Bharat (IndicTrans2): Specialized translation architectures engineered for Indian and endangered indigenous tribal languages.
   * Reference: arXiv:2305.16307.
 * OpenAI (whisper.cpp): C/C++ implementations by Georgi Gerganov for highly optimized speech-to-text processing on edge devices.
   * Reference: arXiv:2412.19785v1.
 * ONNX Runtime Mobile: Architecture for running high-performance machine learning models on low-power mobile hardware.
   * Reference: NVIDIA Developer ONNX Optimization Guide.
