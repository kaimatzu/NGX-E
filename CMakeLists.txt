cmake_minimum_required(VERSION 3.15)
project(NGXE)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(output_dir bin)
set(current_project TestApp)
set(target_applications_bin ${CMAKE_CURRENT_SOURCE_DIR}/../${current_project}/bin)
# ---------------------------------------------BUILD GLFW STATIC LIB----------------------------------------------
set(GLFW_dir vendor/glfw)
set(GLFW_files
    ${GLFW_dir}/src/context.c
    ${GLFW_dir}/src/init.c
    ${GLFW_dir}/src/input.c
    ${GLFW_dir}/src/monitor.c
    ${GLFW_dir}/src/null_init.c
    ${GLFW_dir}/src/null_joystick.c
    ${GLFW_dir}/src/null_monitor.c
    ${GLFW_dir}/src/null_window.c
    ${GLFW_dir}/src/platform.c
    ${GLFW_dir}/src/vulkan.c
    ${GLFW_dir}/src/window.c
)

if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
    # Linux-specific configuration
    list(APPEND GLFW_files
        ${GLFW_dir}/src/x11_init.c
        ${GLFW_dir}/src/x11_monitor.c
        ${GLFW_dir}/src/x11_window.c
        ${GLFW_dir}/src/xkb_unicode.c
        ${GLFW_dir}/src/posix_time.c
        ${GLFW_dir}/src/posix_thread.c
        ${GLFW_dir}/src/posix_module.c
        ${GLFW_dir}/src/glx_context.c
        ${GLFW_dir}/src/egl_context.c
        ${GLFW_dir}/src/osmesa_context.c
        ${GLFW_dir}/src/linux_joystick.c
    )
    add_compile_definitions(_GLFW_X11)
elseif(CMAKE_SYSTEM_NAME STREQUAL "Windows")
    # Windows-specific configuration
    list(APPEND GLFW_files
        ${GLFW_dir}/src/win32_init.c
        ${GLFW_dir}/src/win32_joystick.c
        ${GLFW_dir}/src/win32_module.c
        ${GLFW_dir}/src/win32_monitor.c
        ${GLFW_dir}/src/win32_time.c
        ${GLFW_dir}/src/win32_thread.c
        ${GLFW_dir}/src/win32_window.c
        ${GLFW_dir}/src/wgl_context.c
        ${GLFW_dir}/src/egl_context.c
        ${GLFW_dir}/src/osmesa_context.c
    )
    add_compile_definitions(_GLFW_WIN32 _CRT_SECURE_NO_WARNINGS)
elseif(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    # macOS-specific configuration
    list(APPEND GLFW_files
        ${GLFW_dir}/src/cocoa_init.m
        ${GLFW_dir}/src/cocoa_monitor.m
        ${GLFW_dir}/src/cocoa_window.m
        ${GLFW_dir}/src/cocoa_joystick.m
        ${GLFW_dir}/src/cocoa_time.c
        ${GLFW_dir}/src/nsgl_context.m
        ${GLFW_dir}/src/posix_thread.c
        ${GLFW_dir}/src/posix_module.c
        ${GLFW_dir}/src/osmesa_context.c
        ${GLFW_dir}/src/egl_context.c
    )
    add_compile_definitions(_GLFW_COCOA)
else()
    message(FATAL_ERROR "Unsupported operating system: ${CMAKE_SYSTEM_NAME}")
endif()

# Add the GLFW library target
add_library(GLFW STATIC ${GLFW_files})
target_include_directories(GLFW PUBLIC ${GLFW_dir}/include ${GLFW_dir}/src)
set_target_properties(GLFW PROPERTIES OUTPUT_NAME "NGXE")
set_target_properties(GLFW PROPERTIES PREFIX "")
set_target_properties(GLFW PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${output_dir})

# -------------------------------------------------BUILD NGXE DLL-------------------------------------------------
set(source_dir src)
set(vendor_includes vendor/spdlog/include vendor/glfw/include)

include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}/${source_dir}
)

# Add the preprocessor definitions
add_compile_definitions(NGXE_PLATFORM_WINDOWS NGXE_BUILD_DLL NGXE_ENABLE_ASSERTS)

# Set the common compiler flags
add_compile_options(-Wall -Wextra -march=native)

# Loop through the CPP files in the source directory and its subdirectories
file(GLOB_RECURSE cpp_files ${source_dir}/*.cpp)

message("Files: ${cpp_files}")
# # Create the DLL target and link object files
add_library(NGXE SHARED ${cpp_files})
target_include_directories(NGXE PRIVATE ${source_dir}/NGXE ${source_dir}/Platform ${vendor_includes} ${GLFW_dir}/deps/glad)
set_target_properties(NGXE PROPERTIES OUTPUT_NAME "NGXE")
set_target_properties(NGXE PROPERTIES PREFIX "")
set_target_properties(NGXE PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${output_dir})

# Link NGXE with GLFW library
target_link_directories(NGXE PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/${output_dir})
target_link_libraries(NGXE PRIVATE GLFW opengl32)

# Copy DLL and LIB files to target applications bin
message("Copying NGXE.dll")
add_custom_command(TARGET NGXE POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/bin/NGXE.dll ${target_applications_bin}
)

# file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/bin/NGXE.lib DESTINATION ${target_applications_bin})