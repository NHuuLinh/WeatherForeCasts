//
//  ProfileViewController.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 17/11/2023.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import MobileCoreServices
import MBProgressHUD
import Kingfisher


enum Gender: String {
    case male
    case female
    case none
}


class ProfileViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var idTF: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var clearNameBtn: UIButton!
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var noneGenderBtn: UIButton!
    @IBOutlet weak var NameEditOff: UIImageView!
    @IBOutlet weak var DateOfBirthEditOff: UIImageView!
    @IBOutlet weak var PhoneEditOff: UIImageView!

    
    @IBOutlet weak var dateOfBirthTF: UITextField!
    @IBOutlet weak var clearDateOfBirthBtn: UIButton!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var clearPhoneNumberBtn: UIButton!
    @IBOutlet weak var editAvatarBtn: UIButton!
    @IBOutlet weak var editProfileBtn: UIButton!
    @IBOutlet weak var clearEditBtn: UIButton!
    @IBOutlet weak var saveEditBtn: UIButton!
    var imagePicker = UIImagePickerController()
    let datePicker = UIDatePicker()
    var selectedGender: Gender = .none
    var userGender: Gender = .none
    private var databaseRef = Database.database().reference()
    var isEditingProfile: Bool = false
    private let storage = Storage.storage().reference()
    var currentUser: UserProfile?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataFromFirebase()
        setupView()
        createDatePicker()
        phoneNumberTF.delegate = self
        phoneNumberTF.keyboardType = .phonePad

    }
    func showLoading(isShow: Bool) {
        if isShow {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        } else {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    func setEditingState(_ isEditing: Bool) {
        isEditingProfile = isEditing
        nameTF.isUserInteractionEnabled = isEditing
        dateOfBirthTF.isUserInteractionEnabled = isEditing
        phoneNumberTF.isUserInteractionEnabled = isEditing
        editAvatarBtn.isHidden = !isEditing
        maleBtn.isEnabled = isEditing
        femaleBtn.isEnabled = isEditing
        noneGenderBtn.isEnabled = isEditing
        saveEditBtn.isEnabled = isEditing
        NameEditOff.isHidden = isEditing
        DateOfBirthEditOff.isHidden = isEditing
        PhoneEditOff.isHidden = isEditing
    }

    func setButtonVisibility(_ isVisible: Bool) {
        clearNameBtn.isHidden = !isVisible
        clearDateOfBirthBtn.isHidden = !isVisible
        clearPhoneNumberBtn.isHidden = !isVisible
    }

    func setEditProfileBtnStyle(_ isEditing: Bool) {
        if isEditing {
            editProfileBtn.backgroundColor = .yellow
            saveEditBtn.backgroundColor = .white
        } else {
            editProfileBtn.backgroundColor = .white
            saveEditBtn.backgroundColor = .systemGray
        }
        editProfileBtn.setTitleColor(UIColor.black, for: .normal)
    }

    func setupView() {
        setEditingState(false)
        setButtonVisibility(false)
        setEditProfileBtnStyle(false)
        saveEditBtn.alpha = 1
    }

    func editProfileState() {
        setEditingState(true)
//        setButtonVisibility(true)
        setEditProfileBtnStyle(true)
        saveEditBtn.alpha = 1
    }

    @IBAction func handleBtn(_ sender: UIButton) {
        switch sender {
        case backBtn:
            self.navigationController?.popToRootViewController(animated: true)
        case editAvatarBtn:
            pickImage()
        case clearNameBtn:
            nameTF.text = ""
            textFieldChangeHandle(nameTF)
        case maleBtn:
            selectedGender = .male
            userGender = selectedGender
            print("Nam")
        case femaleBtn:
            selectedGender = .female
            userGender = selectedGender
            print("Nữ")
        case noneGenderBtn:
            selectedGender = .none
            userGender = selectedGender
            print("Không xác định")
        case clearDateOfBirthBtn:
            dateOfBirthTF.text = ""
            textFieldChangeHandle(dateOfBirthTF)
            print("dateOfBirthTF")
        case clearPhoneNumberBtn:
            phoneNumberTF.text = ""
            textFieldChangeHandle(phoneNumberTF)
            print("phoneNumberTF")
        case editProfileBtn:
            editProfileState()
            print("editProfileBtn")
        case clearEditBtn:
            loadDataFromFirebase()
            setupView()
        case saveEditBtn:
            updateDataToFireBase()
            print("updateDataToFireBase")
            default:
                break
            }
            updateGenderButtons()
        }
    @IBAction func textFieldChangeHandle(_ textField: UITextField) {
        switch textField {
        case nameTF:
            clearNameBtn.isHidden = textField.text?.isEmpty ?? true
        case dateOfBirthTF:
            clearDateOfBirthBtn.isHidden = textField.text?.isEmpty ?? true
        case phoneNumberTF:
            clearPhoneNumberBtn.isHidden = textField.text?.isEmpty ?? true
        default:
            break
        }
    }
    func updateGenderButtons() {
        let imageSelected = UIImage(named: "radioChecked")
        let imageDeselected = UIImage(named: "radioUnchecked")

        maleBtn.isSelected = selectedGender == .male
        femaleBtn.isSelected = selectedGender == .female
        noneGenderBtn.isSelected = selectedGender == .none
        maleBtn.setImage(maleBtn.isSelected ? imageSelected : imageDeselected, for: .normal)
        femaleBtn.setImage(femaleBtn.isSelected ? imageSelected : imageDeselected, for: .normal)
        noneGenderBtn.setImage(noneGenderBtn.isSelected ? imageSelected : imageDeselected, for: .normal)
    }
  
}
// MARK: - Fire base data handle
extension ProfileViewController {
    func loadDataFromFirebase() {
        showLoading(isShow: true)
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            showLoading(isShow: false)
            return
        }
        let userRef = Database.database().reference().child("users").child(currentUserID)
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            self.showLoading(isShow: false)
            if let userData = snapshot.value as? [String: Any] {
                self.nameTF.text = userData["name"] as? String
                self.dateOfBirthTF.text = userData["dateOfBirth"] as? String
                self.phoneNumberTF.text = userData["phoneNumber"] as? String
                // Lấy giá trị giới tính từ userData và gán cho userGender
                if let genderString = userData["gender"] as? String, let gender = Gender(rawValue: genderString) {
                    self.userGender = gender
                    self.selectedGender = gender
                    print(genderString)
                    // Update gender buttons after setting userGender
                    self.updateGenderButtons()
                }

                // Load image URL from Firebase Realtime Database
                if let imageURLString = userData["avatar"] as? String,
                   let imageURL = URL(string: imageURLString) {
                    self.avatarImg.kf.setImage(with: imageURL)
                }
            }
        }
    }

    
    func updateDataToFireBase1() {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        let userRef = databaseRef.child("users").child(currentUser)
        userRef.observeSingleEvent(of: .value) { snapshot in
            // Check if the snapshot has data
            guard snapshot.childrenCount > 0 else {
                return
            }

            if let userData = snapshot.value as? [String: Any] {
                let id = userData["id"] as? String ?? ""
                let name = userData["name"] as? String ?? ""
                let gender = userData["gender"] as? String ?? ""
                let dateOfBirth = userData["dateOfBirth"] as? String ?? ""
                let phoneNumber = userData["phoneNumber"] as? String ?? ""
                let avatar = userData["avatar"] as? String ?? ""

                self.currentUser = UserProfile(id: id, name: name, gender: gender, dateOfBirth: dateOfBirth, phoneNumber: phoneNumber, avatar: avatar)

                // Download image from URL and update the UIImageView on the main thread
                if let imageURL = URL(string: avatar) {
                    DispatchQueue.main.async {
//                        self.avatarImg.kf.setImage(with: imageURL)
                    }
                }
                // Update other UI elements on the main thread
                DispatchQueue.main.async {
                    self.idTF.text = id
                    self.nameTF.text = name
                    if let genderString = userData["gender"] as? String, let gender = Gender(rawValue: genderString) {
                        self.userGender = gender
                    }
                    self.dateOfBirthTF.text = dateOfBirth
                    self.phoneNumberTF.text = phoneNumber
                    print("Image URL: \(avatar)")
                }
            }
        }
    }
    func updateDataToFireBase() {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        let userRef = databaseRef.child("users").child(currentUser)
        userRef.child("name").setValue(nameTF.text)
        userRef.child("dateOfBirth").setValue(dateOfBirthTF.text)
        userRef.child("phoneNumber").setValue(phoneNumberTF.text)
        userRef.child("gender").setValue(selectedGender.rawValue)
        updateGenderButtons()
        // update ảnh lên firebase
        uploadImageToFirebaseStorage()
    }

}
// MARK: - date of birth text field
extension ProfileViewController {
    func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        // thêm nút done
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBtn))
        // thêm khoảng trống
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        // thêm nút cancel
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBtn))
        //  cài đặt thứ tự nút
        toolbar.setItems([doneButton, flexibleSpace, cancelButton], animated: true)
        return toolbar
    }
    func createDatePicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.locale = Locale(identifier: "en_US")
        dateOfBirthTF.inputView = datePicker
        dateOfBirthTF.inputAccessoryView = createToolbar()
    }
    @objc func doneBtn(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        self.dateOfBirthTF.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    @objc func cancelBtn() {
            self.view.endEditing(true)
        }
}
// MARK: - Load image slectecd
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        // Update the UI with the picked image
        avatarImg.image = pickedImage

        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func pickImage() {
        let alertViewController = UIAlertController(title: "Choose Image", message: "Choose your option", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.openCamera()
        }
        let gallery = UIAlertAction(title: "Gallery", style: .default) { (_) in
            self.openGallary()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
        }
        alertViewController.addAction(camera)
        alertViewController.addAction(gallery)
        alertViewController.addAction(cancel)

        present(alertViewController, animated: true, completion: nil)
    }
}
// MARK: - Alert Choose image
extension ProfileViewController {
    fileprivate func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            /// Cho phép edit ảnh hay là không
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        } else {
            let alertWarning = UIAlertController(title: "Error", message: "Divice not have camera", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
                print("Cancel")
            }
            alertWarning.addAction(cancel)
            self.present(alertWarning, animated: true, completion: nil)
        }
    }
    fileprivate func openGallary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.sourceType = .photoLibrary
            /// Cho phép edit ảnh hay là không
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true)
        }
    }
}
extension ProfileViewController {
    func uploadImageToFirebaseStorage() {
        guard let pickedImage = avatarImg.image,
              let imageData = pickedImage.pngData() else {
            return
        }
        showLoading(isShow: true)
        storage.child("user_images/\(Auth.auth().currentUser?.uid ?? "")/user_image.jpg").putData(imageData) { url, error in
            guard error == nil else {
                print("Lỗi: \(error?.localizedDescription ?? "lỗi không xác đinh")")
                return
            }
            //Lấy URL của ảnh từ storage
            self.storage.child("user_images/\(Auth.auth().currentUser?.uid ?? "")/user_image.jpg").downloadURL { url, error in
                guard let downloadURL = url, error == nil else {
                    print("Failed to get image URL")
                    return
                }
                //Lưu URL ảnh vào dữ liệu user
                guard let currentUser = Auth.auth().currentUser?.uid else {return}
                let userRef = self.databaseRef.child("users").child(currentUser).child("avatar")
                userRef.setValue(downloadURL.absoluteString)
                print("Image URL: \(downloadURL.absoluteString)")
            }
        }
        showLoading(isShow: false)

    }
}

