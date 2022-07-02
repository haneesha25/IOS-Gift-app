//
//  OrderVC.swift
//  FlowerApp


import UIKit

class OrderVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var tblList: SelfSizedTableView!
    
    //MARK:- Class Variables
    var arrData = [OrderModel]()
    
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

extension OrderVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderedCell", for: indexPath) as! OrderedCell
        cell.configCell(data: self.arrData[indexPath.row])
        return cell
    }
    
    
    
    func getData(email:String) {
        _ = AppDelegate.shared.db.collection(fOrder).whereField(fEmail, isEqualTo: email).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            self.arrData.removeAll()
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if let name: String = data1[fName] as? String, let description: String = data1[fDescription] as? String,let imagePath: String = data1[fImage] as? String, let price: String = data1[fPrice] as? String, let orderDate: String = data1[fOrderDate] as? String, let orderType: String = data1[fOrderType] as? String {
                        print("Data Count : \(self.arrData.count)")
                        self.arrData.append(OrderModel(docID: data.documentID, name: name, descripiton: description, price: price, image: imagePath, orderDate: orderDate, orderType: orderType))
                    }
                }
                self.arrData = self.arrData.reversed()
                self.tblList.delegate = self
                self.tblList.dataSource = self
                self.tblList.reloadData()
            }else{
                Alert.shared.showAlert(message: "No Data Found !!!", completion: nil)
            }
        }
    }
    
}

class OrderedCell: UITableViewCell {
    //MARK:- Outlets
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var imgData: UIImageView!
    @IBOutlet weak var vwMain: UIView!
    
    
    //MARK:- Class Variables
    
    //MARK:- Custom Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.vwMain.layer.cornerRadius = 10.0
        self.vwMain.backgroundColor = .white
        self.vwMain.shadow()
    }
    
    
    func configCell(data: OrderModel){
        self.lblName.text = data.name.description
        self.lblPrice.text = "$\(data.price.description)"
        self.lblDate.text = data.orderDate.description
        self.lblStatus.text = data.orderType.description
        self.imgData.setImgWebUrl(url: data.image, isIndicator: true)
    }
}
