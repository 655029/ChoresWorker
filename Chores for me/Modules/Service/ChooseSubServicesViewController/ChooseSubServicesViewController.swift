//
//  ChooseSubServicesViewController.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 18/04/21.
//

import UIKit
import SwiftyJSON
import SDWebImage

class ChooseSubServicesViewController: ServiceBaseViewController {
    
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectionButton: UIButton!
    @IBOutlet weak var topLabel: UILabel!
    
    
    // MARK: - Properties
    var selectedIndexPaths = [String]()
    override var navigationController: BaseNavigationController? {
        return super.navigationController
    }
    
    var count = 0
    var labelText:[String] = []
    var service: Service!
    var categoryId: Int?
    var arrData = [SubCatgeoryModelData]()
    var subCategoryArray = [String]()
    var subCategoryIdArray = [String]()
    var priceArry = [String]()
    // MARK: - Lifecycle
    
    // Custom initializers go here
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title =  "Select \(UserStoreSingleton.shared.categeoryName ?? "")"
        //    topLabel.text = service?.title
        let attributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size: 6)!]
        UINavigationBar.appearance().titleTextAttributes = attributes
        
        stepLabel.text = "3/5"
        applyDesigns()
        labelText.append("Lawn Mowing")
        labelText.append("Weed Removal")
        labelText.append("Planting")
        labelText.append("Guter Service")
        labelText.append("other")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        navigationItem.title =  "Select \(UserStoreSingleton.shared.categeoryName ?? "")"
        let attributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size: 6)!]
        UINavigationBar.appearance().titleTextAttributes = attributes
        subCategoryArray.removeAll()
        subCategoryIdArray.removeAll()
        if Reachability.isConnectedToNetwork(){
            SubCatgeoryApi()
        }else{
            openAlert(title: "Chores for me", message: "Make Sure Your Internet Is Connected", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{_ in
                
            }])
        }
        
    }
    
    // MARK: - Layout
    
    private func applyDesigns() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "ChooseSubServicesTableViewCell", bundle: nil), forCellReuseIdentifier: "ChooseSubServicesTableViewCell")
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .zero
        tableView.keyboardDismissMode = .onDrag
    }
    
    func SubCatgeoryApi() {
        showActivity()
        // self.arrData.removeAll()
        let Url = String(format: "http://3.18.59.239:3000/api/v1/sub-categories-list")
        guard let serviceUrl = URL(string: Url) else { return }
        let parameterDictionary =  ["categoryId":categoryId ?? 0] as [String: Any]
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
            return
        }
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {return}
            do {
                let json =  try JSONDecoder().decode(SubCatgeoryModel.self, from: data)
                DispatchQueue.main.async{
                    self.arrData.removeAll()
                    self.hideActivity()
                    self.arrData = json.data ?? []
                    self.tableView.reloadData()
                }
            } catch {
                self.hideActivity()
                print(error)
            }
        }.resume()
    }
    
    // MARK: - User Interaction
    
    @IBAction func nextButtonAction(_ sender: Any) {
        //        subCategoryArray.removeAll()
        //        subCategoryIdArray.removeAll()
        //        priceArry.removeAll()
        if subCategoryArray.isEmpty == true {
            showMessage("Please Select SubCategory")
        } else{
            addUpdateProviderCategories()
            
            
        }
        //        var isSelected = false
        //        for (j, i) in arrData.enumerated() {
        //            //isSelected = false
        //            let index = IndexPath(row: j, section: 0)
        //            guard let cell = tableView.cellForRow(at: index) as? ChooseSubServicesTableViewCell else {
        //                return // or fatalError() or whatever
        //            }
        //
        //            if (i.checked ?? false) {
        //                isSelected = true
        //                print("Selected Items == ",i)
        
        //               // priceArry.append(i.price)
        ////
        ////                if cell.ammountTextField.text ?? "0" == "0" || cell.ammountTextField.text ?? "0" == "" {
        ////                    showMessage("Fill all the field")
        ////                    return
        ////                }
        //                arrData[j].price = cell.ammountTextField.text ?? "0"
        //                priceArry.append(arrData[j].price ?? "")
        //
        //            }
        //
        //        }
        //        if !isSelected {
        //            showMessage("Please Select SubCategory")
        //            return
        //        }
        //        if Reachability.isConnectedToNetwork(){
        //            addUpdateProviderCategories()
        //
        //        }else{
        //            openAlert(title: "Chores for me", message: "Make Sure Your Internet Is Connected", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{_ in
        //
        //            }])
        //        }
        
    }
    
    // MARK: - Additional Helpers
    func addUpdateProviderCategories(){
        let parameters = ["providerId": UserStoreSingleton.shared.userID ?? "",
                          "categoryId": UserStoreSingleton.shared.categeoryID ?? "",
                          "categoryName": UserStoreSingleton.shared.categeoryName ?? "",
                          "subcategoryId": subCategoryIdArray.joined(separator: ","),
                          "subcategoryName": subCategoryArray.joined(separator: ",")] as [String : Any]
        //\(priceArry.joined(separator: ","))
        let url = URL(string: "http://3.18.59.239:3000/api/v1/add-update-provider_categories")
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
                    let status =  try JSONDecoder().decode(UpdateProviderCatgeoryModel.self, from: data)
                    self.showMessage(status.message ?? "")
                    if status.status == 200 {
                        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                            self.navigate(.selectAvailability)
                        }
                    }
                }catch{
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    
    func addSubCatgeorySelection(indexPath:Int){
        let subcatgeory:Int = arrData[indexPath].subcategoryId!
        subCategoryIdArray .append(String(subcatgeory))
        print("selected List =====\(subCategoryIdArray)")
        subCategoryArray.append(arrData[indexPath].subcategoryName ?? "")
        print("selected List =====\(subCategoryArray)")
    }
    func  removeAddSubCatgeorySelection(indexPath:Int){
        if let index = subCategoryArray.firstIndex(of: arrData[indexPath].subcategoryName!) {
            subCategoryArray.remove(at: index)
            print("subCategoryArray New List: \(subCategoryArray)")
            let rem:Int = arrData[indexPath].subcategoryId!
            if let removeId = subCategoryIdArray.firstIndex(of: String(rem)) {
                subCategoryIdArray.remove(at: removeId)
                print("subCategoryArray New List: \(subCategoryIdArray)")
            }
        }
    }
}
// MARK: - UITableViewDelegate

