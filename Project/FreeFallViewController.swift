//
//  FreeFallViewController.swift
//  Project
//
//  Created by Alumno on 16/10/18.
//  Copyright © 2018 itesm. All rights reserved.
//

import UIKit

class FreeFallViewController: UIViewController {
    
    @IBOutlet weak var lbOption1: UIButton!
    @IBOutlet weak var lbOption2: UIButton!
    @IBOutlet weak var lbOption3: UIButton!
    @IBOutlet weak var lbOption4: UIButton!
    @IBOutlet weak var lbOption5: UIButton!
    
    @IBAction func choose(_ sender: UIButton) {
        chooses(opcion: sender.titleLabel!.text!)
    }
    
    @IBAction func choose2(_ sender: UIButton) {
        chooses(opcion: sender.titleLabel!.text!)
    }
    
    @IBAction func choose3(_ sender: UIButton) {
        chooses(opcion: sender.titleLabel!.text!)
    }
    
    @IBAction func choose4(_ sender: UIButton) {
        chooses(opcion: sender.titleLabel!.text!)
    }
    
    @IBAction func choose5(_ sender: UIButton) {
        chooses(opcion: sender.titleLabel!.text!)
    }
    
    func chooses(opcion:String) {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        lbResult.frame.origin.x = screenWidth * 0.5 - lbResult.frame.width * 0.5
        lbResult.frame.origin.y = screenHeight * 0.5 - lbResult.frame.height * 0.5
        gameOver = true
        if (opcion == solution) {
            lbResult.text = "¡Bien hecho!"
        }
        else {
            lbResult.text = "¡Que mal!"
        }
        gameOver = true
    }
    
    var option:Option?
    var options = [Option]()
    
    var timeCount:Int?
    var timer = Timer()
    var actTimer = Timer()
    var labels = [UIButton]()
    var solution:String?
    var currentPhrase:String?
    var optionWords = [String]()
    var gameOver:Bool?
    
    @IBOutlet weak var lbPhrase: UILabel!
    @IBOutlet weak var lbResult: UILabel!
    @IBOutlet weak var lbTimer: UILabel!
    var arregloDiccionarios : NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeCount = 25
        lbTimer.text = secondsToString(seconds: timeCount!)
        
        gameOver = false
        lbResult.frame.origin.x = -1000
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(counter), userInfo: nil, repeats: true)
        actTimer = Timer.scheduledTimer(timeInterval: 0.007, target: self, selector: #selector(act), userInfo: nil, repeats: true)
        getData()
        setLabels()
        setOptions()
    }
    
    func setLabels(){
        labels.append(lbOption1)
        labels.append(lbOption2)
        labels.append(lbOption3)
        labels.append(lbOption4)
        labels.append(lbOption5)
    }
    
    func getData() {
        
        let path = Bundle.main.path(forResource: "FreeFallData", ofType: "plist")!
        arregloDiccionarios = NSArray(contentsOfFile: path)
        
        let randomIndex = Int.random(in: 0 ... arregloDiccionarios.count - 1)
        
        let dic = arregloDiccionarios[randomIndex] as! NSDictionary
        
        let phrase = dic.object(forKey: "phrase") as? String
        let optionsArray = dic.object(forKey: "options") as? [String]
        let sol = dic.object(forKey: "solution") as? String
            
        currentPhrase = phrase
        for op in optionsArray! {
            optionWords.append(op)
        }
        solution = sol
    
    }
    
    func setOptions() {
        var c = 0
        for label in labels {
            options.append(Option(content: optionWords[c], button: label))
            if (c == optionWords.count - 1) {
                c = 0
            }
            else {
                c = c + 1
            }
        }
        lbPhrase.text = currentPhrase!
    }
    
    @objc func act() {
        if !gameOver! {
            for option in options {
                option.act()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func counter() {
        if timeCount == 0 {
            lbTimer.text = "Game Over"
            gameOver = true
        }
        else {
            timeCount = timeCount! - 1
            lbTimer.text = secondsToString(seconds: timeCount!)
        }
    }
    
    func secondsToString(seconds:Int) -> String {
        let minutes = seconds / 60 % 60
        let seconds = seconds % 60
        return String(format:"%02d:%02d", minutes, seconds)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}



