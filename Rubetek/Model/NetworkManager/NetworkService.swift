//
//  NetworkService.swift
//  Rubetek
//
//  Created by Артур Кондратьев on 07.07.2022.
//
import Foundation

fileprivate enum TypeMethods: String {
    case camerasGet = "/api/rubetek/cameras"
    case doorsGet = "/api/rubetek/doors"
}

fileprivate enum TypeRequest: String {
    case get = "GET"
    case post = "POST"
}

final class NetworkService {
    private let realmService = RealmCashService()
    private let scheme = "http"
    private let host = "cars.cprogroup.ru"
    private let decoder = JSONDecoder()
    
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
    func loadCameras(completin: @escaping ([CamerasRealmModel]) -> Void) {
        
        let url = self.configureUrl(method: .camerasGet, httpMethod: .get)
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard
                let data = data,
                let results = try? self.decoder.decode(Cameras.self, from: data)
            else { return }
            
            let realmCameras: [CamerasRealmModel] = results.data.cameras.map { result in
                let realmPost = CamerasRealmModel()
                realmPost.name = result.name
                realmPost.snapshot = result.snapshot
                realmPost.room = result.room ?? "Some"
                realmPost.id = result.id
                realmPost.favorites = result.favorites
                realmPost.rec = result.rec
                return realmPost
            }
            
            completin(Array(realmCameras))
        }
        .resume()
    }
    
    //MARK: - Load Doors
    
    func loadDoors(completin: @escaping ([DoorsRealmModel]) -> Void) {
        let url = configureUrl(method: .doorsGet, httpMethod: .get)
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard
                let data = data,
                let results = try? self.decoder.decode(Doors.self, from: data)
            else { return }
            
            let realmDoors: [DoorsRealmModel] = results.data.map { results in
                let realmPost = DoorsRealmModel()
                realmPost.name = results.name
                realmPost.room = results.room ?? "Some"
                realmPost.id = results.id
                realmPost.favorites = results.favorites
                realmPost.snapshot = results.snapshot
                
                return realmPost
            }
            completin(Array(realmDoors))
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
