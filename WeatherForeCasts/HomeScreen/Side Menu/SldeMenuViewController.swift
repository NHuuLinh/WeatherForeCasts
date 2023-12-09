import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Kingfisher

protocol MenuDelegate: AnyObject {
    func selectMenuItem(with menuItems: MenuItem)
}

class SideMenuViewController: UIViewController {
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var menuTableView: UITableView!
    weak var delegate: MenuDelegate?
    var onMenuItemSelected: ((MenuItem) -> Void)?
    var currentUser: UserProfile?
    private let storage = Storage.storage().reference()
    private var databaseRef = Database.database().reference()
    var menuItems: [MenuItem] = []
    let profilelb = NSLocalizedString("Profile", comment: "")
    let pinLocation = NSLocalizedString("Pin Location", comment: "")
    let settings = NSLocalizedString("Settings", comment: "")
    let notification = NSLocalizedString("Notification", comment: "")
    let aboutUs = NSLocalizedString("About Us", comment: "")
    let privatePolicy = NSLocalizedString("Private Policy", comment: "")
    let termsOfUse = NSLocalizedString("Terms Of Use", comment: "")
    let logout = NSLocalizedString("Logout", comment: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        loadDataFromFirebase()
        tableMenu()
    }

    func setUpView() {
        menuTableView.dataSource = self
        menuTableView.delegate = self
        let menuCell = UINib(nibName: "MenuTableViewCell", bundle: nil)
        menuTableView.register(menuCell, forCellReuseIdentifier: "MenuTableViewCell")
        menuTableView.rowHeight = 70
    }
    func tableMenu() {
        menuItems = [
            MenuItem(title: profilelb,
                     image: UIImage(named: "avatar"),
                     screen: .profile),
            MenuItem(title: pinLocation,
                     image: UIImage(named: "Location"),
                     screen: .location),
            MenuItem(title: settings,
                     image: UIImage(named: "settings"),
                     screen: .settings),
            MenuItem(title: notification,
                     image: UIImage(named: "notification"),
                     screen: .notification),
            MenuItem(title: aboutUs,
                     image: UIImage(named: "aboutUs"),
                     screen: .aboutUs),
            MenuItem(title: privatePolicy,
                     image: UIImage(named: "privatePolicy"),
                     screen: .privatePolicy),
            MenuItem(title: termsOfUse,
                     image: UIImage(named: "termsOfUse"),
                     screen: .termsOfUse),
            MenuItem(title: logout,
                     image: UIImage(named: "logout"),
                     screen: .logout)
        ]
    }
}
extension SideMenuViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("menuItems: \(menuItems.count)")
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
        cell.getMenuTitle(item: menuItems[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onMenuItemSelected?(menuItems[indexPath.row])
        print("onMenuItemSelected:1")
    }
    
    
}
extension SideMenuViewController {
     func loadDataFromFirebase() {
        showLoading(isShow: true)
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            showLoading(isShow: false)
            return
        }
        self.userEmail.text = Auth.auth().currentUser?.email
        let userRef = Database.database().reference().child("users").child(currentUserID)
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            self.showLoading(isShow: false)
            if let userData = snapshot.value as? [String: Any] {
                self.userName.text = userData["name"] as? String
                if let imageURLString = userData["avatar"] as? String,
                   let imageURL = URL(string: imageURLString) {
                    self.userAvatar.kf.setImage(with: imageURL)
                }
                self.showLoading(isShow: false)
            }
        }
        print("loadDataFromFirebase Done")
    }
}

