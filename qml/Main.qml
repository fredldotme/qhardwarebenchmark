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

    readonly property int numberOfRuns : 30

    property bool benchmarking : false
    property int doneBenchmarks : 0
    property double startTime : new Date().getTime()
    function updateTime() {
        timeLabel.text = new Date().getTime() - startTime + " ms"
    }

    Page {
        id: page
        anchors.fill: parent

        header: PageHeader {
            id: header
            title: i18n.tr('QHardwareBenchmark')
        }

        property alias repeater: repeater;
        Repeater {
            id: repeater
            model: numberOfRuns
            anchors {
                top: header.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            BenchmarkItem {
                id: benchmarkItem
                width: 50
                height: 50
                visible: true
                onTextureChanged: {
                    if (benchmarking) {
                        updateTime();
                        if (++doneBenchmarks == numberOfRuns) {
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
                    startTime = new Date().getTime()
                    doneBenchmarks = 0
                    benchmarking = true
                    for (let i = 0; i < numberOfRuns; i++) {
                        page.repeater.itemAt(i).loadImage()
                    }
                }
            }

            Item {
                Layout.fillHeight: true
            }
        }

        Rectangle {
            id: jankIndicator1
            color: "red"
            x: 0
            y: 0
            width: 100
            height: 100
            visible: benchmarking
        }

        Rectangle {
            id: jankIndicator2
            color: "green"
            x: 0
            y: 0
            width: 100
            height: 100
            visible: benchmarking
        }

        PropertyAnimation {
            target: jankIndicator1
            loops: Animation.Infinite
            from: 0
            to: root.width
            duration: 700
            running: benchmarking
        }

        XAnimator {
            target: jankIndicator2
            loops: Animation.Infinite
            from: 0
            to: root.width
            duration: 1000
            running: benchmarking
        }
    }
}
