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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getScores()
    }
    
    func getScores() {
        let path = Bundle.main.path(forResource: "ScoreData", ofType: "plist")!
        let dictionary = NSDictionary(contentsOfFile: path)
        lbScoreFreeFall.text = "\(dictionary!.object(forKey: "freefall")! as! Int)"
        lbScoreSwiping.text = "\(dictionary!.object(forKey: "swiping")! as! Int)"
        lbScoreCatchUp.text = "\(dictionary!.object(forKey: "catchup")! as! Int)"
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
