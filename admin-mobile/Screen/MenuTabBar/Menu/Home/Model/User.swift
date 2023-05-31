/*
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import RealmSwift
struct User : Codable {
    let id : String?
    let fullName : String?
    let email : String?
    let phone : String?
    let identityCard : String?
    let gender : String?
    let address : String?
    let isActive : Bool?
    let isDeleted : Bool?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case fullName = "fullName"
        case email = "email"
        case phone = "phone"
        case identityCard = "identityCard"
        case gender = "gender"
        case address = "address"
        case isActive = "isActive"
        case isDeleted = "isDeleted"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        identityCard = try values.decodeIfPresent(String.self, forKey: .identityCard)
        gender = try values.decodeIfPresent(String.self, forKey: .gender)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        isActive = try values.decodeIfPresent(Bool.self, forKey: .isActive)
        isDeleted = try values.decodeIfPresent(Bool.self, forKey: .isDeleted)
    }

}


final class UserObject: Object {
    @objc dynamic var id : String = ""
    @objc dynamic var fullName : String = ""
    @objc dynamic var email : String = ""
    @objc dynamic var phone : String = ""
    @objc dynamic var identityCard : String = ""
    @objc dynamic var gender : String = ""
    @objc dynamic var address : String = ""
    @objc dynamic var isActive : Bool = false
    @objc dynamic var isDeleted : Bool = false
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension User: Persistable {
    public init(managedObject: UserObject) {
        id = managedObject.id
        fullName = managedObject.fullName
        email = managedObject.email
        phone = managedObject.phone
        identityCard = managedObject.identityCard
        gender = managedObject.gender
        address = managedObject.address
        isActive = managedObject.isActive
        isDeleted = managedObject.isDeleted
    }
    
    public func managedObject() -> UserObject {
        let character = UserObject()
        character.id = id ?? ""
        character.fullName = fullName ?? ""
        character.email = email ?? ""
        character.phone = phone ?? ""
        character.identityCard = identityCard ?? ""
        character.gender = gender ?? ""
        character.address = address ?? ""
        character.isActive = isActive ?? false
        character.isDeleted = isDeleted ?? false
        return character
    }
}
