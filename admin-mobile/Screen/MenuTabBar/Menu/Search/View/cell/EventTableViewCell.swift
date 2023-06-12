
import UIKit
import Kingfisher

class EventTableViewCell: UITableViewCell, ReusableView, NibLoadableView {

    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var startAt: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var imgView: UIView!
    @IBOutlet weak var mainView: UIView!

    func configure(app: DataReponseSearch) {
        imgView.layer.cornerRadius = 20
        imgView.layer.borderColor = UIColor(red: 94/255, green: 135/255, blue: 240/255, alpha: 1).cgColor
        imgView.layer.borderWidth = 0.5

        mainView.layer.cornerRadius = 20
        mainView.layer.masksToBounds = true
        title.text = app.title
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//
//        let startTime = dateFormatter.date(from:  app.startAt ?? "1970-01-01T00:00:00.000Z")
//        let endTime = dateFormatter.date(from:  app.endAt ?? "1970-01-01T00:00:00.000Z")
//        startAt.text = "\(startTime!.formatted(date: .omitted, time: .shortened)) - \(endTime!.formatted(date: .abbreviated, time: .shortened))"
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        let startDate = dateFormatter.date(from: app.startAt ?? "1970-01-01T00:00:00.000Z")
        let endDate = dateFormatter.date(from: app.endAt ?? "1970-01-01T00:00:00.000Z")

        var formattedStartDate: String
        var formattedEndDate: String

        if #available(iOS 15.0, *) {
            formattedStartDate = startDate?.formatted(date: .abbreviated, time: .omitted) ?? ""
            formattedEndDate = endDate?.formatted(date: .abbreviated, time: .omitted) ?? ""
        } else {
            let newDateFormatter = DateFormatter()
            newDateFormatter.dateStyle = .short
            newDateFormatter.timeStyle = .none
            formattedStartDate = newDateFormatter.string(from: startDate ?? Date())
            formattedEndDate = newDateFormatter.string(from: endDate ?? Date())
        }

        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")
        timeFormatter.dateFormat = "HH:mm"

        let formattedStartTime = timeFormatter.string(from: startDate ?? Date())
        let formattedEndTime = timeFormatter.string(from: endDate ?? Date())

        startAt.text = """
        \(formattedStartDate) \(formattedStartTime)
        """

        
        location.text = app.location?.name
        img.kf.setImage(with: URL(string: app.image!))
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func cancel() {
    }
}
