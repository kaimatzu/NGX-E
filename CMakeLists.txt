cmake_minimum_required(VERSION 3.15)
project(NGXE)

include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}/src
)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(source_dir src)
set(vendor_includes vendor/spdlog/include)

# Add the preprocessor definitions
add_compile_definitions(NGXE_PLATFORM_WINDOWS NGXE_BUILD_DLL)

# Set the common compiler flags
add_compile_options(-Wall -Wextra -march=native)

# Loop through the CPP files in the source directory and its subdirectories
file(GLOB_RECURSE source_files ${source_dir}/*.cpp)

# Create the object files list
foreach(source_file ${source_files})
    get_filename_component(file_name ${source_file} NAME_WE)
    set(object_file ${CMAKE_CURRENT_BINARY_DIR}/${file_name}.o)
    message("Compiling: ${file_name}.cpp")
    add_custom_command(
        OUTPUT ${object_file}
        COMMAND ${CMAKE_CXX_COMPILER} ${CMAKE_CXX_FLAGS} -c ${source_file} -o ${object_file}
        DEPENDS ${source_file}
    )
    list(APPEND object_files ${object_file})
    list(APPEND cpp_files ${source_file})
endforeach()

message("Files: ${cpp_files}")
# # Create the DLL target and link object files
add_library(NGXE SHARED ${cpp_files})
target_include_directories(NGXE PRIVATE ${source_dir}/NGXE ${vendor_includes})
set_target_properties(NGXE PROPERTIES OUTPUT_NAME "NGXE")
set_target_properties(NGXE PROPERTIES PREFIX "")
set_target_properties(NGXE PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/bin)


# Copy DLL and LIB files to target applications bin
# file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/bin/NGXE.dll DESTINATION ${target_applications_bin})
# file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/bin/NGXE.lib DESTINATION ${target_applications_bin})