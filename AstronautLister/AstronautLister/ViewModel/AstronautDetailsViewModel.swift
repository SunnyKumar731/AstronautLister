//
//  AstronautDetailsViewModel.swift
//  AstronautLister
//
//  Created by Sunny Kumar on 25/3/22.
//  Copyright © 2022 Sunny Kumar. All rights reserved.
//

import Foundation

protocol DetailsViewModel: ViewModel {
    var id: String { get set }
    func getDetails(completionHandler: @escaping (Result<AstronautDetailsDataModel, DataError>) -> Void)
}

struct AstronautDetailsViewModel: DetailsViewModel {
    var id: String
    private let networkHandler: Networking
    init(id: String, networkHandler: Networking = NetworkHandler()) {
        self.id = id
        self.networkHandler = networkHandler
    }
    
    func getDetails(completionHandler: @escaping (Result<AstronautDetailsDataModel, DataError>) -> Void) {
        networkHandler.getDetails(AstronautDetials.self,
                                  networkUrl: .displayDetials(id)) { result in
                                    switch result {
                                    case let .success(details):
                                        let detailsDataModel = AstronautDetailsDataModel(id: details.id,
                                                                                         profileImageUrl: details.profileImageUrl,
                                                                                         name: details.name,
                                                                                         dateOfBirth: details.dateOfBirth,
                                                                                         bio: details.bio)
                                        completionHandler(.success(detailsDataModel))
                                    case let .failure(error):
                                        completionHandler(.failure(error))
                                    }
        }
    }
}
