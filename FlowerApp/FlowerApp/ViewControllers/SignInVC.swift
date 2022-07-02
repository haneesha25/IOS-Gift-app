//
//  SignInVC.swift
//  FlowerApp


import UIKit

class SignInVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var lblSignIn: UILabel!
    @IBOutlet weak var lblSignDetail: UILabel!
    @IBOutlet weak var txtUsername: ThemeTextField!
    @IBOutlet weak var txtPassword: ThemeTextField!
    @IBOutlet weak var btnEye: UIButton!
    @IBOutlet weak var btnCheckBox: UIButton!
    @IBOutlet weak var lblRememberMe: UILabel!
    @IBOutlet weak var btnSignIn: BlueThemeButton!
    @IBOutlet weak var lblForgotPassword: UILabel!
    @IBOutlet weak var vwPassword: UIView!
    
    //MARK:- Class Variables
    var isCheckBoxSelected = Bool()
    var flag: Bool = true
    var socialData: SocialLoginDataModel!
    
    //MARK:- Custom Methods
    
    func applyStyle() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backArrow"), style: .plain, target: self, action: #selector(backButtonTapped))
       
        self.lblSignDetail.font =  UIFont(name: "regular", size: 16.0)
        self.lblSignDetail.textColor = .lightGray
        self.lblRememberMe.font = UIFont(name: "regular", size: 14.0)
        self.lblRememberMe.textColor = .lightGray
        self.btnEye.setImage(UIImage(named: "closeEye"), for: .selected)
        self.btnEye.setImage(UIImage(named: "openEye"), for: .normal)
        self.btnCheckBox.setImage(UIImage(named: "plain"), for: .normal)
        self.btnCheckBox.setImage(UIImage(named: "tickMark"), for: .selected)
        
        if socialData != nil {
            self.txtUsername.text = socialData.email
            self.txtUsername.isUserInteractionEnabled = false
        }
    }
    
    
    func validation(email: String, password: String) -> String {
        
        if email.isEmpty {
            return STRING.errorEmail
        }else if !Validation.isValidEmail(email) {
            return STRING.errorValidEmail
        } else if password.isEmpty {
            return STRING.errorPassword
        } else if password.count < 8 {
                return STRING.errorPasswordCount
        } else if !Validation.isValidPassword(password) {
            return STRING.errorValidCreatePassword
        } else {
            return ""
        }
    }
    
    //MARK:- Action Methods
    @IBAction func btnCheckBoxTapped(_ sender: UIButton) {
        if self.btnCheckBox.isSelected {
            self.btnCheckBox.isSelected = false
        } else {
            self.isCheckBoxSelected = true
            self.btnCheckBox.isSelected = true
        }
    }
    
    @IBAction func btnEyeTapped(_ sender: UIButton) {
        if self.btnEye.isSelected {
            self.btnEye.isSelected = false
            self.txtPassword.isSecureTextEntry = false
        } else {
            self.btnEye.isSelected = true
            self.txtPassword.isSecureTextEntry = true
        }
    }
    
    
    @IBAction func btnSignInTapped(_ sender: UIButton) {
//        self.sendMail()
        self.flag = false
        let error = self.validation(email: self.txtUsername.text!.trim(),password: self.txtPassword.text!.trim())

        if error.isEmpty {
            self.loginUser(email: self.txtUsername.text?.trim() ?? "", password: self.txtPassword.text?.trim() ?? "")
        }else{
            Alert.shared.showAlert(message: error, completion: nil)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    //MARK:- ViewLifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyStyle()
        // Do any additional setup after loading the view.
    }

}

//MARK:- Extension for Login Function
extension SignInVC {
    
    
    func loginUser(email:String,password:String) {
        
        _ = AppDelegate.shared.db.collection(fUser).whereField(fEmail, isEqualTo: email).whereField(fPassword, isEqualTo: password).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if snapshot.documents.count != 0 {
                let data1 = snapshot.documents[0].data()
                let docId = snapshot.documents[0].documentID
                if let city : String = data1[fCity] as? String, let fname: String = data1[fFName] as? String, let phone: String = data1[fPhone] as? String, let email: String = data1[fEmail] as? String, let password: String = data1[fPassword] as? String, let lname: String = data1[fLName] as? String, let code: String = data1[fCode] as? String, let state: String = data1[fState] as? String, let zipcode: String = data1[fZipcode] as? String {
                    GFunction.user = UserModel(docID: docId, fName: fname, lName: lname, code: code, mobile: phone, city: city, state: state, zipcode: zipcode, email: email, password: password)
                }
                GFunction.shared.firebaseRegister(data: email)
                UIApplication.shared.setTab()
            }else{
                if !self.flag {
                    Alert.shared.showAlert(message: "Please check your credentials !!!", completion: nil)
                    self.flag = true
                }
            }
        }
        
    }
}

