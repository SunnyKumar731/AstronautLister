//
//  StubNetworkHandler.swift
//  AstronautListerTests
//
//  Created by Sunny Kumar on 26/3/22.
//  Copyright © 2022 Sunny Kumar. All rights reserved.
//

import Foundation
@testable import AstronautLister

enum NetworkStubStatus {
    case successList
    case successDetails
    case errorList
    case errorDetails
    case none
}

struct StubNetworkHandler: Networking {
    var status = NetworkStubStatus.none
    func getDetails<T>(_ dataModel: T.Type, networkUrl: NetworkUrl, completionHandler: @escaping (Result<T, DataError>) -> Void) where T : Decodable {
        switch status {
        case .successList:
            if let responseData = StubResponse.list.stubData() {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(dataModel.self, from: responseData)
                    completionHandler(.success(response))
                }
                catch (let error) {
                    print(error)
                    completionHandler(.failure(.parsingError))
                }
            }
        case .successDetails:
            if let responseData = StubResponse.details.stubData() {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(dataModel.self, from: responseData)
                    completionHandler(.success(response))
                }
                catch (let error) {
                    print(error)
                    completionHandler(.failure(.parsingError))
                }
            }
        case .errorList:
            completionHandler(.failure(.networkFailure))
        case .errorDetails:
            completionHandler(.failure(.networkFailure))
        default:
            break
        }
    }
}

enum StubResponse {
    case list
    case details
    
