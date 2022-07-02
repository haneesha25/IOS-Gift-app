//
//  OrderModel.swift
//  FlowerApp

import Foundation


class OrderModel {
    var docID: String
    var name: String
    var description: String
    var price: String
    var image: String
    var orderDate: String
    var orderType: String
    
    
    init(docID: String,name:String,descripiton:String,price:String, image:String,orderDate: String, orderType: String) {
        self.docID = docID
        self.name = name
        self.description = descripiton
        self.price = price
        self.image = image
        self.orderDate = orderDate
        self.orderType = orderType
    }
}
