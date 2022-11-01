//
//  DoorModel.swift
//  Rubetek
//
//  Created by Артур Кондратьев on 07.07.2022.
//

import Foundation

// MARK: - Door
struct Doors: Codable {
    let success: Bool
    let data: [Door]
}

// MARK: - Datum
struct Door: Codable {
    
    let name: String
    let room: String?
    let id: Int
    let favorites: Bool
    let snapshot: String?
    
}
