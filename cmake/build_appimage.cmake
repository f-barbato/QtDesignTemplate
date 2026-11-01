find_program(LINUXDEPLOY_EXECUTABLE NAMES linuxdeploy linuxdeploy-x86_64.AppImage REQUIRED)
find_program(LINUXDEPLOY_QT_PLUGIN NAMES linuxdeploy-plugin-qt linuxdeploy-plugin-qt-x86_64.AppImage REQUIRED)

set(appdir "${BUILD_DIRECTORY}/AppDir")
set(output_directory "${BUILD_DIRECTORY}/packages")
if(NOT IS_ABSOLUTE "${BUILD_DIRECTORY}"
   OR NOT EXISTS "${BUILD_DIRECTORY}/CMakeCache.txt")
    message(FATAL_ERROR "BUILD_DIRECTORY must be an absolute configured CMake build directory.")
endif()
file(REMOVE_RECURSE "${appdir}")
file(MAKE_DIRECTORY "${output_directory}")

execute_process(
    COMMAND "${CMAKE_COMMAND}" --install "${BUILD_DIRECTORY}" --prefix "${appdir}/usr"
    COMMAND_ERROR_IS_FATAL ANY
)
execute_process(
    COMMAND "${CMAKE_COMMAND}" -E env
        "APPIMAGE_EXTRACT_AND_RUN=1"
        "QMAKE=${QMAKE_PATH}"
        "LINUXDEPLOY_OUTPUT_VERSION=${APP_VERSION}"
        "${LINUXDEPLOY_EXECUTABLE}"
        --appdir "${appdir}"
        --plugin qt
        --output appimage
    WORKING_DIRECTORY "${output_directory}"
    COMMAND_ERROR_IS_FATAL ANY
)
