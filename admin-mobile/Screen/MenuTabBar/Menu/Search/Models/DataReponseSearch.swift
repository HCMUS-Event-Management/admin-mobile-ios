/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct DataReponseSearch : Codable {
	let id : String?
	let title : String?
	let description : String?
	let startAt : String?
	let endAt : String?
	let status : String?
	let urlWeb : String?
	let image : String?
	let locationId : String?
	let organizationName : String?
	let seatingPlan : String?
	let createdAt : String?
	let updatedAt : String?
	let type : String?
	let isOnline : Bool?
	let categoryId : String?
	let userId : String?
    let location: Location?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case title = "title"
		case description = "description"
		case startAt = "startAt"
		case endAt = "endAt"
		case status = "status"
		case urlWeb = "urlWeb"
		case image = "image"
		case locationId = "locationId"
		case organizationName = "organizationName"
		case seatingPlan = "seatingPlan"
		case createdAt = "createdAt"
		case updatedAt = "updatedAt"
		case type = "type"
		case isOnline = "isOnline"
		case categoryId = "categoryId"
		case userId = "userId"
        case location = "location"

	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		startAt = try values.decodeIfPresent(String.self, forKey: .startAt)
		endAt = try values.decodeIfPresent(String.self, forKey: .endAt)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		urlWeb = try values.decodeIfPresent(String.self, forKey: .urlWeb)
		image = try values.decodeIfPresent(String.self, forKey: .image)
		locationId = try values.decodeIfPresent(String.self, forKey: .locationId)
		organizationName = try values.decodeIfPresent(String.self, forKey: .organizationName)
		seatingPlan = try values.decodeIfPresent(String.self, forKey: .seatingPlan)
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
		updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		isOnline = try values.decodeIfPresent(Bool.self, forKey: .isOnline)
		categoryId = try values.decodeIfPresent(String.self, forKey: .categoryId)
		userId = try values.decodeIfPresent(String.self, forKey: .userId)
        location = try values.decodeIfPresent(Location.self, forKey: .location)

	}

}
