//
//  AttractionRequest.swift
//  PlayTaoyuan
//
//  Created by Eileen on 2021/9/11.
//

import Foundation
import Combine
import SJUtil


class AttractionRequest: NSObject, RequestProtocol {

    typealias Response = AttractionDatabean
    
    var request: Request { Request(url: "/zh-tw/Travel/Attraction?page=1") }
    
    weak var _client:URLSessionClient!
    
    func setClient(_ client:URLSessionClient) -> Self {
        _client = client
        return self
    }
    
    func excute() -> AnyPublisher<AttractionDatabean, Error> {
        return _client.send(request)
    }
}




struct AttractionDatabean:JSONCodable {
    let infos: Infos

    enum CodingKeys: String, CodingKey {
        case infos = "Infos"
    }
}

// MARK: - Infos
struct Infos: JSONCodable {
    let declaration: Declaration
    let info: [Info]

    enum CodingKeys: String, CodingKey {
        case declaration = "Declaration"
        case info = "Info"
    }
}

// MARK: - Declaration
struct Declaration: JSONCodable {
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
struct Info: JSONCodable {
    let id, tyWebsite: String
    let classes: Classes
    let name, infoDescription, zipcode, district: String
    let address, eastLongitude, northLatitude, phone: String
    let fax, email, openTime, ticket: String
    let remind, parking: String
    let facilities: Facilities
    let images: Images
    let links: Links?
    let posted, modified: String

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case tyWebsite = "TYWebsite"
        case classes = "Classes"
        case name = "Name"
        case infoDescription = "Description"
        case zipcode = "Zipcode"
        case district = "District"
        case address = "Address"
        case eastLongitude = "East-Longitude"
        case northLatitude = "North-Latitude"
        case phone = "Phone"
        case fax = "Fax"
        case email = "Email"
        case openTime = "Open-Time"
        case ticket = "Ticket"
        case remind = "Remind"
        case parking = "Parking"
        case facilities = "Facilities"
        case images = "Images"
        case links = "Links"
        case posted = "Posted"
        case modified = "Modified"
    }
}

// MARK: - Classes
struct Classes: JSONCodable {
    let classesClass: Class

    enum CodingKeys: String, CodingKey {
        case classesClass = "Class"
    }
}

enum Class: JSONCodable {
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

// MARK: - Facilities
struct Facilities: JSONCodable {
    let facility: [String]

    enum CodingKeys: String, CodingKey {
        case facility = "Facility"
    }
}

// MARK: - Images
struct Images: JSONCodable {
    let image: [Image]

    enum CodingKeys: String, CodingKey {
        case image = "Image"
    }
}

// MARK: - Image
struct Image: JSONCodable {
    let src: String
    let subject: String
    let ext: String?

    enum CodingKeys: String, CodingKey {
        case src = "Src"
        case subject = "Subject"
        case ext = "Ext"
    }
}


// MARK: - Links
struct Links: JSONCodable {
    let link: Link

    enum CodingKeys: String, CodingKey {
        case link = "Link"
    }
}

// MARK: - Link
struct Link: JSONCodable {
    let src: String
    let subject: String

    enum CodingKeys: String, CodingKey {
        case src = "Src"
        case subject = "Subject"
    }
}
