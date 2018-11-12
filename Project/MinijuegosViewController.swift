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
    
    @IBAction func goBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
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
        print(dictionary!.object(forKey: "freefall")!)
        print(dictionary!.object(forKey: "swiping")!)
        print(dictionary!.object(forKey: "catchup")!)
    }
    
    func dataFilePath() -> String {
        let url = FileManager().urls(for: .documentDirectory,
                                     in: .userDomainMask).first!
        let pathArchivo =
            url.appendingPathComponent("scores.plist")
        return pathArchivo.path
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }

}
