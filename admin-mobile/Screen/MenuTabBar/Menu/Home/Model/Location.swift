/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import RealmSwift
struct Location : Codable {
	let id : String?
	let name : String?
	let longitude : String?
	let latitude : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case name = "name"
		case longitude = "longitude"
		case latitude = "latitude"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
		latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
	}
}


final class LocationObject: Object {
    @objc dynamic var id : String = ""
    @objc dynamic var name : String = ""
    @objc dynamic var longitude : String = ""
    @objc dynamic var latitude : String = ""
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension Location: Persistable {
    public init(managedObject: LocationObject) {
        id = managedObject.id
        name = managedObject.name
        longitude = managedObject.longitude
        latitude = managedObject.latitude
    }
    
    public func managedObject() -> LocationObject {
        let character = LocationObject()
        character.id = id ?? ""
        character.name = name ?? ""
        character.longitude = longitude ?? ""
        character.latitude = latitude ?? ""
        return character
    }
}
