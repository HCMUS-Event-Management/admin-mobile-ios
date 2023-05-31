/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import RealmSwift
struct ProposalSessionTickets : Codable {
	let id : String?
	let ticketTitle : String?
	let startTimeForSell : String?
	let endTimeForSell : String?
	let price : Int?
	let quantity : String?
	let sessionId : String?
	let maximumTicketPurchased : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case ticketTitle = "ticketTitle"
		case startTimeForSell = "startTimeForSell"
		case endTimeForSell = "endTimeForSell"
		case price = "price"
		case quantity = "quantity"
		case sessionId = "sessionId"
		case maximumTicketPurchased = "maximumTicketPurchased"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		ticketTitle = try values.decodeIfPresent(String.self, forKey: .ticketTitle)
		startTimeForSell = try values.decodeIfPresent(String.self, forKey: .startTimeForSell)
		endTimeForSell = try values.decodeIfPresent(String.self, forKey: .endTimeForSell)
		price = try values.decodeIfPresent(Int.self, forKey: .price)
		quantity = try values.decodeIfPresent(String.self, forKey: .quantity)
		sessionId = try values.decodeIfPresent(String.self, forKey: .sessionId)
		maximumTicketPurchased = try values.decodeIfPresent(String.self, forKey: .maximumTicketPurchased)
	}

}


final class ProposalSessionTicketsObject: Object {
    @objc dynamic var id : String = ""
    @objc dynamic var ticketTitle : String = ""
    @objc dynamic var startTimeForSell : String = ""
    @objc dynamic var endTimeForSell : String = ""
    @objc dynamic var price : Int = 0
    @objc dynamic var quantity : String = ""
    @objc dynamic var sessionId : String = ""
    @objc dynamic var maximumTicketPurchased : String = ""
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension ProposalSessionTickets: Persistable {
    public init(managedObject: ProposalSessionTicketsObject) {
        id = managedObject.id
        ticketTitle = managedObject.ticketTitle
        startTimeForSell = managedObject.startTimeForSell
        endTimeForSell = managedObject.endTimeForSell
        price = managedObject.price
        quantity = managedObject.quantity
        sessionId = managedObject.sessionId
        maximumTicketPurchased = managedObject.maximumTicketPurchased
    }
    
    public func managedObject() -> ProposalSessionTicketsObject {
        let character = ProposalSessionTicketsObject()
        character.id = id ?? ""
        character.ticketTitle = ticketTitle ?? ""
        character.startTimeForSell = startTimeForSell ?? ""
        character.endTimeForSell = endTimeForSell ?? ""
        character.price = price ?? 0
        character.quantity = quantity ?? ""
        character.sessionId = sessionId ?? ""
        character.maximumTicketPurchased = maximumTicketPurchased ?? ""
        return character
    }
}
