/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct DataReponsePermissionEvents : Codable {
	let id : String?
	let fullName : String?
	let email : String?
	let gender : String?
	let address : String?
	let isActive : Bool?
	let events : [Events]?
	let roles : [Roles]?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case fullName = "fullName"
		case email = "email"
		case gender = "gender"
		case address = "address"
		case isActive = "isActive"
		case events = "events"
		case roles = "roles"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		gender = try values.decodeIfPresent(String.self, forKey: .gender)
		address = try values.decodeIfPresent(String.self, forKey: .address)
		isActive = try values.decodeIfPresent(Bool.self, forKey: .isActive)
		events = try values.decodeIfPresent([Events].self, forKey: .events)
		roles = try values.decodeIfPresent([Roles].self, forKey: .roles)
	}

}
