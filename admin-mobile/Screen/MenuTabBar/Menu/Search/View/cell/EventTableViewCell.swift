
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
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        let startTime = dateFormatter.date(from: app.startAt ?? "1970-01-01T00:00:00.000Z")
        let endTime = dateFormatter.date(from: app.endAt ?? "1970-01-01T00:00:00.000Z")

        let formattedStartTime: String
        let formattedEndTime: String

        if #available(iOS 15.0, *) {
            formattedStartTime = startTime?.formatted(date: .omitted, time: .shortened) ?? ""
            formattedEndTime = endTime?.formatted(date: .abbreviated, time: .shortened) ?? ""
        } else {
            let newDateFormatter = DateFormatter()
            newDateFormatter.dateStyle = .none
            newDateFormatter.timeStyle = .short

            formattedStartTime = newDateFormatter.string(from: startTime ?? Date())
            formattedEndTime = newDateFormatter.string(from: endTime ?? Date())
        }

        startAt.text = "\(formattedStartTime) - \(formattedEndTime)"

        
        location.text = app.location?.name
        img.kf.setImage(with: URL(string: app.image!))
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func cancel() {
    }
}
