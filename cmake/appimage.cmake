install(FILES "${PROJECT_SOURCE_DIR}/packaging/QtDesignTemplate.desktop"
    DESTINATION "${CMAKE_INSTALL_DATADIR}/applications")
install(FILES "${PROJECT_SOURCE_DIR}/packaging/QtDesignTemplate.png"
    DESTINATION "${CMAKE_INSTALL_DATADIR}/icons/hicolor/256x256/apps")

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
