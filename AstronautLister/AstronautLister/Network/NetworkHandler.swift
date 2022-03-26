//
//  NetworkHandler.swift
//  AstronautLister
//
//  Created by Sunny Kumar on 25/3/22.
//  Copyright © 2022 Sunny Kumar. All rights reserved.
//

import Foundation

enum NetworkUrl {
    case list
    case displayDetials(String)
    
    func url() -> String {
        switch self {
        case .list:
            return "https://spacelaunchnow.me/api/3.5.0/astronaut/"
        case let .displayDetials(id):
         return "https://spacelaunchnow.me/api/3.5.0/astronaut/\(id)"
        }
    }
}

protocol Networking {
    func getDetails<T: Decodable>(_ dataModel:T.Type, networkUrl:NetworkUrl,
                    completionHandler: @escaping (Result<T, DataError>) -> Void )
}

struct NetworkHandler: Networking {
    let defaultSession = URLSession(configuration: .default)

    func getDetails<T: Decodable>(_ dataModel:T.Type, networkUrl:NetworkUrl,
                                  completionHandler: @escaping (Result<T, DataError>) -> Void ) {
        guard let url = URL(string: networkUrl.url()) else {
            completionHandler(.failure(.internalError))
            return
        }
        
        let dataTask = defaultSession.dataTask(with: url) { (data, response, error) in
            // All errors apart from success with status code "200" are considered as network failures
            // NOTE: here third party library SwiftyJson is used to handle special characters in json.
            // REASON: noticed there are special characters in service response and
            // to handle all which are known and unknown taken help of SwiftyJSON library
            guard error == nil,
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200  else {
                completionHandler(.failure(.networkFailure))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(dataModel.self, from: data)
                completionHandler(.success(response))
            }
            catch {
                completionHandler(.failure(.parsingError))
            }
    }
         dataTask.resume()
 }
}




