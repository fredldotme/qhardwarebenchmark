/*
 * Copyright (C) 2023  Alfred Neumayer
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * qhardwarebenchmark is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <QDebug>
#include <QQuickWindow>
#include <QSGSimpleTextureNode>
#include <QThreadPool>
#include <QtConcurrent>

#include "example.h"

BenchmarkItem::BenchmarkItem(QQuickItem* parent) : QQuickItem(parent),
    m_sourceDirty(true)
{
    setFlags(QQuickItem::ItemHasContents);
    connect(this, &BenchmarkItem::sourceChanged, this, [=]() {
        m_sourceDirty = true;
        const auto imageLoaderFunc = [=](){
            m_image = QImage(m_source);
            QMetaObject::invokeMethod(this, "update", Qt::QueuedConnection);
        };
        QtConcurrent::run(QThreadPool::globalInstance(), imageLoaderFunc);
    });
}

void BenchmarkItem::setSource(QString source)
{
    if (m_source == source)
        return;

    m_source = source;
    emit sourceChanged();
}

QString BenchmarkItem::source()
{
    return m_source;
}

QSGNode *BenchmarkItem::updatePaintNode(QSGNode *node, UpdatePaintNodeData *)
{
    QSGSimpleTextureNode *n = static_cast<QSGSimpleTextureNode*>(node);
    if (m_sourceDirty && n) {
        delete n;
        n = nullptr;
    }
    if (!n) {
        n = new QSGSimpleTextureNode();
        n->setTexture(window()->createTextureFromImage(m_image));
        n->setOwnsTexture(true);
        emit textureChanged();
    }
    n->setRect(boundingRect());
    m_sourceDirty = false;
    return n;
}
