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

#ifndef EXAMPLE_H
#define EXAMPLE_H

#include <QQuickItem>
#include <QImage>
#include <QSGTexture>

class ImageHolder : public QObject
{
    Q_OBJECT
public:
    explicit ImageHolder(QObject* parent = nullptr) { image.load(":/assets/nasa.jpg"); }

    static ImageHolder* s_instance;
    QImage image;
};

class BenchmarkItem : public QQuickItem
{
    Q_OBJECT

public:
    explicit BenchmarkItem(QQuickItem *parent = nullptr);
    ~BenchmarkItem() = default;

    QSGNode* updatePaintNode(QSGNode* node, UpdatePaintNodeData* data);

public slots:
    void loadImage();

private:
    bool m_sourceDirty;
    bool m_load;
    QSGTexture* m_texture;

signals:
    void textureChanged();
};

#endif
