cmake_minimum_required(VERSION 3.18.1)
project(whisper_native C CXX)

# Configure C++17 standard for native execution
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Optimization flags for low-RAM Android ARM execution (≤2GB target)
if(ANDROID)
    add_compile_options(-O3 -flto -fPIC)
endif()

# Define dynamic library target for Flutter Dart FFI binding
add_library(
    whisper_engine
    SHARED
    whisper.cpp
    ggml.c
)

# Include current directory headers
target_include_directories(
    whisper_engine
    PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
)

# Link native Android logging support
if(ANDROID)
    find_library(log-lib log)
    target_link_libraries(whisper_engine ${log-lib})
endif()