    func stubData() -> Data? {
        switch self {
        case .list:
        let responseString = """
            {
              "count": 694,
              "next": "https://spacelaunchnow.me/api/3.5.0/astronaut/?limit=10&offset=10",
              "previous": null,
              "results": [
                {
                  "id": 276,
                  "url": "https://spacelaunchnow.me/api/ll/2.2.0/astronaut/276/",
                  "name": "Franz Viehböck",
                  "status": {
                    "id": 2,
                    "name": "Retired"
                  },
                  "type": {
                    "id": 2,
                    "name": "Government"
                  },
                  "date_of_birth": "1960-08-24",
                  "date_of_death": null,
                  "nationality": "Austrian",
                  "bio": "Franz Artur Viehböck (born August 24, 1960 in Vienna) is an Austrian electrical engineer, and was Austria's first cosmonaut. He was titulated „Austronaut“ by his country's media. He visited the Mir space station in 1991 aboard Soyuz TM-13, returning aboard Soyuz TM-12 after spending just over a week in space.",
                  "twitter": null,
                  "instagram": null,
                  "wiki": "https://en.wikipedia.org/wiki/Franz_Viehb%C3%B6ck",
                  "agency": {
                    "id": 8,
                    "url": "https://spacelaunchnow.me/api/ll/2.2.0/agencies/8/",
                    "name": "Austrian Space Agency",
                    "featured": false,
                    "type": "Government",
                    "country_code": "AUT",
                    "abbrev": "ALR",
                    "description": "The Austrian Space Agency was founded in 1972 and joined the ESA as a member in 1987. In 2005, control of the ALR was transferred to the Austrian Agency for Aerospace. They coordinated the first flight of an Austrian in space with a Soyuz launch in 1990.",
                    "administrator": "Andreas Geisler",
                    "founding_year": "1972",
                    "launchers": "",
                    "spacecraft": "Spacelab | GALILEO",
                    "parent": null,
                    "image_url": null
                  },
                  "profile_image": "https://spacelaunchnow-prod-east.nyc3.cdn.digitaloceanspaces.com/media/astronaut_images/franz2520viehb25c325b6ck_image_20181201223901.jpg",
                  "profile_image_thumbnail": "https://spacelaunchnow-prod-east.nyc3.cdn.digitaloceanspaces.com/media/default/cache/54/57/5457ce75acb7b188196eb442e3f17b64.jpg",
                  "last_flight": "1991-10-02T05:59:38Z",
                  "first_flight": "1991-10-02T05:59:38Z"
                },
                {
                  "id": 225,
                  "url": "https://spacelaunchnow.me/api/ll/2.2.0/astronaut/225/",
                  "name": "Marcos Pontes",
                  "status": {
                    "id": 1,
                    "name": "Active"
                  },
                  "type": {
                    "id": 2,
                    "name": "Government"
                  },
                  "date_of_birth": "1963-03-11",
                  "date_of_death": null,
                  "nationality": "Brazilian",
                  "bio": "Marcos Cesar Pontes (born March 11, 1963) is a Brazilian Air Force pilot, engineer, AEB astronaut and author. He became the first South American and the first Lusophone to go into space when he launched into the International Space Station aboard Soyuz TMA-8 on March 30, 2006. He is the only Brazilian to have completed the NASA astronaut training program, although he switched to training in Russia after NASA's Space Shuttle program encountered problems.",
                  "twitter": null,
                  "instagram": null,
                  "wiki": "https://en.wikipedia.org/wiki/Marcos_Pontes",
                  "agency": {
                    "id": 12,
                    "url": "https://spacelaunchnow.me/api/ll/2.2.0/agencies/12/",
                    "name": "Brazilian Space Agency",
                    "featured": false,
                    "type": "Government",
                    "country_code": "BRA",
                    "abbrev": "AEB",
                    "description": "The Brazilian Space Agency is a space agency in South America.  They work in partnership with the US and Russia aboard the ISS. It was previously operated by the military until 1994. They now operate largely in tandem with other nations. They run a spaceport and rocket launch site both in Brazil. They built the VLM small satellite launch system in tandem with Germany. The VLS-1 was intended to be a primary launch vehicle for the BSA, but it failed 3 times and was canceled. They have restarted work on the system in tandem with the Russian Space Agency.",
                    "administrator": "José Raimundo Coelho",
                    "founding_year": "1961",
                    "launchers": "VLM | VLS",
                    "spacecraft": "None",
                    "parent": null,
                    "image_url": null
                  },
                  "profile_image": "https://spacelaunchnow-prod-east.nyc3.cdn.digitaloceanspaces.com/media/astronaut_images/marcos2520pontes_image_20181201212435.jpg",
                  "profile_image_thumbnail": "https://spacelaunchnow-prod-east.nyc3.cdn.digitaloceanspaces.com/media/default/cache/b5/9b/b59bb16a31087708ffb212d3e6938946.jpg",
                  "last_flight": "2006-03-30T02:30:00Z",
                  "first_flight": "2006-03-30T02:30:00Z"
                }
            ]
                  
            }
            """
            return responseString.data(using: .utf8)

        case .details:
            let responseString = """
                {
                                    "id": 225,
                                    "url": "https://spacelaunchnow.me/api/ll/2.2.0/astronaut/225/",
                                    "name": "Marcos Pontes",
                                    "status": {
                                        "id": 1,
                                        "name": "Active"
                                    },
                                    "type": {
                                        "id": 2,
                                        "name": "Government"
                                    },
                                    "agency": {
                                        "id": 12,
                                        "url": "https://spacelaunchnow.me/api/ll/2.2.0/agencies/12/",
                                        "name": "Brazilian Space Agency",
                                        "type": "Government"
                                    },
                                    "date_of_birth": "1963-03-11",
                                    "date_of_death": null,
                                    "nationality": "Brazilian",
                                    "twitter": null,
                                    "instagram": null,
                                    "bio": "Marcos Cesar Pontes (born March 11, 1963) is a Brazilian Air Force pilot, engineer, AEB astronaut and author. He became the first South American and the first Lusophone to go into space when he launched into the International Space Station aboard Soyuz TMA-8 on March 30, 2006. He is the only Brazilian to have completed the NASA astronaut training program, although he switched to training in Russia after NASA's Space Shuttle program encountered problems.",
                                    "profile_image": "https://spacelaunchnow-prod-east.nyc3.cdn.digitaloceanspaces.com/media/astronaut_images/marcos2520pontes_image_20181201212435.jpg",
                                    "profile_image_thumbnail": "https://spacelaunchnow-prod-east.nyc3.cdn.digitaloceanspaces.com/media/default/cache/b5/9b/b59bb16a31087708ffb212d3e6938946.jpg",
                                    "wiki": "https://en.wikipedia.org/wiki/Marcos_Pontes",
                                    "last_flight": "2006-03-30T02:30:00Z",
                                    "first_flight": "2006-03-30T02:30:00Z"
                }
                """
            return responseString.data(using: .utf8)
        }
    }
}
