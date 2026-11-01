#include <cstdlib>

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QVariant>

#include "MainViewModel.h"
#include "application.h"

int main(int argc, char *argv[])
{
    qputenv("QT_QUICK_CONTROLS_CONF", ":/qtquickcontrols2.conf");
    QGuiApplication app(argc, argv);
    QCoreApplication::setApplicationName(APP_DISPLAY_NAME);
    QCoreApplication::setApplicationVersion(APP_VERSION_STRING);

    MainViewModel viewModel;
    QQmlApplicationEngine engine;
    engine.setInitialProperties({
        {"viewModel", QVariant::fromValue(&viewModel)}
    });
    engine.loadFromModule("app.ui", "App");

    if (engine.rootObjects().isEmpty())
        return EXIT_FAILURE;

    return app.exec();
}
