//
//  SelectAvailabilityViewController.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 02/08/21.
//

import UIKit

class SelectAvailabilityViewController: ServiceBaseViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    //MARK: - Interface Builder Outlets
    @IBOutlet weak var firstCollectionView: UICollectionView!
    @IBOutlet weak var secondCollectionView: UICollectionView!
    @IBOutlet weak var monthYearLabel: UILabel!
    
    
    //MARK: - Properties
    fileprivate var dateArrayForAlert:[String] = []
    fileprivate var timeArrayForAlert:[String] = []
    fileprivate var selectedDays:[String] = []
    fileprivate var selectedDate:[String] = []
    var now = Date()
    var arrIndexPath = [IndexPath]()
    var arrValue = [String]()
    var secondCollectionViewArray:[(String, Bool)] = [(String, Bool)]()
    var useDateArray: [String] = []
    var dateArray = [Date]()
    var dayValue : Int = 0 {
        didSet{
            dateArray.append(Calendar.current.date(byAdding: .day, value: dayValue, to: Date()) ?? Date())
        }
    }
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        stepLabel.text = "4/5"
        for i in 1...7 {
            self.dayValue = i
        }
        
       let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"

        
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd E"
        
        for item in dateArray {
            let dd =  dateFormatterGet.string(from: item )
            let date = dateFormatterGet.date(from: dd)
            print(dateFormatterPrint.string(from: date!))
            let stringFormatOfDate = dateFormatterPrint.string(from: date!)
            useDateArray.append(stringFormatOfDate)
            
        }
        dateFormatterGet.dateFormat = "LLLL yyyy"
        let nameofMonth = dateFormatterGet.string(from: now)
       monthYearLabel.text = nameofMonth
        self.applyFinishingTouchesToUIElements()
       
    }
    
    
    //MARK: - Helpers
    private func applyFinishingTouchesToUIElements() {
        navigationItem.title = "Select Availability"
        let nib = UINib(nibName: "FirstCollectionViewCell", bundle: nil)
        firstCollectionView.register(nib, forCellWithReuseIdentifier: "FirstCollectionViewCell")
        let nib2 = UINib(nibName: "SecondCollectionViewCell", bundle: nil)
        secondCollectionView.register(nib2, forCellWithReuseIdentifier: "SecondCollectionViewCell")
        
        secondCollectionViewArray.append(("7:00 am",false))
        secondCollectionViewArray.append(("8:00 am",false))
        secondCollectionViewArray.append(("9:00 am",false))
        secondCollectionViewArray.append(("10:00 am",false))
        secondCollectionViewArray.append(("11:00 am",false))
        secondCollectionViewArray.append(("12:00 pm",false))
        secondCollectionViewArray.append(("1:00 pm",false))
        secondCollectionViewArray.append(("2:00 pm",false))
        secondCollectionViewArray.append(("3:00 pm",false))
        secondCollectionViewArray.append(("4:00 pm",false))
        secondCollectionViewArray.append(("5:00 pm",false))
        secondCollectionViewArray.append(("6:00 pm",false))
        secondCollectionViewArray.append(("7:00 pm",false))
        secondCollectionViewArray.append(("8:00 pm",false))
        secondCollectionViewArray.append(("9:00 pm",false))
        secondCollectionViewArray.append(("10:00 pm",false))
    }
  
    //MARK: - Interface Builder Actions
    @IBAction func nextButtonAction(_ sender: UIButton) {
        if dateArrayForAlert.isEmpty == true {
            showMessage("Select days of avaailability")
        }
        else if timeArrayForAlert.count<2 {
            showMessage("Choose your timimg")
        }
        else {
            if Reachability.isConnectedToNetwork(){
               updateAvaliabilty()
            }else{
                openAlert(title: "Chores for me", message: "Make Sure Your Internet Is Connected", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{_ in
                    
                }])
            }
            
        }
    }
    
    
    func updateAvaliabilty(){
        // let url = "http://3.18.59.239:3000/api/v1/jobs-history"
        let parameters = [ "name":"\(UserStoreSingleton.shared.name ?? "")",
                           "image":"",
                           "availability_provider_timing":arrValue.joined(separator: " to "),
                           "availability_provider_days": selectedDays.joined(separator: ","),
                           "deviceID":"\(UserStoreSingleton.shared.fcmToken ?? "")",
                           "deviceType":1] as [String : Any]
        let url = URL(string: "http://3.18.59.239:3000/api/v1/update-profile")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        //  print("Token is",UserStoreSingleton.shared.Token)
        request.setValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let json =  try JSONDecoder().decode(UpdateUserProfile.self, from: data)
                    print(json)
                    DispatchQueue.main.async {
                        self.navigate(.uploadIDProof)
                    }
                }catch{
                    
                }
            }
        }.resume()
    }
        //MARK: - UICollectionViewDataSource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == firstCollectionView {
            return dateArray.count
        }
        
        else {
            return secondCollectionViewArray.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == firstCollectionView {
            let cell = firstCollectionView.dequeueReusableCell(withReuseIdentifier: "FirstCollectionViewCell", for: indexPath) as! FirstCollectionViewCell
            cell.contentView.layer.borderWidth = 0.5
            cell.contentView.layer.borderColor = UIColor.gray.cgColor
            cell.contentView.layer.masksToBounds = true
            let stringArray = useDateArray[indexPath.row].split(separator: Character(" "))
            cell.label.numberOfLines = 0
            cell.label.textAlignment = .center
            cell.label.font = UIFont.systemFont(ofSize: 12.0)
            cell.label.text = "\(stringArray.first ?? "") \n \(stringArray.last ?? "")"
            return cell
            
        }
        else {
            let cell2 = secondCollectionView.dequeueReusableCell(withReuseIdentifier: "SecondCollectionViewCell", for: indexPath) as! SecondCollectionViewCell
            cell2.contentView.layer.borderWidth = 0.5
            cell2.contentView.layer.borderColor = UIColor.gray.cgColor
            cell2.contentView.layer.masksToBounds = true
            cell2.label.text = secondCollectionViewArray[indexPath.row].0
            if secondCollectionViewArray[indexPath.row].1 == true {
                cell2.mainView.backgroundColor = .white
                cell2.label.textColor = .black
            }
            else {
                cell2.mainView.backgroundColor = .clear
                cell2.label.textColor = .white
            }
            
            return cell2
        }
    }
    
    
    //MARK: - UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == firstCollectionView {
            return CGSize(width: 70, height: 50)
        }
        
        else {
            return CGSize(width: 80, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
}

extension SelectAvailabilityViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == firstCollectionView {
            if let cell = collectionView.cellForItem(at: indexPath) as? FirstCollectionViewCell {
                let day = cell.label.text ?? ""
                if cell.label.textColor == .black {
                    cell.label.textColor = .white
                    cell.mainView.backgroundColor = .clear
                    let indexOf = selectedDays.firstIndex(of: day)
                    if indexOf != nil {
                        selectedDays.remove(at: indexOf!)
                    }
                }
                else {
                    cell.label.textColor = .black
                    cell.mainView.backgroundColor = .white
                    let dateWithoutNextSlashN = day.split(separator: "\n")[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    print("Date is : "+dateWithoutNextSlashN)
                    selectedDays.append(dateWithoutNextSlashN)
                    dateArrayForAlert.append(cell.label.text!)
                }
            }
        }
        if collectionView == secondCollectionView {
            
            if arrIndexPath.count < 2 {
                arrIndexPath.append(indexPath)
                //let valueInFloat = (secondCollectionViewArray[indexPath.item].0 as NSString).floatValue
                // print(valueInFloat)
                arrValue.append(secondCollectionViewArray[indexPath.item].0 as String)
                let cell = collectionView.cellForItem(at: indexPath) as? SecondCollectionViewCell
                
                
                cell?.mainView.backgroundColor = .white
                cell?.label.textColor = .black
                secondCollectionViewArray[indexPath.item].1 = true
                //  print(arrValue)
                // print(arrValue.sorted())
                let date = cell?.label.text ?? ""
                let indexOf = selectedDate.firstIndex(of: date)
                timeArrayForAlert.append((cell?.label.text!)!)
                if indexOf != nil {
                    selectedDate.remove(at: indexOf!)
                }
            }
            else {
                let cell = collectionView.cellForItem(at: indexPath) as? SecondCollectionViewCell
                let date = cell?.label.text ?? ""
                selectedDate.append(date)
                // print(selectedDays)
                //let cell = collectionView.cellForItem(at: arrIndexPath[1]) as! SecondCollectionViewCell
                for i in 0...secondCollectionViewArray.count - 1 {
                    secondCollectionViewArray[i].1 = false
                    collectionView.reloadData()
                }
                arrIndexPath.removeAll()
                arrValue.removeAll()
            }
        }
    }
}