extension ChooseSubServicesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ChooseSubServicesTableViewCell
       //  arrData[indexPath.row].checked = cell.isSelectedButton.isSelected
        cell.isSelectedButton.isSelected.toggle()
        if cell.isSelectedButton.isSelected == true{
            addSubCatgeorySelection(indexPath: indexPath.row)
        } else {
            removeAddSubCatgeorySelection(indexPath: indexPath.row)
                }
            }
        }
    
// MARK: - UITableViewDataSource

extension ChooseSubServicesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseSubServicesTableViewCell") as? ChooseSubServicesTableViewCell else {
            return UITableViewCell()
        }
        cell.isSelectedButton.tag = indexPath.row
        cell.isSelectedButton.isSelected = false
        cell.ammountTextField.tag = indexPath.row
        cell.ammountTextField.delegate = self
        cell.label.text = arrData[indexPath.row].subcategoryName
        let url = URL(string: arrData[indexPath.row].subcategoryImage ?? "")
        cell.serviceImage.sd_setImage(with: url, placeholderImage:UIImage(contentsOfFile:"outdoor_home_service.png"))
        cell.isSelectedButton.addTarget(self, action: #selector(isSelectedToggl(_:)), for: .touchUpInside)
        cell.increaseButton.addTarget(self, action: #selector(didTappedOnIncrementButton(_:)), for: .touchUpInside)
        cell.decreaseButton.addTarget(self, action: #selector(didTappedOnDecrementButton(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func isSelectedToggl(_ Sender: UIButton) {
//                print(Sender.tag
        Sender.isSelected.toggle()
        if Sender.isSelected == true{
            addSubCatgeorySelection(indexPath: Sender.tag)
        } else{
            removeAddSubCatgeorySelection(indexPath: Sender.tag)
        }
    }
    
    @objc func didTappedOnIncrementButton(_ sender: UIButton) {
    }
    
    @objc func didTappedOnDecrementButton(_ sender: UIButton) {
        
    }///arzooooo
}

extension ChooseSubServicesViewController : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let cell = textField.superview?.superview?.superview as? ChooseSubServicesTableViewCell else {
            return // or fatalError() or whatever
        }
        let indexPath = tableView.indexPath(for: cell)
        arrData[indexPath!.row].price = textField.text ?? "0"
    }
}
//if arrData[j].price != "" && arrData[j].checked == true{
//    if Reachability.isConnectedToNetwork(){
//        addUpdateProviderCategories()
//        navigate(.selectAvailability)
//
//    }else{
//        openAlert(title: "Chores for me", message: "Make Sure Your Internet Is Connected", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{_ in
//
//        }])
//
//    }
//
//}else if arrData[j].price == "" && arrData[j].checked == false{
//    showMessage("Please Select Catgeory")
//}
//else{
//    showMessage("Please Select price")
//    debugPrint("Not Allow")
//}
//
//}
