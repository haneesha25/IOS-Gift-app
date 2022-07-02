//
//  ProfileVC.swift
//  FlowerApp

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var btnLogout: BlueThemeButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBAction func btnLogoutClick(_ sender: UIButton) {
        UIApplication.shared.setStart()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if !GFunction.user.email.isEmpty {
            let user = GFunction.user
            self.lblName.text = "\(user?.fName ?? "") \(user?.lName ?? "")"
            self.lblEmail.text = user?.email
            self.lblPhone.text = "\(user?.code ?? "") \(user?.mobile ?? "")"
            self.lblAddress.text = "\(user?.city ?? ""), \(user?.state ?? ""), \(user?.zipcode ?? "")"
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = false
    }

}
