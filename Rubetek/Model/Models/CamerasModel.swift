//
//  CamerasModel.swift
//  Rubetek
//
//  Created by Артур Кондратьев on 07.07.2022.
//

import Foundation

struct Cameras: Codable {
    let success: Bool
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let room: [String]
    let cameras: [Camera]
}

// MARK: - Camera
struct Camera: Codable {
    var name: String
    let snapshot: String
    let room: String?
    let id: Int
    let favorites, rec: Bool
}
