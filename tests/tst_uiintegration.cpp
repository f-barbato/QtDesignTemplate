#include <QQmlApplicationEngine>
#include <QtTest>

#include "MainViewModel.h"

class UiIntegrationTest : public QObject
{
    Q_OBJECT

private slots:
    void injectedViewModelUpdatesView()
    {
        MainViewModel viewModel;
        QQmlApplicationEngine engine;
        engine.setInitialProperties({
            {"viewModel", QVariant::fromValue(&viewModel)}
        });
        engine.load(QUrl::fromLocalFile(QStringLiteral(APP_QML_PATH)));
        QCOMPARE(engine.rootObjects().size(), 1);

        QObject *home = engine.rootObjects().first()->findChild<QObject *>("home");
        QVERIFY(home);
        QCOMPARE(home->property("message").toString(), viewModel.message());
        QVERIFY(QMetaObject::invokeMethod(home, "toggleRequested"));
        QVERIFY(viewModel.checked());
        QCOMPARE(home->property("checked").toBool(), viewModel.checked());
        QCOMPARE(home->property("message").toString(), viewModel.message());
    }

    void designerMockUpdatesView()
    {
        QQmlApplicationEngine engine;
        engine.load(QUrl::fromLocalFile(QStringLiteral(APP_QML_PATH)));
        QCOMPARE(engine.rootObjects().size(), 1);

        QObject *home = engine.rootObjects().first()->findChild<QObject *>("home");
        QVERIFY(home);
        QVERIFY(!home->property("checked").toBool());
        QVERIFY(QMetaObject::invokeMethod(home, "toggleRequested"));
        QVERIFY(home->property("checked").toBool());
    }
};

QTEST_MAIN(UiIntegrationTest)
#include "tst_uiintegration.moc"
