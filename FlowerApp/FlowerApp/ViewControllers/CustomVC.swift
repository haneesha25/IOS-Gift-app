//
//  CustomVC.swift
//  FlowerApp


import UIKit

class CustomVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var tblList: SelfSizedTableView!
    @IBOutlet weak var btnIsCover: UIButton!
    @IBOutlet weak var btnISNotes: UIButton!
    @IBOutlet weak var btnPlaceOrder: BlueThemeButton!
    @IBOutlet weak var txtNotes: ThemeTextField!
    @IBOutlet weak var vwNotes: UIView!
    
    //MARK:- Class Variables
    var arrData = [FlowerModel]()
    var count = 0
    
    //MARK:- Custom Methods
    func UTCToDate(date:Date) -> String {
        let formatter = DateFormatter()
       
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: date) // string purpose I add here
        let yourDate = formatter.date(from: myString)  // convert your string to date
        formatter.dateFormat = "dd, MMM, yyyy"  //then again set the date format whhich type of output you need
        return formatter.string(from: yourDate!) // again convert your date to string
    }
    
    
    //MARK:- Action Methods
    @IBAction func btnIsSelectClick(_ sender:  UIButton){
        if sender == self.btnIsCover {
            self.btnIsCover.isSelected.toggle()
        }else if sender == self.btnISNotes {
            self.btnISNotes.isSelected.toggle()
            self.vwNotes.isHidden = !self.btnISNotes.isSelected
        }else if sender == btnPlaceOrder {
            if self.count > 0 {
                var finalAmount = (self.count * 50)
                finalAmount = self.btnIsCover.isSelected ? (finalAmount + 50) : finalAmount
                finalAmount = self.btnISNotes.isSelected ? (finalAmount + 10) : finalAmount
                    
                if !GFunction.user.email.isEmpty {
                    self.createOrder(amount: finalAmount.description, user: GFunction.user, date: self.UTCToDate(date: Date()))
                }
            }else{
                Alert.shared.showAlert(message: "Please select atleast one flower", completion: nil)
            }
            
        }
    }
    
    //MARK:- ViewLifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblList.delegate = self
        self.tblList.dataSource = self
        self.vwNotes.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getData()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = false
    }

}


extension CustomVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.configCell(data: self.arrData[indexPath.row])
        cell.btnSelect.addAction(for: .touchUpInside) {
            self.arrData[indexPath.row].isSelected.toggle()
            cell.btnSelect.isSelected.toggle()
            
            self.count = self.arrData.filter({$0.isSelected == true}).count
            
            self.lblCount.text = "You have selected \(self.count) Flowers."
        }
        return cell
    }
    
    func getData() {
        _ = AppDelegate.shared.db.collection(fFlower).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            self.arrData.removeAll()
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if let name: String = data1[fName] as? String,let imagePath: String = data1[fImage] as? String {
                        print("Data Count : \(self.arrData.count)")
                        self.arrData.append(FlowerModel(docID: data.documentID, name: name, image: imagePath))
                    }
                }
                self.tblList.delegate = self
                self.tblList.dataSource = self
                self.tblList.reloadData()
                self.lblCount.text = "You have selected 0 Flowers."
            }else{
                Alert.shared.showAlert(message: "No Data Found !!!", completion: nil)
            }
        }
    }
    
    func createOrder(amount:String, user:UserModel,date:String){
        var ref : DocumentReference? = nil
        ref = AppDelegate.shared.db.collection(fOrder).addDocument(data:
            [
                fName: "Mixed Flower Bouquet",
                fEmail : user.email.description,
                fOrderDate: date,
                fPrice: amount.description,
                fDescription: "This is custom made bouquet",
                fImage: "https://firebasestorage.googleapis.com/v0/b/flowerapp-87082.appspot.com/o/Bouquets%2Fcolourful_gerberas_bunch.jpg?alt=media&token=3ed5cc41-e433-416f-b354-9ba848e2359c",
                fOrderType: "Custom Made Order"
            ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                let fullname = "\(user.fName) \(user.lName)"
                self.emailSend(fullName: fullname, email: user.email)
            }
        }
    }
    
    func emailSend(fullName:String, email:String){
        self.sendEmail(fullName: fullName, email: email){ [unowned self] (result) in
            DispatchQueue.main.async {
                switch result{
                case .success(_):
                                    Alert.shared.showAlert(message: "Your Order has been placed successfully !!!") { (true) in
                                        if let vc = UIStoryboard.main.instantiateViewController(withClass: SuccessVC.self) {
                                            self.navigationController?.pushViewController(vc, animated: true)
                                        }
                                    }
                case .failure(_):
                    Alert.shared.showAlert(message: "Error", completion: nil)
                }
            }
            
        }
    }
    
    func sendEmail(fullName:String, email:String, completion: @escaping (Result<Void,Error>) -> Void) {
        let apikey = "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"
        let name = fullName
        let email = email
        
        let devemail = "2095405@cegepgim.ca"
        
        let data : [String:String] = [
            "name" : name,
            "user" : email
        ]
        
        
        let personalization = TemplatedPersonalization(dynamicTemplateData: data, recipients: email)
        let session = Session()
        session.authentication = Authentication.apiKey(apikey)
        
        let from = Address(email: devemail, name: name)
         let template = Email(personalizations: [personalization], from: from, templateID: "d-82b56f27edcf40428cfe7223504f5fe1", subject: "Your Order has been placed!!!")
        
        do {
            try session.send(request: template, completionHandler: { (result) in
                switch result {
                case .success(let response):
                    print("Response : \(response)")
                    completion(.success(()))
                    
                case .failure(let error):
                    print("Error : \(error)")
                    completion(.failure(error))
                }
            })
        }catch(let error){
            print("ERROR: ")
            completion(.failure(error))
        }
    }
}


class CustomCell: UITableViewCell {
    //MARK:- Outlets
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var imgData: UIImageView!
    @IBOutlet weak var vwMain: UIView!
    
    //MARK:- Class Variables
    
    //MARK:- Custom Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vwMain.layer.cornerRadius = 5.0
        self.vwMain.shadow()
        self.vwMain.backgroundColor = .white
    }
    
    func configCell(data: FlowerModel){
        self.lblName.text = data.name.description
        self.imgData.setImgWebUrl(url: data.image.description, isIndicator: true)
    }
}
