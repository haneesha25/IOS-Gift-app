//
//  FlowerModel.swift
//  FlowerApp
//
//  Created by 2022M3 on 29/06/22.
//

import Foundation

class FlowerModel {
    var docID: String
    var name: String
    var image: String
    var isSelected:Bool
    
    
    init(docID: String,name:String, image:String) {
        self.docID = docID
        self.name = name
        self.image = image
        self.isSelected = false
    }
}
