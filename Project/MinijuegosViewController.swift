//
//  MinijuegosViewController.swift
//  Project
//
//  Created by Alumno on 17/10/18.
//  Copyright © 2018 itesm. All rights reserved.
//

import UIKit

class MinijuegosViewController: UIViewController {

    @IBOutlet weak var lbScoreFreeFall: UILabel!
    @IBOutlet weak var lbScoreSwiping: UILabel!
    @IBOutlet weak var lbScoreCatchUp: UILabel!
    var dictionary:NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getScores()
    }
    
    func getScores() {
        let filePath = dataFilePath()
        if FileManager.default.fileExists(atPath: filePath) {
            dictionary = NSDictionary(contentsOfFile: filePath)!
        }
        else {
            dictionary = [
                "freefall" : 0,
                "swiping" : 0,
                "catchup" : 0
            ]
            dictionary.write(toFile: dataFilePath(), atomically: true)
        }
        lbScoreFreeFall.text = "\(dictionary!.object(forKey: "freefall")! as! Int)"
        lbScoreSwiping.text = "\(dictionary!.object(forKey: "swiping")! as! Int)"
        lbScoreCatchUp.text = "\(dictionary!.object(forKey: "catchup")! as! Int)"
    }
    
    func dataFilePath() -> String {
        let url = FileManager().urls(for: .documentDirectory,
                                     in: .userDomainMask).first!
        let pathArchivo =
            url.appendingPathComponent("scores.plist")
        return pathArchivo.path
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
