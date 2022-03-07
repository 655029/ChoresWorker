//
//  UploadIDProofViewController.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 20/04/21.
//

import UIKit
import DropDown
import Alamofire
import SwiftyJSON

class UploadIDProofViewController: ServiceBaseViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    
    // MARK: - Outlets
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var descriptionTextFeild: UITextView!
    @IBOutlet weak var experinceTextFeild: UITextField!
    @IBOutlet var idProofTextField: UITextField!
    @IBOutlet var btn_frontPicture: UIButton!{
        didSet{
            self.btn_frontPicture.tag = 1
        }
    }
    @IBOutlet var btn_backPicture: VerticalButton!{
        didSet{
            self.btn_backPicture.tag = 2
        }
    }
    // MARK: - Properties
    var imagePicker = UIImagePickerController()
    var selectedString: String?
    let dropDown = DropDown()
    var photoURL : URL!
    var imageForm: Data?
    var imageResponse = [String]()
    var isBackSelected = false
   var selectedIndex = 0
    var backImageResponse: String?
    
    // MARK: - Lifecycle
    
    // Custom initializers go here
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Upload your Document"
        let textAttributes = [NSAttributedString.Key.foregroundColor:AppColor.primaryLabelColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        stepLabel.text = "5/5"
        self.imagePicker.delegate = self
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        dropDown.anchorView = view
        dropDown.dataSource = ["0-6 months","1-2 year","2-3 year","4-5 year","5-6 year","6-7 year","7-8 year","8-9 year","9-10 year","10+ year"]
        dropDown.direction = .any
        dropDown.width = 300
        descriptionTextFeild.delegate = self
        descriptionTextFeild.text  = "Add Description"
        descriptionTextFeild.textColor = UIColor.lightGray
    }



    //MARK: - TextView Delegate

    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextFeild.textColor == UIColor.lightGray {
            descriptionTextFeild.text = nil
            descriptionTextFeild.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextFeild.text.isEmpty {
            descriptionTextFeild.text = "Add Description"
            descriptionTextFeild.textColor = UIColor.lightGray
        }
    }
    // MARK: - Layout

    // MARK: - User Interaction
    @IBAction func frontCameraButtonAction(_ sender: UIButton) {
        self.selectedIndex = sender.tag
        isBackSelected = false
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
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
    
    @IBAction func backCameraButtonAction(_ sender: UIButton) {
        self.selectedIndex = sender.tag
        isBackSelected = true
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
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
    
    @IBAction func experienceDropDownButtonAction(_ sender: UIButton) {
        dropDown.show()
        dropDown.reloadAllComponents()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            experinceTextFeild.text = item
        }
    }
    
    @IBAction func submitButtonAction(_ sender: Any) {
        if experinceTextFeild.text?.isEmpty == true || idProofTextField.text?.isEmpty == true || descriptionTextFeild.text?.isEmpty == true || experinceTextFeild.text?.isEmpty == true || frontImageView.image == nil || backImageView.image == nil {
            openAlert(title: "Chores for me", message: "All Fields are Mandatory ", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{ _ in
            }])
        } else{
            uploadPluckImage()
        }
    }
    
    // MARK: - Additional Helpers
    func openCamera()
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
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if(picker.sourceType == .photoLibrary)
        {
            if let imgUrl = info[UIImagePickerController.InfoKey.referenceURL] as? URL
            {
                let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                
                //print(pickedImage as Any)
                // imageForm = pickedImage
                let imgName = imgUrl.lastPathComponent
                let documentDirectory = NSTemporaryDirectory()
                let localPath = documentDirectory.appending(imgName)
                let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
                let data = image.jpegData(compressionQuality: 0.3)! as NSData
                data.write(toFile: localPath, atomically: true)
                photoURL = URL.init(fileURLWithPath: localPath)
                // print(photoURL!)
                picker.dismiss(animated: true, completion: nil)

                switch selectedIndex {
                case 1:
                    frontImageView.image = pickedImage
                    idProofImage(image: frontImageView.image!)
                case 2:
                    backImageView.image = pickedImage
                    idProofImage(image: backImageView.image!)
                default:
                    break
                }
         }
        }
        else
        {
            let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            //frontImageView.image = pickedImage
           // print(pickedImage as Any)
            let imgName = UUID().uuidString
            let documentDirectory = NSTemporaryDirectory()
            let localPath = documentDirectory.appending(imgName)
            let data = pickedImage!.jpegData(compressionQuality: 0.3)! as NSData
            data.write(toFile: localPath, atomically: true)
            photoURL = URL.init(fileURLWithPath: localPath)
            //print(photoURL!)
            switch selectedIndex {
            case 1:
                frontImageView.image = pickedImage
                idProofImage(image: frontImageView.image!)
            case 2:
                backImageView.image = pickedImage
                idProofImage(image: backImageView.image!)
            default:
                break
            }
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
}
extension UploadIDProofViewController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
    }
    func  uploadPluckImage(){
         showActivity()
        let parameters = ["provider_ID":"\(UserStoreSingleton.shared.userID ?? 0)","exp_desciption":descriptionTextFeild.text ?? "","proof_ID":idProofTextField.text ?? "","work_exp": experinceTextFeild.text ?? "","proof_image1":"\(imageResponse[0])","proof_image2": backImageResponse!] as [String : Any]
        let url = URL(string: "http://3.18.59.239:3000/api/v1/add-doc-provider")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let json =  try JSONDecoder().decode(ProvideDocumentsModel.self, from: data)
                    DispatchQueue.main.async {
                        self.hideActivity()
                        
                        self.showMessage(json.message ?? "")
                        if json.status == 200 {
                            DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                                RootRouter().loadMainHomeStructure()
                            }
                        }else{
                            self.showMessage(json.message ?? "")
                        }
                    }
                }catch{
                    self.hideActivity()
                }
            }
        }.resume()
    }

    func idProofImage( image: UIImage){
        showActivity()
        let image = image
        let imgData = image.jpegData(compressionQuality: 0.2)!
        let headers: HTTPHeaders = [
            "Authorization": "\(UserStoreSingleton.shared.Token ?? "")"]
        let parameters = ["":""]
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "proof_image1",fileName: "file.jpg", mimeType: "image/jpg")
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            } //Optional for extra parameters
        },
        to:"http://3.18.59.239:3000/api/v1/upload",headers: headers)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    //print("Upload Progress: \(progress.fractionCompleted)")
                })
                upload.responseJSON { response in
                    //print(response.result.value ?? "")
                    if let data = response.data {
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                               // print(json)
                                if let data = json["data"] as? String {
                                   // print(data)
                                    if !self.isBackSelected {
                                        self.imageResponse.insert(data, at: 0)
                                        self.btn_frontPicture.isHidden = true
                                    }
                                    else{
                                        self.backImageResponse = data
                                        //self.imageResponse.insert(data, at: 1)
                                        self.btn_backPicture.isHidden = true
                                    }
                                }
                                self.hideActivity()
                            }
                            
                        } catch let error as NSError {
                            self.hideActivity()
                            print("Failed to load: \(error.localizedDescription)")
                        }
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    
}




