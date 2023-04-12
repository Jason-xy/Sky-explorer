set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

set(CMAKE_C_COMPILER "aarch64-linux-gnu-gcc")
set(CMAKE_CXX_COMPILER "aarch64-linux-gnu-g++")
set(CMAKE_PREFIX_PATH "${CMAKE_PREFIX_PATH};/opt/ros/noetic;/usr/local/cuda;${CMAKE_CURRENT_LIST_DIR}/../../prebuilts")

set(CUDA_TOOLKIT_ROOT_DIR "/usr/local/cuda")
set(CUDA_CUDART_LIBRARY "/usr/local/cuda/lib64/libcudart.so")