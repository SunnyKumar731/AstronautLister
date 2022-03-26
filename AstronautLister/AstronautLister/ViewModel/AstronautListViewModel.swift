//
//  AstronautListViewModel.swift
//  AstronautLister
//
//  Created by Sunny Kumar on 25/3/22.
//  Copyright © 2022 Sunny Kumar. All rights reserved.
//

import Foundation
import Combine

enum FetchDetailsStatus {
    case pending
    case completed
}

struct AstronautListData {
    let status: FetchDetailsStatus
    let details:  Result<[AstronautListDataModel], DataError>
}

protocol ViewModel { }

// Protocol to provide necessary details to load list of Astronauts
protocol ListViewModel: ViewModel {
    var dispalyDetails: CurrentValueSubject<AstronautListData, Never> { get }
    func fetchDetails()
    func updateDetails(asendingOrder: Bool)
    func getId(at index:Int) -> String
}

// One of the concrete class to protocol "ListViewModel" to provide list of Astronauts
class AstronautListViewModel: ListViewModel {
    private let networkHandler: Networking
    private var astronautData: [AstronautListDataModel] = []
    private(set) var dispalyDetails = CurrentValueSubject<AstronautListData, Never>(AstronautListData(status: .pending, details: .success([])))
    
    init(networkHandler: Networking = NetworkHandler()) {
        self.networkHandler = networkHandler
    }
    
    /// To fetch Astronaut list
    func fetchDetails() {
        networkHandler.getDetails(AstronautData.self, networkUrl: .list) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(data):
                let details = data.results.compactMap {
                    AstronautListDataModel(id: $0.id,
                                           name: $0.name,
                                           profileImageUrl: $0.profileImageUrl,
                                           nationality: $0.nationality)
                }
                self.astronautData = details
                self.dispalyDetails.value = AstronautListData(status: .completed, details: .success(details))
                break
            case let .failure(error):
                self.dispalyDetails.value = AstronautListData(status: .completed, details: .failure(error))
                break
            }
        }
    }
    
    /// To update list of Astronauts based on provided order
    /// - Parameter asendingOrder: Bool "true" if update details in Ascending order else "false"
    func updateDetails(asendingOrder: Bool) {
        astronautData.sort {
            asendingOrder ==  true ? $0.name < $1.name : $0.name > $1.name
        }
        dispalyDetails.value = AstronautListData(status: .completed, details: .success(astronautData))
    }
    
    /// To get id of the Astronaut at provided index from Astronaut list
    /// - Parameter index: index of Astronaut from List whose Id need to be returned
    func getId(at index:Int) -> String {
        return String(astronautData[index].id)
    }
}
