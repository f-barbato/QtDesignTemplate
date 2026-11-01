configure_file("${PROJECT_SOURCE_DIR}/packaging/application.desktop.in"
    "${CMAKE_CURRENT_BINARY_DIR}/${APP_NAME}.desktop" @ONLY)
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/${APP_NAME}.desktop"
    DESTINATION "${CMAKE_INSTALL_DATADIR}/applications")
install(FILES "${APP_ICON}"
    DESTINATION "${CMAKE_INSTALL_DATADIR}/icons/hicolor/256x256/apps"
    RENAME "${APP_NAME}.png")

get_target_property(appimage_qmake Qt6::qmake IMPORTED_LOCATION)

add_custom_target(appimage
    COMMAND "${CMAKE_COMMAND}"
        "-DBUILD_DIRECTORY=${CMAKE_BINARY_DIR}"
        "-DQMAKE_PATH=${appimage_qmake}"
        "-DAPP_VERSION=${PROJECT_VERSION}"
        -P "${PROJECT_SOURCE_DIR}/cmake/build_appimage.cmake"
    DEPENDS QtDesignTemplateApp
    USES_TERMINAL
    VERBATIM
)
