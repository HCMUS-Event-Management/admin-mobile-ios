/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct UserProfile : Codable {
	let fullName : String?
	let email : String?
	let phone : String?
    var birthday : String?
	let identityCard : String?
    var gender : String?
	let avatar : String?
	let address : String?
	let isActive : Bool?
	let isDeleted : Bool?
	let createdAt : String?
	let updatedAt : String?
	let lastLogin : String?

	enum CodingKeys: String, CodingKey {

		case fullName = "fullName"
		case email = "email"
		case phone = "phone"
		case birthday = "birthday"
		case identityCard = "identityCard"
		case gender = "gender"
		case avatar = "avatar"
		case address = "address"
		case isActive = "isActive"
		case isDeleted = "isDeleted"
		case createdAt = "createdAt"
		case updatedAt = "updatedAt"
		case lastLogin = "lastLogin"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		phone = try values.decodeIfPresent(String.self, forKey: .phone)
		birthday = try values.decodeIfPresent(String.self, forKey: .birthday)
		identityCard = try values.decodeIfPresent(String.self, forKey: .identityCard)
		gender = try values.decodeIfPresent(String.self, forKey: .gender)
		avatar = try values.decodeIfPresent(String.self, forKey: .avatar)
		address = try values.decodeIfPresent(String.self, forKey: .address)
		isActive = try values.decodeIfPresent(Bool.self, forKey: .isActive)
		isDeleted = try values.decodeIfPresent(Bool.self, forKey: .isDeleted)
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
		updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
		lastLogin = try values.decodeIfPresent(String.self, forKey: .lastLogin)
	}
    
//    public func UpdateProfil(nameOfModel model : UpdateProfile?) {
//        self.fullName = model?.fullName
//        self.phone = model?.phone
//        self.gender = model?.gender
//        self.address = model?.address
//        self.identityCard = model?.identityCard
//        self.avatar = model?.avatar
//        self.isDeleted = model?.isDeleted
//        self.birthday = model?.birthday
//    }

}


