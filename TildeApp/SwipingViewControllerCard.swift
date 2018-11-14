//
//  SwipingViewControllerCard.swift
//  Project
//
//  Created by Ana Perez on 10/16/18.
//  Copyright © 2018 itesm. All rights reserved.
//

import UIKit

extension SwipingViewController {
    
    func getData() {
        let path = Bundle.main.path(forResource: "Swiping", ofType: "plist")!
        arrWords = NSArray(contentsOfFile: path)
    }
    
    func updateCard() {
        cardLabel.text = (arrWords[indexWord] as! NSDictionary).object(forKey: "word") as? String
    }
}
