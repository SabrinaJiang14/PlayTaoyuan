//
//  TourRequest.swift
//  PlayTaoyuan
//
//  Created by Eileen on 2021/9/11.
//

import Foundation
import Combine
import SJUtil


class TourRequest:NSObject, RequestProtocol {

    typealias Response = ToursDataBean
    
    var request: Request { Request(url: "/zh-tw/Travel/Tour?category=&season=&page=1") }
    
    weak var _client:URLSessionClient!
    func setClient(_ client: URLSessionClient) -> Self {
        _client = client
        return self
    }
    
    func excute() -> AnyPublisher<ToursDataBean, Error> {
        return _client.send(request)
    }
}

// MARK: - Category
struct ToursDataBean: JSONCodable {
    let infos: ToursInfos

    enum CodingKeys: String, CodingKey {
        case infos = "Infos"
    }
}

// MARK: - Infos
struct ToursInfos: JSONCodable {
    let declaration: ToursDeclaration
    let info: [ToursInfo]

    enum CodingKeys: String, CodingKey {
        case declaration = "Declaration"
        case info = "Info"
    }
}

// MARK: - Declaration
struct ToursDeclaration: JSONCodable {
    let orgname, siteName, total: String
    let officialWebSite: String
    let updated: String

    enum CodingKeys: String, CodingKey {
        case orgname = "Orgname"
        case siteName = "SiteName"
        case total = "Total"
        case officialWebSite = "Official-WebSite"
        case updated = "Updated"
    }
}

// MARK: - Info
struct ToursInfo: JSONCodable {
    let id, tyWebsite: String
    let classes: ToursClasses
    let name, infoDescription: String
    let author: String
    let season: String
    let transportations: ToursTransportations
    let targets: ToursTargets?
    let consume: String
    let remark: String?
    let note: String
    let image: Image
    let posted, modified: String

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case tyWebsite = "TYWebsite"
        case classes = "Classes"
        case name = "Name"
        case infoDescription = "Description"
        case author = "Author"
        case season = "Season"
        case transportations = "Transportations"
        case targets = "Targets"
        case consume = "Consume"
        case remark = "Remark"
        case note = "Note"
        case image = "Image"
        case posted = "Posted"
        case modified = "Modified"
    }
}

// MARK: - Classes
struct ToursClasses: JSONCodable {
    let classesClass: ToursClass

    enum CodingKeys: String, CodingKey {
        case classesClass = "Class"
    }
}

enum ToursClass: JSONCodable {
    case string(String)
    case stringArray([String])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([String].self) {
            self = .stringArray(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Class.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Class"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let x):
            try container.encode(x)
        case .stringArray(let x):
            try container.encode(x)
        }
    }
}

// MARK: - Targets
struct ToursTargets: JSONCodable {
    let target: Class

    enum CodingKeys: String, CodingKey {
        case target = "Target"
    }
}

// MARK: - Transportations
struct ToursTransportations: JSONCodable {
    let transportation: ToursTransportationUnion

    enum CodingKeys: String, CodingKey {
        case transportation = "Transportation"
    }
}

enum ToursTransportationUnion: JSONCodable {
    case enumArray([String])
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([String].self) {
            self = .enumArray(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(ToursTransportationUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for TransportationUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .enumArray(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}
