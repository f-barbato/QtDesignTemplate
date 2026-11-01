qt_add_executable(tst_mainviewmodel tst_mainviewmodel.cpp)
target_link_libraries(tst_mainviewmodel PRIVATE app_viewmodels Qt6::Test)
add_test(NAME mainviewmodel COMMAND tst_mainviewmodel)

qt_add_executable(tst_uiintegration tst_uiintegration.cpp)
target_link_libraries(tst_uiintegration PRIVATE
    app_viewmodels
    app_ui_componentsplugin
    app_ui_pagesplugin
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::Test
)
target_compile_definitions(tst_uiintegration PRIVATE
    APP_QML_PATH="${PROJECT_SOURCE_DIR}/app/ui/App.qml"
)
add_test(NAME uiintegration COMMAND tst_uiintegration)
set_tests_properties(uiintegration PROPERTIES
    ENVIRONMENT "QT_QPA_PLATFORM=offscreen;QT_QUICK_BACKEND=software"
)
