//
//  NetworkService.swift
//  Rubetek
//
//  Created by Артур Кондратьев on 07.07.2022.
//
import Foundation
import RealmSwift

fileprivate enum TypeMethods: String {
    case camerasGet = "/api/rubetek/cameras"
    case doorsGet = "/api/rubetek/doors"
}

fileprivate enum TypeRequest: String {
    case get = "GET"
    case post = "POST"
}

final class NetworkService {
    private let scheme = "http"
    private let host = "cars.cprogroup.ru"
    private let decoder = JSONDecoder()
    private let realmService = RealmCashService()
    
    enum ServiceError: Error {
        case parseError
        case requestError(Error)
        case saveError
    }
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        return session
    }()
    
    //MARK: - Load Cameras
    func loadCameras(completion: @escaping ([CamerasRealmModel], [CamerasRealmRoom]) -> Void) {
        
        let url = self.configureUrl(method: .camerasGet, httpMethod: .get)
        print(url)
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard
                let data = data,
                let results = try? self.decoder.decode(Cameras.self, from: data)
                    
            else { return }
            
            let realmCameras: [CamerasRealmModel] = results.data.cameras.map { result in
                let realmPost = CamerasRealmModel()
                realmPost.name = result.name
                realmPost.snapshot = result.snapshot
                realmPost.room = result.room ?? results.data.room.last
                realmPost.id = result.id
                realmPost.favorites = result.favorites
                realmPost.rec = result.rec
                return realmPost
            }
            
            let realmCamerasRooms: [CamerasRealmRoom] = results.data.room.map { roomName in
                
                let realmPost = CamerasRealmRoom()
                realmPost.roomName = roomName
                
                let filterCameram = realmCameras.filter({ $0.room == roomName })
                
                for camera in filterCameram {
                    realmPost.cameras.append(camera)
                }
                return realmPost
            }
            
            completion(Array(realmCameras), Array(realmCamerasRooms))
        }
        .resume()
    }
    
    //MARK: - Load Doors
    
    func loadDoors(completion: @escaping ([DoorsRealmModel]) -> Void) {
        let url = configureUrl(method: .doorsGet, httpMethod: .get)
        print(url)
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard
                let data = data,
                let results = try? self.decoder.decode(Doors.self, from: data)
            else { return }
            
            let realmDoors: [DoorsRealmModel] = results.data.map { door in
                let realmPost = DoorsRealmModel()
                realmPost.name = door.name
                realmPost.room = door.room ?? "Some"
                realmPost.id = door.id
                realmPost.favorites = door.favorites
                realmPost.snapshot = door.snapshot
                
                return realmPost
            }
            completion(Array(realmDoors))
        }
        .resume()
    }
}

private extension NetworkService {
    
    func configureUrl(method: TypeMethods,
                      httpMethod: TypeRequest) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = method.rawValue
        
        guard let url = urlComponents.url else {
            fatalError("URL is invalid")
        }
        return url
    }
}
