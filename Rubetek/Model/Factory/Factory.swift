//
//  Factory.swift
//  Rubetek
//
//  Created by Артур Кондратьев on 18.07.2022.
//

import Foundation

class Factory {
    
    static func filterCameras(cameras: [CamerasRealmModel]) -> [CameraSection] {
        let sortedArray = sortCameras(array: cameras)
        let sectionsArray = formCamerasSection(array: sortedArray)
        return sectionsArray
    }
    
    static func sortCameras(array: [CamerasRealmModel]) -> [String: [CamerasRealmModel]] {
        
        var newArray: [String: [CamerasRealmModel]] = [:]
        
        for camera in array {
            
            guard let roomName = camera.room else { continue }
            
            guard var array = newArray[roomName] else {
                let newValue = [camera]
                newArray.updateValue(newValue, forKey: roomName)
                continue
            }
            
            array.append(camera)
            newArray.updateValue(array, forKey: roomName)
        }
        return newArray
    }
    
    static func formCamerasSection(array: [String: [CamerasRealmModel]]) -> [CameraSection] {
        var sectionsArray: [CameraSection] = []
        for (key, array) in array {
            sectionsArray.append(CameraSection(key: key, data: array))
        }
        sectionsArray.sort { $0 < $1 }
        
        return sectionsArray
    }

}

