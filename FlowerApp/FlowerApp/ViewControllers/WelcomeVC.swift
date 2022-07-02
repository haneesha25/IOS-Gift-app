//
//  WelcomeVC.swift
//  FlowerApp


import UIKit

class WelcomeVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var btnSignUP: BlueThemeButton!
    @IBOutlet weak var btnSignGoogle: BlueThemeButton!
    @IBOutlet weak var btnSignFB: BlueThemeButton!
    @IBOutlet weak var btnSignIn: UIButton!
    
    //MARK:- Class Variables
    private let socialLoginManager: SocialLoginManager = SocialLoginManager()
    
    
    //MARK:- Custom Methods
    
    //MARK:- Action Methods
    @IBAction func btnClick(_ sender: UIButton) {
        if sender == btnSignUP {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: SignUPVC.self) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if sender == btnSignIn {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: SignInVC.self) {
                self.present(vc, animated: true, completion: nil)
            }
        }else if sender == btnSignGoogle {
            self.socialLoginManager.performGoogleLogin(vc: self)
        }else if sender == btnSignFB {
            self.socialLoginManager.performFacebookLogin()
        }
    }
    //MARK:- ViewLifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.socialLoginManager.delegate = self
        // Do any additional setup after loading the view.
    }

}


extension WelcomeVC: SocialLoginDelegate {

    func socialLoginData(data: SocialLoginDataModel) {
        print("Social Id==>", data.socialId ?? "")
        print("First Name==>", data.firstName ?? "")
        print("Last Name==>", data.lastName ?? "")
        print("Email==>", data.email ?? "")
        print("Login type==>", data.loginType ?? "")
        self.loginUser(email: data.email, password: data.socialId,data: data)
    }

    func loginUser(email:String,password:String,data: SocialLoginDataModel) {
        
        _ = AppDelegate.shared.db.collection(fUser).whereField(fEmail, isEqualTo: email).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if snapshot.documents.count != 0 {
                if let vc = UIStoryboard.main.instantiateViewController(withClass:  SignInVC.self) {
                    vc.socialData = data
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                if let vc = UIStoryboard.main.instantiateViewController(withClass:  SignUPVC.self) {
                    vc.socialData = data
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}
