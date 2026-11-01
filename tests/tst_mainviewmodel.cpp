#include <QSignalSpy>
#include <QtTest>

#include "MainViewModel.h"

class MainViewModelTest : public QObject
{
    Q_OBJECT

private slots:
    void toggleUpdatesPresentation()
    {
        MainViewModel viewModel;
        QSignalSpy spy(&viewModel, &MainViewModel::checkedChanged);
        const QString initialMessage = viewModel.message();

        QVERIFY(!viewModel.checked());
        viewModel.toggle();
        QVERIFY(viewModel.checked());
        QVERIFY(viewModel.message() != initialMessage);
        QCOMPARE(spy.count(), 1);

        viewModel.toggle();
        QVERIFY(!viewModel.checked());
        QCOMPARE(viewModel.message(), initialMessage);
        QCOMPARE(spy.count(), 2);
    }
};

QTEST_GUILESS_MAIN(MainViewModelTest)
#include "tst_mainviewmodel.moc"
