import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Kingfisher
import CoreData
import KeychainSwift


protocol SideMenuViewControllerDisplay: AnyObject {
//    func selectMenuItem(with menuItems: MenuItem)
    func loadDataFromFirebase()
}

class SideMenuViewController: UIViewController, SideMenuViewControllerDisplay {
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var menuTableView: UITableView!
//    weak var delegate: SideMenuDelegate?
    var onMenuItemSelected: ((MenuItem) -> Void)?
    var currentUser: UserProfile?
    private let storage = Storage.storage().reference()
    private var databaseRef = Database.database().reference()
    var menuItems: [MenuItem] = []
    let keychain = KeychainSwift()

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
        chooseDataToLoad()
        tableMenu()
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }

    func setUpView() {
        menuTableView.dataSource = self
        menuTableView.delegate = self
        let menuCell = UINib(nibName: "MenuTableViewCell", bundle: nil)
        menuTableView.register(menuCell, forCellReuseIdentifier: "MenuTableViewCell")
        menuTableView.rowHeight = 70
        menuTableView.separatorStyle = .none
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
                     image: UIImage(named: "Settings"),
                     screen: .settings),
            MenuItem(title: notification,
                     image: UIImage(named: "Notification"),
                     screen: .notification),
            MenuItem(title: aboutUs,
                     image: UIImage(named: "Aboutus"),
                     screen: .aboutUs),
            MenuItem(title: privatePolicy,
                     image: UIImage(named: "privatePolicy"),
                     screen: .privatePolicy),
            MenuItem(title: termsOfUse,
                     image: UIImage(named: "termsOfUse"),
                     screen: .termsOfUse),
            MenuItem(title: logout,
                     image: UIImage(named: "Logout"),
                     screen: .logout)
        ]
    }
}
extension SideMenuViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
        cell.getMenuTitle(item: menuItems[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onMenuItemSelected?(menuItems[indexPath.row])
        print("onMenuItemSelected:\(indexPath.row)")
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
                print("Dữ liệu tải thành công")
            } else {
                print("Không thể lấy dữ liệu từ Firebase")
            }
        }
   }
    func loadProfileFromCoreData(){
        let profileData = CoreDataHelper.share.getProfileValuesFromCoreData()
        userAvatar.image = profileData.avatar
        userName.text = profileData.name
        userEmail.text = keychain.get("email")
    }
    func chooseDataToLoad(){
        if UserDefaults.standard.didUpdateProfile {
            loadProfileFromCoreData()
            print("loadProfileFromCoreData")
        } else {
            loadDataFromFirebase()
            print("loadDataFromFirebase")
        }
    }
}

