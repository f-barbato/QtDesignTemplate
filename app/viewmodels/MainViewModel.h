#pragma once

#include <QObject>
#include <QString>

class MainViewModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool checked READ checked NOTIFY checkedChanged)
    Q_PROPERTY(QString message READ message NOTIFY checkedChanged)

public:
    explicit MainViewModel(QObject *parent = nullptr);

    bool checked() const;
    QString message() const;
    Q_INVOKABLE void toggle();

signals:
    void checkedChanged();

private:
    bool m_checked = false;
};
