find_package(Qt6 6.8 REQUIRED COMPONENTS InsightTracker)

qt_add_resources(QtDesignTemplateApp insight_configuration
    PREFIX "/"
    BASE "${PROJECT_SOURCE_DIR}"
    FILES "${PROJECT_SOURCE_DIR}/qtinsight.conf"
)
target_link_libraries(QtDesignTemplateApp PRIVATE Qt6::InsightTracker)
