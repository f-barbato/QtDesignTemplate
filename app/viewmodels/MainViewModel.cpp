#include "MainViewModel.h"

MainViewModel::MainViewModel(QObject *parent)
    : QObject(parent)
{
}

bool MainViewModel::checked() const
{
    return m_checked;
}

QString MainViewModel::message() const
{
    return m_checked ? tr("Button Checked") : tr("Hello QtDesignTemplate");
}

void MainViewModel::toggle()
{
    m_checked = !m_checked;
    emit checkedChanged();
}
