set_source_files_properties(Constants.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_qml_module(app_ui_components STATIC
    URI app.ui.components
    VERSION 1.0
    RESOURCE_PREFIX "/qt/qml"
    QML_FILES Constants.qml
)
