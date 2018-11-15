//
//  SwipingViewController.swift
//  Project
//
//  Created by Ana Perez on 10/16/18.
//  Copyright © 2018 itesm. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation

class SwipingViewController: UIViewController, Game {

    var timeCount : Int?
    var timer = Timer()
    var arrWords : NSArray!
    var arrWords1 : NSArray!
    var indexWord : Int!
    var correctCount : Int!
    var correct : Bool!
    var detail:UIView!
    var playerCorrect: AVAudioPlayer?
    var playerWrong: AVAudioPlayer?
    var playerTimeOver: AVAudioPlayer?
    @IBOutlet weak var skip1: UIView!
    @IBOutlet weak var skip2: UIView!
    @IBOutlet weak var skip3: UIView!
    @IBOutlet weak var lbTimer: UILabel!
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var cardSec: UIView!
    @IBOutlet weak var imageThumbnail: UIImageView!
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var lbCorrect: UILabel!
    @IBOutlet weak var cardSecond: UIView!
    @IBOutlet weak var viewSkip: UIView!
    @IBOutlet weak var infoButton: UIButton!
    
    var skips : Int!
    
    @IBAction func skip(_ sender: Any) {
        if skips == 3 {
            skip3.alpha = 0.3
            skips = skips - 1
            updateCard()
        } else if skips == 2 {
            skip2.alpha = 0.3
            skips = skips - 1
            updateCard()
        } else if skips == 1 {
            skip1.alpha = 0.3
            skips = skips - 1
            updateCard()
            viewSkip.alpha = 0.3
        }
    }
    
    @IBAction func moveCard(_ sender: UIPanGestureRecognizer) {
        let cardS = sender.view!
        let point = sender.translation(in: view)
        cardS.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        let xMovement = cardS.center.x - view.center.x
        card.transform = CGAffineTransform(rotationAngle: 0.61*(2*xMovement/view.frame.width))
        if xMovement > 0 {
            imageThumbnail.image = UIImage(named: "correct.png")
        } else {
            imageThumbnail.image = UIImage(named: "incorrect.png")
        }
        imageThumbnail.alpha = abs(xMovement / view.center.x)
        if sender.state == UIGestureRecognizer.State.ended {
            if cardS.center.x < 75 {
                // User choose incorrect
                UIView.animate(withDuration: 0.3) {
                    cardS.center = CGPoint(x: cardS.center.x - 200, y: cardS.center.y + 75)
                    cardS.alpha = 0
                }
                UIView.animate(withDuration: 0.3, animations: {
                    cardS.center = CGPoint(x: cardS.center.x - 200, y: cardS.center.y + 75)
                    cardS.alpha = 0
                }) { (finished: Bool) in
                    self.resetCard(timeAnimation: 0)
                }
                correct = !correct
                checkPoints()
                updateCard()
            } else if cardS.center.x > view.frame.width - 75 {
                // User choose correct
                UIView.animate(withDuration: 0.3, animations: {
                    cardS.center = CGPoint(x: cardS.center.x + 200, y: cardS.center.y + 75)
                    cardS.alpha = 0
                }) { (finished: Bool) in
                    self.resetCard(timeAnimation: 0)
                }
                checkPoints()
                updateCard()
            } else {
                resetCard(timeAnimation: 0.3)
            }
            
        }
    }
    
    func checkPoints() {
        if correct {
            playerCorrect!.stop()
            playerCorrect!.play()
            correctCount = correctCount + 1
            lbCorrect.text = String(correctCount)
        } else {
            playerWrong!.stop()
            playerWrong!.play()
            goToRetro(timeOver: false)
        }
    }
    
