//
//  DetailsVC.swift
//  FlowerApp


import UIKit
@_exported import SendGrid

class DetailsVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var imgData: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnAddToFav: BlueThemeButton!
    @IBOutlet weak var btnOrder: BlueThemeButton!
    
    //MARK:- Class Variables
    var data: BouquetModel!
    var isFav : Bool = true
    
    
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
    @IBAction func btnClick(_ sender: UIButton) {
        if sender == btnOrder {
//            if let vc = UIStoryboard.main.instantiateViewController(withClass: SuccessVC.self) {
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
            if !GFunction.user.email.isEmpty {
                self.createOrder(data: data, user: GFunction.user, date: self.UTCToDate(date: Date()))
            }
        }else if sender == btnAddToFav {
            self.isFav = false
            if !GFunction.user.email.isEmpty {
                self.checkAddToFav(data: self.data, email: GFunction.user.email)
            }
        }
    }
    
    //MARK:- ViewLifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgData.layer.cornerRadius = 15.0
        
        if data != nil {
            self.lblName.text = data.name.description
            self.lblDescription.text = data.description.description
            self.lblPrice.text = data.price.description
            self.imgData.setImgWebUrl(url: data.image.description, isIndicator: true)
        }
        // Do any additional setup after loading the view.
    }
    
    
    func addToFav(data: BouquetModel,email:String){
        var ref : DocumentReference? = nil
        ref = AppDelegate.shared.db.collection(fFavourite).addDocument(data:
            [
                fName: data.name,
                fDescription : data.description,
                fPrice: data.price,
                fEmail: email,
                docID: data.docID,
                fImage: data.image
            ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                Alert.shared.showAlert(message: "Cake has been added into Favourite!!!") { (true) in
                    UIApplication.shared.setTab()
                }
            }
        }
    }
    
    func checkAddToFav(data: BouquetModel, email:String) {
        _ = AppDelegate.shared.db.collection(fFavourite).whereField(fEmail, isEqualTo: email).whereField(docID, isEqualTo: data.docID).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            if snapshot.documents.count == 0 {
                self.isFav = true
                self.addToFav(data: data, email: email)
            }else{
                if !self.isFav {
                    Alert.shared.showAlert(message: "Cake has been already existing into Favourite!!!", completion: nil)
                }
                
            }
        }
    }
    
    func createOrder(data:BouquetModel, user:UserModel,date:String){
        var ref : DocumentReference? = nil
        ref = AppDelegate.shared.db.collection(fOrder).addDocument(data:
            [
                fName: data.name.description,
                fEmail : user.email.description,
                fOrderDate: date,
                fPrice: data.price.description,
                fDescription: data.description.description,
                fImage: data.image.description,
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
