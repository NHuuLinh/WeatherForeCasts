
import UIKit

struct MenuItem {
    let title: String?
    let image: UIImage?
    let screen: Screen
}
enum Screen {
    case profile
    case location
    case settings
    case notification
    case aboutUs
    case privatePolicy
    case termsOfUse
    case logout
}



class MenuTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func getMenuTitle(item: MenuItem) {
        titleLabel.text = item.title ?? "error"
        titleImage.image = item.image ?? UIImage(named: "warning")
    }
}
