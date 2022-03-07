//
//  EditProfileViewController.swift
//  Chores for me
//
//  Created by Amalendu Kar on 24/04/21.
//

import UIKit
import Alamofire
import SDWebImage
import SwiftyJSON
import Designable

class EditProfileViewController: BaseViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    //MARK: - Interface Builder Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var phoneNumberTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var addYourCertificateButton: DesignableButton!{
        didSet{
            addYourCertificateButton.tag = 1
        }
    }
    @IBOutlet var changeImageBtn : UIButton!{
        didSet{
            changeImageBtn.tag = 2
        }
    }
    @IBOutlet var certificateImage: UIImageView!


    //MARK: - Properties
    static var editName: String?
    var imagePicker = UIImagePickerController()
    var imagePicker1 = UIImagePickerController()
    var photoURL : URL!
    var selctedIndex = 0
    var certificateResponse : String?
    var imageResponse :String?
    var isBackSelected = false
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationItems()
        addYourCertificateButton.addSpaceBetweenImageAndTitle(spacing: 5.0)
        self.navigationController?.navigationBar.tintColor = .white
       // emailTextField.text = UserStoreSingleton.shared.name
        navigationController?.darkNavigationBar()
        navigationItem.rightBarButtonItem?.tintColor = .white
        self.emailTextField.text =   UserStoreSingleton.shared.email
        if UserStoreSingleton.shared.phoneNumer == nil {
            self.phoneNumberTextField.text = UserStoreSingleton.shared.socailphoneNumber
        }
        else {
            self.phoneNumberTextField.text = UserStoreSingleton.shared.phoneNumer
        }
        nameTextField.text = UserStoreSingleton.shared.name
        EditProfileViewController.editName = nameTextField.text
        lastNameTextField.text = UserStoreSingleton.shared.lastname
        nameTextField.delegate = self
        tabBarController?.tabBar.isHidden = true
        let profileUrl = URL(string: UserStoreSingleton.shared.profileImage ?? "")
        imageView?.sd_setImage(with: profileUrl) { (image, error, cache, urls) in
            if (error != nil) {
                self.imageView.image = UIImage(named: "user.profile.icon")
            } else {
                self.imageView.image = image
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        
    }
    func addNavigationItems (){
        let sec = UIBarButtonItem(title: "Save", style: .done, target: self, action:  #selector(rightBarButton))
        sec.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: AppFont.Poppins.semiBold.fontName, size: 22.0)!], for: .normal)
        navigationItem.rightBarButtonItem = sec
        self.navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.isTranslucent = false
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "Profile"
        titleLabel.textColor = UIColor.white
        titleLabel.font =  UIFont(name: AppFont.Poppins.semiBold.fontName, size: 22.0)
        navigationItem.titleView = titleLabel
    }

    
    @IBAction func btn_ChangePassword(_ sender: Any) {
        navigate(.resetPassword)
        navigationController?.navigationBar.isHidden = true
    }

    @IBAction func AddYourCertificatesButtonAction(_ sender: UIButton) {
        isBackSelected = true
        addYourCertificateButton.isSelected = true
        changeImageBtn.isSelected = false
        imagePicker1.delegate = self
       // imagePicker1.sourceType = .savedPhotosAlbum
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera(imagePicker: self.imagePicker1)
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                                        self.imagePicker1.sourceType = UIImagePickerController.SourceType.photoLibrary
                                        self.imagePicker1.allowsEditing = true
                                        self.present(self.imagePicker1, animated: true, completion: nil)        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        self.present(alert, animated: true, completion: nil)
    }

    
    @IBAction func editProfileButtonAction(_ sender: UIButton) {
        isBackSelected = false
        addYourCertificateButton.isSelected = false
        changeImageBtn.isSelected = true
        imagePicker.delegate =  self
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera(imagePicker: self.imagePicker)
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera(imagePicker:UIImagePickerController)
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary(imagePicker:UIImagePickerController)
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if changeImageBtn.isSelected == true  {
            print("imageView")
            let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                    imageView.image = pickedImage
            updateProfilePicture(uploadImage: imageView.image!)
        } else{
            if !changeImageBtn.isSelected == true {
                print("certificateImage")
                let pickedImage2 = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                    certificateImage.image = pickedImage2
                updateProfilePicture(uploadImage: certificateImage.image!)
            }
        }
        dismiss(animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func updateProfilePicture(uploadImage :UIImage){
        showActivity()
        let url = "http://3.18.59.239:3000/api/v1/upload"
        let image = uploadImage
        let imgData = image.jpegData(compressionQuality: 0.2)!
        
        let parameters = ["":"" ] //Optional for extra parameter
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "image",fileName: "file.jpg", mimeType: "image/jpg")
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },
        to:url)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                })
                upload.responseJSON { response in
                    debugPrint(response.result.value as Any)
                    if let data = response.data {
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data , options: .allowFragments) as? [String: Any] {
                                print(json)
                                if let data = json["data"] as? String {
                                    print(data)
                                   // self.imageResponse = data as? String
                                    if !self.isBackSelected {
                                        self.imageResponse = data
                                    }
                                    else{
                                        self.certificateResponse = data
                                    }
                                }
                                self.hideActivity()
                            }
                        } catch let error as NSError {
                            print("Failed to load: \(error.localizedDescription)")
                            self.hideActivity()
                            self.showMessage("Error Occured")
                        }
                    }
                }
                
            case .failure(let encodingError):
                debugPrint(encodingError)
            }
        }
    }
  
    @objc private func rightBarButton(_ sender: UIBarButtonItem) {
        EditProfileViewController.editName = self.nameTextField.text
        UserStoreSingleton.shared.name = EditProfileViewController.editName
        if Reachability.isConnectedToNetwork(){
            UpdateProfile()
        }else{
            openAlert(title: "Chores for me", message: "Make Sure Your Internet Is Connected", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{_ in
                
            }])
        }
    }
    func UpdateProfile(){
        let str = nameTextField.text
        let spacetrim = str?.trimmingCharacters(in: .whitespacesAndNewlines)
        let spaceTrim = lastNameTextField.text
        let space = spaceTrim?.trimmingCharacters(in: .whitespacesAndNewlines)
        showActivity()
        let parameters =  ["first_name": spacetrim ?? "" ,"last_name": space ?? "","email":emailTextField.text ?? "","image": imageResponse ?? "" ] as [String : Any]
        guard let gitUrl = URL(string:"http://3.18.59.239:3000/api/v1/update-profile") else { return }
        let request = NSMutableURLRequest(url: gitUrl)
        let session = URLSession.shared
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        session.dataTask(with: request as URLRequest) { data, response, error in
            guard let data = data else { return }
            self.hideActivity()
            do {
                let gitData = try JSONDecoder().decode(UpdateUserProfile.self, from: data)
                DispatchQueue.main.async {
                    if gitData.status == 200{
                        self.showMessage(gitData.message ?? "")
                        DispatchQueue.main.asyncAfter(deadline: .now()+1.0){
                            RootRouter().loadMainHomeStructure()
                        }
                    } else{
                        self.showMessage(gitData.message ?? "")
                    }
                }
            } catch let err {
                print("Err", err)
                self.hideActivity()
                self.showMessage("Error Occured")
            }
        }.resume()
    }
    }

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == nameTextField {
            textField.text = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
        }
    }
}

