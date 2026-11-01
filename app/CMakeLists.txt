qt_add_library(app_viewmodels STATIC
    viewmodels/MainViewModel.h
    viewmodels/MainViewModel.cpp
)
target_link_libraries(app_viewmodels PUBLIC Qt6::Core)
target_include_directories(app_viewmodels PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/viewmodels")

qt_add_executable(QtDesignTemplateApp main.cpp)
set_target_properties(QtDesignTemplateApp PROPERTIES
    WIN32_EXECUTABLE TRUE
    MACOSX_BUNDLE TRUE
    OUTPUT_NAME "${APP_EXECUTABLE_NAME}"
    MACOSX_BUNDLE_GUI_IDENTIFIER "${APP_IDENTIFIER}"
    MACOSX_BUNDLE_BUNDLE_NAME "${APP_NAME}"
    MACOSX_BUNDLE_BUNDLE_VERSION "${PROJECT_VERSION}"
    MACOSX_BUNDLE_SHORT_VERSION_STRING "${PROJECT_VERSION}"
)
configure_file(application.h.in "${CMAKE_CURRENT_BINARY_DIR}/application.h" @ONLY)
target_include_directories(QtDesignTemplateApp PRIVATE "${CMAKE_CURRENT_BINARY_DIR}")
target_link_libraries(QtDesignTemplateApp PRIVATE
    app_viewmodels
    Qt6::Quick
    Qt6::QuickControls2
)
qt_add_resources(QtDesignTemplateApp configuration
    PREFIX "/"
    BASE "${PROJECT_SOURCE_DIR}"
    FILES "${PROJECT_SOURCE_DIR}/qtquickcontrols2.conf"
)

add_subdirectory(ui)

set_source_files_properties(ui/App.qml PROPERTIES QT_RESOURCE_ALIAS App.qml)
qt_add_qml_module(QtDesignTemplateApp
    URI app.ui
    VERSION 1.0
    RESOURCE_PREFIX "/qt/qml"
    QML_FILES ui/App.qml
)
target_link_libraries(QtDesignTemplateApp PRIVATE
    app_ui_componentsplugin
    app_ui_pagesplugin
)
