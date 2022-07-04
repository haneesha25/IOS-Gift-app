//
//  BouquetModel.swift
//  FlowerApp


import Foundation


class BouquetModel {
    var docID: String
    var name: String
    var description: String
    var price: String
    var image: String
    
    
    init(docID: String,name:String,descripiton:String,price:String, image:String) {
        self.docID = docID
        self.name = name
        self.description = descripiton
        self.price = price
        self.image = image
    }
}
