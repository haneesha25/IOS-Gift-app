//
//  GFunction.swift
//  FlowerApp


import Foundation
import FirebaseAuth

class GFunction {
    
    static let shared: GFunction = GFunction()
    static var user : UserModel!
    
    //Firebase Authentication Login
    func firebaseRegister(data: String) {
            FirebaseAuth.Auth.auth().signIn(withEmail: data, password: "123123") { [weak self] authResult, error in
                guard self != nil else { return }
                //return if any error find
                if error != nil {
                    FirebaseAuth.Auth.auth().createUser(withEmail: data, password: "123123") { authResult, error in
                       // ApiManager.shared.removeLoader()
                        //Return if error find
                        if error != nil {
                            return
                        }else{
                            FirebaseAuth.Auth.auth().signIn(withEmail: data, password: "123123") { [weak self] authResult, error in
                                guard self != nil else { return }
                                
                            }
                        }
                    }
                }
            }
        }
    
    func UTCToDate(date:Date) -> String {
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: date) // string purpose I add here
        let yourDate = formatter.date(from: myString)  // convert your string to date
        formatter.dateFormat = "yyyyMMDDHHmmss"  //then again set the date format whhich type of output you need
        return formatter.string(from: yourDate!) // again convert your date to string
    }
}
