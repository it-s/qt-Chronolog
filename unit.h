#ifndef UNIT_H
#define UNIT_H
#include <QObject>
#include <QScreen>
class Unit : public QObject
{
    Q_OBJECT

public:
    explicit Unit(const QSize& screenSize, const QSize &designedForSize, QObject *parent = 0);
    ~Unit();

    Q_INVOKABLE qreal pt(int pixel);
    Q_INVOKABLE int px(qreal point);
    Q_INVOKABLE int scale(qreal point, qreal ratio);
    Q_INVOKABLE qreal ratio();
    Q_INVOKABLE QString size();
    Q_INVOKABLE void setRoundUp(bool v);

protected slots:
    void computeRatio();

signals:
    void ratioChanged();


   private:
    bool mRoudUp;
    QSize mCurrentSize;
    QSize mIntendedSize;
    qreal mRatio;

};

#endif // UNIT_H
