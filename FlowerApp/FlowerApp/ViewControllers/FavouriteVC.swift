//
//  FavouriteVC.swift
//  FlowerApp


import UIKit

class FavouriteVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var tblList: SelfSizedTableView!
    
    //MARK:- Class Variables
    var arrData = [BouquetModel]()
    //MARK:- Custom Methods
    
    //MARK:- Action Methods
    
    //MARK:- ViewLifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblList.delegate = self
        self.tblList.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if !GFunction.user.email.isEmpty {
            self.getData(email: GFunction.user.email)
        }
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = false
    }

}


extension FavouriteVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteCell", for: indexPath) as! FavouriteCell
        cell.configCell(data: self.arrData[indexPath.row])
        cell.btnRemove.addAction(for: .touchUpInside) {
            Alert.shared.showAlert("", actionOkTitle: "Remove", actionCancelTitle: "Cancel", message: "Are you sure you want to remove this bouquet?") { (true) in

                self.removeFromFav(data: self.arrData[indexPath.row], email: GFunction.user.email)
                
            }
        }
        
        return cell
    }
    
    func getData(email:String) {
        _ = AppDelegate.shared.db.collection(fFavourite).whereField(fEmail, isEqualTo: email).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            self.arrData.removeAll()
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if let name: String = data1[fName] as? String, let description: String = data1[fDescription] as? String,let imagePath: String = data1[fImage] as? String, let price: String = data1[fPrice] as? String {
                        print("Data Count : \(self.arrData.count)")
                        self.arrData.append(BouquetModel(docID: data.documentID, name: name, descripiton: description, price: price, image: imagePath))
                    }
                }
                self.tblList.delegate = self
                self.tblList.dataSource = self
                self.tblList.reloadData()
            }else{
                Alert.shared.showAlert(message: "No Data Found !!!", completion: nil)
            }
        }
    }
    
    func removeFromFav(data: BouquetModel,email:String){
        let ref = AppDelegate.shared.db.collection(fFavourite).document(data.docID)
        ref.delete(){ err in
            if let err = err {
                print("Error updating document: \(err)")
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Document successfully deleted")
                UIApplication.shared.setTab()
            }
        }
    }
}


class FavouriteCell: UITableViewCell {
    //MARK:- Outlets
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgData: UIImageView!
    @IBOutlet weak var btnRemove: UIButton!
    
    
    //MARK:- Class Variables
    
    //MARK:- Custom Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vwMain.backgroundColor = .white
        self.vwMain.shadow()
        self.vwMain.layer.cornerRadius = 10.0
    }
    
    func configCell(data: BouquetModel){
        self.lblName.text = data.name.description
        self.lblPrice.text = data.price.description
        self.imgData.setImgWebUrl(url: data.image, isIndicator: true)
    }
}
