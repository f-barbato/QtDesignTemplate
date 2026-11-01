cmake_minimum_required(VERSION 3.21)

include(cmake/application.cmake)
project(QtDesignTemplateApp VERSION "${APP_VERSION}" LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(QT_QML_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/qml")

option(LINK_INSIGHT "Link Qt Insight Tracker library" OFF)

find_package(Qt6 6.8 REQUIRED COMPONENTS Quick QuickControls2)
qt_standard_project_setup(REQUIRES 6.8)

add_subdirectory(app)

if(LINK_INSIGHT)
    include(cmake/insight.cmake)
endif()

include(CTest)
if(BUILD_TESTING)
    find_package(Qt6 6.8 REQUIRED COMPONENTS Test)
    add_subdirectory(tests)
endif()

include(GNUInstallDirs)
install(TARGETS QtDesignTemplateApp
    BUNDLE DESTINATION .
    RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
)
qt_generate_deploy_qml_app_script(
    TARGET QtDesignTemplateApp
    OUTPUT_SCRIPT deploy_script
    NO_UNSUPPORTED_PLATFORM_ERROR
)
install(SCRIPT "${deploy_script}")

set(CPACK_PACKAGE_NAME "${APP_NAME}")
set(CPACK_PACKAGE_VERSION "${PROJECT_VERSION}")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "${APP_DESCRIPTION}")
set(CPACK_PACKAGE_VENDOR "${APP_VENDOR}")
set(CPACK_RESOURCE_FILE_LICENSE "${PROJECT_SOURCE_DIR}/LICENSE")
set(CPACK_PACKAGE_DIRECTORY "${CMAKE_BINARY_DIR}/packages")
set(CPACK_PACKAGE_INSTALL_DIRECTORY "${APP_NAME}")
set(CPACK_PACKAGE_EXECUTABLES "${APP_EXECUTABLE_NAME}" "${APP_NAME}")

if(WIN32)
    set(CPACK_GENERATOR "NSIS")
elseif(APPLE)
    set(CPACK_GENERATOR "DragNDrop")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Linux")
    set(CPACK_GENERATOR "DEB;RPM")
    set(CPACK_DEBIAN_PACKAGE_MAINTAINER "${APP_VENDOR}")
    set(CPACK_DEBIAN_PACKAGE_SHLIBDEPS ON)
    set(CPACK_DEBIAN_FILE_NAME DEB-DEFAULT)
    set(CPACK_RPM_PACKAGE_LICENSE "${APP_LICENSE}")
    set(CPACK_RPM_FILE_NAME RPM-DEFAULT)
    include(cmake/appimage.cmake)
else()
    set(CPACK_GENERATOR "TGZ")
endif()

include(CPack)
