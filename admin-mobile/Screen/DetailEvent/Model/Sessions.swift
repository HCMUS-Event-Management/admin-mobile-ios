/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import RealmSwift
struct Sessions : Codable {
	var id : String?
	var eventId : String?
	var startAt : String?
	var endAt : String?
	var zoomMeetingId : String?
	var zoomPasscode : String?
	var zoomLink : String?
	var proposalSessionTickets : [ProposalSessionTickets]?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case eventId = "eventId"
		case startAt = "startAt"
		case endAt = "endAt"
		case zoomMeetingId = "zoomMeetingId"
		case zoomPasscode = "zoomPasscode"
		case zoomLink = "zoomLink"
		case proposalSessionTickets = "proposalSessionTickets"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		eventId = try values.decodeIfPresent(String.self, forKey: .eventId)
		startAt = try values.decodeIfPresent(String.self, forKey: .startAt)
		endAt = try values.decodeIfPresent(String.self, forKey: .endAt)
		zoomMeetingId = try values.decodeIfPresent(String.self, forKey: .zoomMeetingId)
		zoomPasscode = try values.decodeIfPresent(String.self, forKey: .zoomPasscode)
		zoomLink = try values.decodeIfPresent(String.self, forKey: .zoomLink)
		proposalSessionTickets = try values.decodeIfPresent([ProposalSessionTickets].self, forKey: .proposalSessionTickets)
	}

}


final class SessionsObject: Object {
    @objc dynamic var id : String = ""
    @objc dynamic var eventId : String = ""
    @objc dynamic var startAt : String = ""
    @objc dynamic var endAt : String = ""
    @objc dynamic var zoomMeetingId : String = ""
    @objc dynamic var zoomPasscode : String = ""
    @objc dynamic var zoomLink : String = ""
    var proposalSessionTickets = List<ProposalSessionTicketsObject>()
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension Sessions: Persistable {
    public init(managedObject: SessionsObject) {
        id = managedObject.id
        eventId = managedObject.eventId
        startAt = managedObject.startAt
        endAt = managedObject.endAt
        zoomMeetingId = managedObject.zoomMeetingId
        zoomPasscode = managedObject.zoomPasscode
        zoomLink = managedObject.zoomLink
        
    }
    
    public func managedObject() -> SessionsObject {
        let character = SessionsObject()
        character.id = id ?? ""
        character.eventId = eventId ?? ""
        character.startAt = startAt ?? ""
        character.endAt = endAt ?? ""
        character.zoomMeetingId = zoomMeetingId ?? ""
        character.zoomPasscode = zoomPasscode ?? ""
        character.zoomLink = zoomLink ?? ""
        proposalSessionTickets?.forEach({
            i in
            character.proposalSessionTickets.append(i.managedObject())
        })
        
        return character
    }
}
