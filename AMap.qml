import QtQuick 2.0
import QtLocation 5.3
import QtPositioning 5.8
import QtQuick.Controls 2.2
import "amap.js" as AMAP_API
import "fontawesome"// as FontAwesome
Map { 
    id: map
    width: 100; height: 100
    zoomLevel: 18
    center: QtPositioning.coordinate(22.5574462,113.9449748)
//    Behavior on center {
//        CoordinateAnimation {
//            duration: 1000
//            easing.type: Easing.Linear}
//    }
    
    

    //    Address{}
        plugin: Plugin{
            name: "amap"//"googlemaps"
            Component.onCompleted: {
                console.debug(availableServiceProviders)
                var origin="",destination=""
                AMAP_API.getGeoCode("宝安公园西二门","深圳", function(geo){
                    for(var i in  geo.geocodes){
                        origin = geo.geocodes[i].location
    //                    console.debug()
    //                    var location = geo.geocodes[i].location.split(",")
    //                    testItem.center.latitude = location[1]
    //                    testItem.center.longitude = location[0]
    //                    map.center = testItem.center
                        AMAP_API.getGeoCode("华瀚科技","深圳", function(geo){
                            for(var i in  geo.geocodes){
                                destination =  geo.geocodes[i].location
            ////                    console.debug()
    //                            var location = geo.geocodes[i].location.split(",")
    //                            testItem.center.latitude = location[1]
    //                            testItem.center.longitude = location[0]
    //                            map.center = testItem.center
                                AMAP_API.getDrivingDirection(origin, destination, function(driving){
    //                                console.debug("driving.info",origin, destination)

                                    var steps = driving.route.paths[0].steps
                                    routeLine.addCoordinate(origin.split(",")[1],origin.split(",")[0])
                                    for (var i in steps){
    //                                    console.debug(steps[i].instruction)
                                         var polylinepoints = steps[i].polyline.split(";")
                                         for(var j in polylinepoints){

                                             var point = polylinepoints[j].split(",")
    //                                         console.debug(point[1], ",",point[0])
                                             routeLine.addCoordinate(QtPositioning.coordinate(point[1],point[0]))
                                         }//
                                    }
                                    routeLine.addCoordinate(destination.split(",")[1],destination.split(",")[0])
                                    originItem.center = routeLine.path[0]
                                    destinationItem.center = routeLine.path[routeLine.path.length-1]
                                })
                            }
                        })
                    }
                })
                //
            }
        }

    //    onWidthChanged: AMAP_API.width = width
    //    onHeightChanged: AMAP_API.height =height
    //    onZoomLevelChanged: AMAP_API.zoom = Math.floor(zoomLevel)
    //    onCenterChanged: {
    //        AMAP_API.latitude = center.latitude
    //        AMAP_API.longitude = center.longitude
    //        amapImage.source = AMAP_API.getAMapSource()
    //    }

    //    Image {
    //        id: amapImage
    //        anchors.fill: parent
    //    }

        MapPolyline{
            id: routeLine
            line.width: 6
            line.color: "#46a2da"
        }
        MapCircle {
            id: originItem
            color: "blue"
            radius: 24-map.zoomLevel
        }
        MapCircle {
            id: destinationItem
            color: "blue"
            radius: 24-map.zoomLevel
      }
    
    
    ComboBox{
        id: searchComboBox
        anchors.fill: searchTextField
        textRole: "name"
        onCurrentTextChanged: searchTextField.text = currentText
        function updataModel(data){
            model = data
            popup.open()
        }
    }
    TextField{
        id: searchTextField
        placeholderText: qsTr("搜索位置、公交、地铁站")
        text: "公园"
        onAccepted: {
            AMAP_API.getInputtips(searchTextField.text, function(tips){
        
             searchComboBox.updataModel(tips.tips)                         
         })
        }
        FontAwesome{
            name: "search"
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 8
            color: searchIconArea.containsMouse ? "#46a2da" : "grey"
            MouseArea{
                id: searchIconArea
                hoverEnabled: true
                anchors.fill: parent
                onClicked:{                     
                     AMAP_API.getInputtips(searchTextField.text, function(tips){
//                        console.debug("Tips",tips.info, JSON.stringify(tips))
                         searchComboBox.updataModel(tips.tips)                         
                     })
                }
            }
        }
    }
    
}