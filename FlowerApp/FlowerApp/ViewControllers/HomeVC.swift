
//  HomeVC.swift
//  FlowerApp

import UIKit

class HomeVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var tblList: SelfSizedTableView!
    
    //MARK:- Class Variables
    var arrData = [BouquetModel]()
    
    //MARK:- ViewLifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.setUpData()
        self.tblList.delegate = self
        self.tblList.dataSource = self
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


extension HomeVC:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BouquetCell", for: indexPath) as! BouquetCell
        let tap = UITapGestureRecognizer()
        cell.configCell(data: self.arrData[indexPath.row])
        tap.addAction {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: DetailsVC.self) {
                vc.data = self.arrData[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        cell.vwMain.isUserInteractionEnabled = true
        cell.vwMain.addGestureRecognizer(tap)
        return cell
    }
    
    
    
    
    func setUpData(){
        var data = [FlowerModel]()
        data.append(FlowerModel(docID: "", name: "Roses", image: "https://firebasestorage.googleapis.com/v0/b/flowerapp-87082.appspot.com/o/Flowers%2Frose.jpg?alt=media&token=ab38987d-189d-4971-97fc-5e4027f3aad3"))
      
        data.append(FlowerModel(docID: "", name: "Carnations", image: "https://firebasestorage.googleapis.com/v0/b/flowerapp-87082.appspot.com/o/Flowers%2FCarnations.jpg?alt=media&token=840b0d25-6d9d-4386-afba-95867801a7e6"))
      
        data.append(FlowerModel(docID: "", name: "Gerberas", image: "https://firebasestorage.googleapis.com/v0/b/flowerapp-87082.appspot.com/o/Flowers%2FGaebera.jpg?alt=media&token=467fa3dd-68b6-436d-9193-66119d9cbea6"))
      
        data.append(FlowerModel(docID: "", name: "Lilies", image: "https://firebasestorage.googleapis.com/v0/b/flowerapp-87082.appspot.com/o/Flowers%2FLilies.jpg?alt=media&token=0833f1c3-513d-4422-bc47-d75b1006c7fa"))
      
        data.append(FlowerModel(docID: "", name: "Orchids", image: "https://firebasestorage.googleapis.com/v0/b/flowerapp-87082.appspot.com/o/Flowers%2FOrchid.jpg?alt=media&token=35acb305-bda2-4232-8cc4-69c2e86a6487"))
      
        
        for data1 in data {
            self.AddFlowerData(data: data1)
        }
    }
    
    func AddData(data: BouquetModel) {
        var ref : DocumentReference? = nil
        ref = AppDelegate.shared.db.collection(fBouquet).addDocument(data:
            [
                fName: data.name.description,
                fDescription : data.description.description,
                fPrice: data.price.description,
                fImage : data.image.description
            ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    func AddFlowerData(data: FlowerModel) {
        var ref : DocumentReference? = nil
        ref = AppDelegate.shared.db.collection(fFlower).addDocument(data:
            [
                fName: data.name.description,
                fImage : data.image.description
            ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    
    func getData() {
        _ = AppDelegate.shared.db.collection(fBouquet).addSnapshotListener{ querySnapshot, error in
            
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
}


class BouquetCell: UITableViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var imgData: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    //MARK:- Class Variables
    
    //MARK:- Custom Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vwMain.layer.cornerRadius = 10.0
        self.vwMain.backgroundColor  = .white
        self.vwMain.shadow()
    }
    
    func configCell(data: BouquetModel){
        self.lblName.text = data.name.description
        self.lblPrice.text = data.price.description
        self.imgData.setImgWebUrl(url: data.image, isIndicator: true)
    }
}
