//
//  UserModel.swift
//  FlowerApp

import Foundation



class UserModel {
    var docID: String
    var fName: String
    var lName: String
    var code: String
    var mobile: String
    var city: String
    var state: String
    var zipcode: String
    var email: String
    var password: String
    
    
    init(docID: String,fName: String,lName: String,code: String,mobile: String,city: String,state: String,zipcode: String,email: String,password:String) {
        self.docID = docID
        self.fName = fName
        self.lName = lName
        self.email = email
        self.code = code
        self.mobile = mobile
        self.city = city
        self.state = state
        self.zipcode = zipcode
        self.password = password
    }
}
