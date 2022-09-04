//
//  CancelRequestViewController.swift
//  Chores for me
//
//  Created by Amalendu Kar on 23/04/21.
//

import UIKit


struct CancelReason {
    var reason : String?
    var isSelected : Bool?
}

class CancelRequestViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var cancelRequestArray = [CancelReason]()
    var jobId = Int()
    var userId = Int()
    var jobID_userID =  [Int]()
    var selectedIndex = -1
    var screenType = "cancelbyProvider"
    var dicData : GetReqOnProviderSideModelData!

    
    // MARK: - Lifecycle
    
    // Custom initializers go here
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelRequestArray.append(CancelReason(reason: "I've changed my mind", isSelected: false))
        cancelRequestArray.append(CancelReason(reason: "I've got problems with my card", isSelected: false))
        cancelRequestArray.append(CancelReason(reason: "I recieved too many requests", isSelected: false))
        cancelRequestArray.append(CancelReason(reason: "I've got problems with my mobile", isSelected: false))
        cancelRequestArray.append(CancelReason(reason: "Other", isSelected: false))
        navigationItem.title = "Cancel Request"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "CancelRequestTableViewCell", bundle: nil), forCellReuseIdentifier: "CancelRequestTableViewCell")
        
        
    }
    
    @IBAction func btn_SubmitCanelRequest(_ sender: UIButton) {
        
        //navigate this screen back to jobDetail screen with selected reason and screenType declered at top
       // navigate(.jobStatus(jobId: jobId))
        
        if Reachability.isConnectedToNetwork(){
        cancelJobAPI()
        }else{
            openAlert(title: "Chores for me", message: "Make Sure Your Internet Is Connected", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{_ in
            }])
        }
    }
    // MARK: - Layout
    
    // MARK: - User Interaction
    
    
    // MARK: - Additional Helpers
    func cancelJobAPI(){
        if selectedIndex == -1 {
        showMessage("Please select one reason.")
            return
        }
        let Url = String(format: "http://3.18.59.239:3000/api/v1//canceljob-By-Provider")
        guard let serviceUrl = URL(string: Url) else { return }
        let parameterDictionary =  ["jobId":jobId,"cancelReason":cancelRequestArray[selectedIndex].reason!,"providerId":UserStoreSingleton.shared.userID ?? 0,"UserId": userId] as [String : Any]
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
                    if json.status == 200 {
                        self.showMessage(json.message ?? "")
                        DispatchQueue.main.asyncAfter(deadline: .now()+1.0){
                      RootRouter().loadMainHomeStructure()
                        }
                    } else{
                        self.showMessage(json.message ?? "")
                    }
                }
            } catch {
                print(error)
                
            }
        }.resume()
    }
}

// MARK: - UITableViewDelegate

extension CancelRequestViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource

extension CancelRequestViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cancelRequestArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CancelRequestTableViewCell") as? CancelRequestTableViewCell else {
            return UITableViewCell()
        }
        cell.requestsLabelText.text = cancelRequestArray[indexPath.item].reason
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CancelRequestTableViewCell else {
            return
        }
        
        if selectedIndex != indexPath.row {
            cell.checkButton.isSelected.toggle()
            selectedIndex = -1
            if cell.checkButton.isSelected {
                selectedIndex = indexPath.row
            }
        }
        //cancelRequestArray[indexPath.item].isSelected = cell.checkButton.isSelected
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CancelRequestTableViewCell else {
            return
        }
        cell.checkButton.isSelected = false
    }
}
