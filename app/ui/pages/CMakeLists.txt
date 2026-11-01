qt_add_qml_module(app_ui_pages STATIC
    URI app.ui.pages
    VERSION 1.0
    RESOURCE_PREFIX "/qt/qml"
    QML_FILES Home.ui.qml
)
target_link_libraries(app_ui_pages PRIVATE app_ui_components)