    func goToRetro(timeOver:Bool) {
        let viewPrincipal = self.presentingViewController?.presentingViewController as! ViewController
        if (viewPrincipal.wantVibration) {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        updateScore()
        timer.invalidate()
        let retroView = self.storyboard?.instantiateViewController(withIdentifier: "RetroFreeFallViewController") as! RetroFreeFallViewController
        retroView.score = correctCount
        retroView.game = self
        if !timeOver {
            retroView.wrongPhrase = (arrWords[indexWord] as! NSDictionary).object(forKey: "wrong") as? String
            retroView.solution = (arrWords[indexWord] as! NSDictionary).object(forKey: "right") as? String
        }
        else {
            playerTimeOver!.play()
            retroView.wrongPhrase = nil
        }
        present(retroView, animated: true, completion: nil)
    }
    
    func dataFilePath() -> String {
        let url = FileManager().urls(for: .documentDirectory,
                                     in: .userDomainMask).first!
        let pathArchivo =
            url.appendingPathComponent("scores.plist")
        return pathArchivo.path
    }
    
    func updateScore() {
        let filePath = dataFilePath()
        if FileManager.default.fileExists(atPath: filePath) {
            let dictionary = NSDictionary(contentsOfFile: filePath)!
            let storedScore = dictionary.object(forKey: "swiping")! as! Int
            if storedScore < correctCount {
                let newDictionary:NSDictionary = [
                    "freefall": dictionary.object(forKey: "freefall")! as! Int,
                    "swiping": correctCount,
                    "catchup": dictionary.object(forKey: "swiping")! as! Int
                    ]
                newDictionary.write(toFile: dataFilePath(), atomically: true)
            }
        }
    }
    
    func resetCard(timeAnimation : Double) {
        UIView.animate(withDuration: timeAnimation) {
            self.card.center = self.view.center
            self.imageThumbnail.alpha = 0
            self.card.alpha = 1
            self.card.transform = .identity
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeCount = 60
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(counter), userInfo: nil, repeats: true)
        makeCardForm(card: card)
        makeCardForm(card: cardSecond)
        card.frame.size.width = view.frame.width * 0.8
        card.frame.size.height = view.frame.width * 0.8
        card.center = CGPoint(x: view.center.x, y: view.center.y)
        cardSec.center = CGPoint(x: view.center.x, y: view.center.y)
        imageThumbnail.frame.size.width = card.frame.width * 0.6
        imageThumbnail.center = CGPoint(x: view.center.x-(card.center.x-card.frame.height/2), y: view.center.y-(card.center.y-card.frame.width/2))
        cardLabel.frame.size.width = card.frame.width * 0.9
        cardLabel.center = CGPoint(x: view.center.x-(card.center.x-card.frame.height/2), y: view.center.y-(card.center.y-card.frame.width/2))
        infoButton.tintColor = UIColor.white
        correctCount = 0
        skips = 3
        indexWord = 0
        cardLabel.adjustsFontSizeToFitWidth = true
        getData()
        updateCard()
        setSoundEffectPlayers()
    }
    
    func makeCardForm(card : UIView) {
        // border radius
        card.layer.cornerRadius = 30.0
        
        // border
        card.layer.borderColor = UIColor.lightGray.cgColor
        card.layer.borderWidth = 1.5;
        
        // drop shadow
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.8
        card.layer.shadowRadius = 3.0
        card.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
    }
    
    @objc func counter() {
        if timeCount == 0 {
            goToRetro(timeOver: true)
        } else {
            timeCount = timeCount! - 1
            lbTimer.text = secondsToString(seconds: timeCount!)
        }
    }
    
    @objc func continuePlaying(sender: UIButton!) {
        detail.removeFromSuperview()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(counter), userInfo: nil, repeats: true)
    }
    
    
    func secondsToString(seconds:Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format:"%02d:%02d", minutes, seconds)
    }
    
    func getData() {
        let path = Bundle.main.path(forResource: "Swiping", ofType: "plist")!
        arrWords = NSArray(contentsOfFile: path)
        arrWords = arrWords.shuffled() as NSArray
    }
    
    func updateCard() {
        indexWord = (indexWord + 1) % arrWords.count
        correct = Bool.random()
        if (correct) {
            cardLabel.text = (arrWords[indexWord] as! NSDictionary).object(forKey: "right") as? String
        } else {
            cardLabel.text = (arrWords[indexWord] as! NSDictionary).object(forKey: "wrong") as? String
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    // Protocolo Game
    func restart() {
        timeCount = 60
        correctCount = 0
        skips = 3
        indexWord = 0
        lbTimer.text = secondsToString(seconds: timeCount!)
        lbCorrect.text = "0"
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(counter), userInfo: nil, repeats: true)
        getData()
        updateCard()
    }
    
    //Action for information
    @IBAction func infoTrigger(_ sender: Any) {
        detail = UIView()
        detail.backgroundColor = UIColor(
            red: 0,
            green: 0,
            blue: 0,
            alpha: 0.92)
        detail.frame.size.width = view.frame.width
        detail.frame.size.height = view.frame.height
        detail.frame.origin.x = 0
        detail.frame.origin.y = 0
        let tv = UITextView()
        tv.isEditable = false
        tv.backgroundColor = UIColor(
            red: 0,
            green: 0,
            blue: 0,
            alpha: 0.0)
        tv.textAlignment = .center
        tv.text = "¿Cómo jugar?\n\n"
        tv.text = tv.text + "Gira la palabra a la derecha si crees que esta escrita correctamente, o girala a la izquierda si crees que esta equivocada."
        tv.font = tv.font!.withSize(20)
        tv.textColor = .white
        tv.frame.size.width = view.frame.width * 0.9
        tv.frame.size.height = view.frame.height * 0.4
        tv.frame.origin.y = view.frame.height * 0.5 - tv.frame.height * 0.5
        tv.frame.origin.x = view.frame.width * 0.05
        let btn = UIButton()
        btn.frame.size.width = view.frame.width
        btn.frame.size.height = 50
        btn.frame.origin.y = view.frame.height - btn.frame.height - 100
        btn.frame.origin.x = 0
        btn.setTitle("OK", for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(continuePlaying), for: .touchUpInside)
        detail.addSubview(tv)
        detail.addSubview(btn)
        view.addSubview(detail)
        timer.invalidate()
    }
    
    // Go back
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        timer.invalidate()
    }
    
    // Sound effects
    func setSoundEffectPlayers() {
        var url = Bundle.main.url(forResource: "correct", withExtension: "mp3")!
        do {
            playerCorrect = try AVAudioPlayer(contentsOf: url)
            guard let playerCorrect = playerCorrect else { return }
            playerCorrect.numberOfLoops = 0
            playerCorrect.prepareToPlay()
        } catch let error {
            print(error.localizedDescription)
        }
        url = Bundle.main.url(forResource: "wrong", withExtension: "mp3")!
        do {
            playerWrong = try AVAudioPlayer(contentsOf: url)
            guard let playerWrong = playerWrong else { return }
            playerWrong.numberOfLoops = 0
            playerWrong.prepareToPlay()
        } catch let error {
            print(error.localizedDescription)
        }
        
        url = Bundle.main.url(forResource: "time-over", withExtension: "mp3")!
        do {
            playerTimeOver = try AVAudioPlayer(contentsOf: url)
            guard let playerTimeOver = playerTimeOver else { return }
            playerTimeOver.numberOfLoops = 0
            playerTimeOver.prepareToPlay()
        } catch let error {
            print(error.localizedDescription)
        }
        
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
