//
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
    
    
    func setUpBouquetData(){
        self.arrData.append(BouquetModel(docID: "", name: "Unique Roses Bouquet", descripiton: "Red Roses can steal anyone's heart. And when gifted to someone packed in such a unique and classy way, you are sure to get loads of love and affection from them. Yiu can gift these fresh bright 12 Red roses to your lover or life partner and be their forever.", price: "$250", image: "https://firebasestorage.googleapis.com/v0/b/flowerapp-87082.appspot.com/o/Bouquets%2Funique-roses-bouquet-749.jpg?alt=media&token=e9b7abfd-e3a5-4cb4-b979-54209fd0f13a"))
        self.arrData.append(BouquetModel(docID: "", name: "Anthurium & Gerbera Bouquet", descripiton: "Spread the happiness and love all around when you send this unique flower bouquet assorted with beautiful, fresh and hand-picked 3 gerberas, 3 anthuriums and seasonal leaves in one single bouquet by our professionals.", price: "$450", image: "https://firebasestorage.googleapis.com/v0/b/flowerapp-87082.appspot.com/o/Bouquets%2Fproduct-anthrium-gerbera-basket-1.jpg?alt=media&token=4998d852-a606-449e-abfe-2560ef8fd41a"))
        self.arrData.append(BouquetModel(docID: "", name: "Mixed Flower Bouquet", descripiton: "Celebrate your friend’s birthday by sending our mixed flowers bouquet filled with 15 pink, yellow, red, blue and white colored assorted flowers including roses along with green leaves and tied up in a white ribbon.", price: "$299", image: "https://firebasestorage.googleapis.com/v0/b/flowerapp-87082.appspot.com/o/Bouquets%2Fmixed-flower-bouquet-745.jpg?alt=media&token=a6d4856f-f5ca-400f-a2b9-6240fcf55030"))
        self.arrData.append(BouquetModel(docID: "", name: "Anthurium, BOP & Lily Basket", descripiton: "Let your dearest one start afresh and joyful day with this precious and unique floral gift decorated with 3 red anthurium and combination shades of hand-picked 2 BOP & 2 lily from our florist.", price: "$599", image: "https://firebasestorage.googleapis.com/v0/b/flowerapp-87082.appspot.com/o/Bouquets%2Fproduct-anthrium-bob-lily-basket-1.jpg?alt=media&token=ead6fdd2-a0cc-4409-86b6-f64f76563e63"))
        self.arrData.append(BouquetModel(docID: "", name: "Vase of Red Love", descripiton: "Treat your lover with a bouquet of 12 Red Rose in a Glass Vase. Gift them this with the lovely memories to cherish for years to commence ahead of you both. In return you will get lots of hugs and loves in no time. Don’t forget to purchase more than one bouquet, if you think you can prove to be the most romantic person for someone special in your life.", price: "$549", image: "https://firebasestorage.googleapis.com/v0/b/flowerapp-87082.appspot.com/o/Bouquets%2Fvase_of_red_love.jpg?alt=media&token=8d165b1a-a1c5-49ca-8f1b-545091e761b3"))
        
        self.arrData.append(BouquetModel(docID: "", name: "Yellow Lilies Bouquet", descripiton: "Send this bouquet of bright yellow lilies to the most treasured person in your life. Because this flower bouquet can speak a thousand of unspoken words to describe your feelings.", price: "$799", image: "https://firebasestorage.googleapis.com/v0/b/flowerapp-87082.appspot.com/o/Bouquets%2Fyellow-lilies-bunch-1999.jpg?alt=media&token=708ccc61-df6c-4ed1-aca6-fc1a2e85512a"))
        self.arrData.append(BouquetModel(docID: "", name: "Pink N White Lily Vase", descripiton: "A piece of utter beauty and soulfulness! This elegant bunch of fresh White and Pink Lily, kept in a glass vase will bring immense joy to the ones it is gifted to.", price: "$1299", image: "https://firebasestorage.googleapis.com/v0/b/flowerapp-87082.appspot.com/o/Bouquets%2Fpink_n_white_lily_vase.jpg?alt=media&token=4a666411-19b5-4c53-a85f-ca53373c6521"))
        self.arrData.append(BouquetModel(docID: "", name: "Red Charm", descripiton: "Red Charm", price: "$289", image: "https://firebasestorage.googleapis.com/v0/b/flowerapp-87082.appspot.com/o/Bouquets%2Fred-delight-629.jpg?alt=media&token=6670dc28-0768-488d-a4b4-58539b37b1ff"))
        self.arrData.append(BouquetModel(docID: "", name: "Serene Carnation", descripiton: "Carnations are flowers of happiness and lilies symbolise peace. This combination of flowers kept together with some seasonal fresh leaves in a classy vase. All these together give an appearance of serenity.", price: "$399", image: "https://firebasestorage.googleapis.com/v0/b/flowerapp-87082.appspot.com/o/Bouquets%2Fserene-carnation-1395.jpg?alt=media&token=849857a1-53a3-49f9-a9ea-d188c44db059"))
        self.arrData.append(BouquetModel(docID: "", name: "White Roses Bunch", descripiton: "White roses signify clean and deepest feelings. It can express the meaning of worship, pleasure, honor, and appreciation. It is an enormous bouquet of 12 white roses to be gifted to someone whom you truly appreciate.", price: "$449", image: "https://firebasestorage.googleapis.com/v0/b/flowerapp-87082.appspot.com/o/Bouquets%2Fwhite-roses-bunch-549_2.jpg?alt=media&token=1b111161-4d01-451b-b95f-91b768867069"))
        
        for data in arrData {
            self.AddData(data: data)
        }
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
