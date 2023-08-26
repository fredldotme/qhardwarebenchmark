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

ImageHolder* ImageHolder::s_instance = new ImageHolder();

BenchmarkItem::BenchmarkItem(QQuickItem* parent) : QQuickItem(parent),
    m_sourceDirty(true), m_load(false), m_texture(nullptr)
{
    setFlags(QQuickItem::ItemHasContents);
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
        if (m_sourceDirty) {
            if (m_texture) {
                m_texture->deleteLater();
            }
            m_texture = window()->createTextureFromImage(m_load ? ImageHolder::s_instance->image : QImage());
            n->setTexture(m_texture);
            n->setRect(0, 0, width(), height());
            n->setFiltering(QSGTexture::Linear);
            n->setOwnsTexture(false);
            n->markDirty(QSGNode::DirtyMaterial | QSGNode::DirtyGeometry);
            m_texture->bind();
            QMetaObject::invokeMethod(this, "textureChanged", Qt::QueuedConnection);
            m_load = false;
        }
    }
    n->setRect(boundingRect());
    m_sourceDirty = false;
    return n;
}

void BenchmarkItem::loadImage()
{
    m_sourceDirty = true;
    m_load = true;
    QMetaObject::invokeMethod(this, "update", Qt::QueuedConnection);
}
