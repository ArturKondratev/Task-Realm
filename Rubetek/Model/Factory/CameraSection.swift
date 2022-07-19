//
//  CameraSection.swift
//  Rubetek
//
//  Created by Артур Кондратьев on 18.07.2022.
//

import Foundation

struct CameraSection: Comparable {

    var key: String
    var data: [CamerasRealmModel]

    static func < (lhs: CameraSection, rhs: CameraSection) -> Bool {
        return lhs.key < rhs.key
    }

    static func == (lhs: CameraSection, rhs: CameraSection) -> Bool {
        return lhs.key == rhs.key
    }
}
