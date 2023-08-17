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

import QtQuick 2.7
import Lomiri.Components 1.3
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0

import Example 1.0

MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'qhardwarebenchmark.fredldotme'
    automaticOrientation: true

    width: units.gu(45)
    height: units.gu(75)

    property bool benchmarking : false
    property int doneBenchmarks : 0
    property string image : ""
    property double startTime : new Date().getTime()
    function updateTime() {
        timeLabel.text = new Date().getTime() - startTime + " ms"
    }

    Page {
        anchors.fill: parent

        header: PageHeader {
            id: header
            title: i18n.tr('QHardwareBenchmark')
        }

        Repeater {
            model: 50
            anchors {
                top: header.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            BenchmarkItem {
                id: benchmarkItem
                source: image
                width: 100
                height: 100
                onTextureChanged: {
                    if (benchmarking) {
                        updateTime();
                        if (++doneBenchmarks == 50) {
                            benchmarking = false;
                            startBenchmarkButton.color = "green"
                        }
                    }
                }
            }
        }

        ColumnLayout {
            spacing: units.gu(2)
            anchors {
                margins: units.gu(2)
                top: header.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            Item {
                Layout.fillHeight: true
            }

            Label {
                id: timeLabel
                Layout.alignment: Qt.AlignHCenter
            }

            Button {
                id: startBenchmarkButton
                Layout.alignment: Qt.AlignHCenter
                text: i18n.tr('Press here!')
                onClicked: {
                    doneBenchmarks = 0
                    benchmarking = true
                    startTime = new Date().getTime()
                    image = ":/assets/nasa.jpg"
                }
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }
}
