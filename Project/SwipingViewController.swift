//
//  SwipingViewController.swift
//  Project
//
//  Created by Ana Perez on 10/16/18.
//  Copyright © 2018 itesm. All rights reserved.
//

import UIKit

class SwipingViewController: UIViewController {

    var timeCount : Int?
    var timer = Timer()
    var actTimer = Timer()
    var arrWords : NSArray!
    var gameOver = false
    var indexWord : Int!
    var correctCount : Int!
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
            let correct = (arrWords[indexWord] as! NSDictionary).object(forKey: "correct") as! Bool
            
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
                checkPoints(correct: !correct)
                updateCard()
            } else if cardS.center.x > view.frame.width - 75 {
                // User choose correct
                UIView.animate(withDuration: 0.3, animations: {
                    cardS.center = CGPoint(x: cardS.center.x + 200, y: cardS.center.y + 75)
                    cardS.alpha = 0
                }) { (finished: Bool) in
                    self.resetCard(timeAnimation: 0)
                }
                checkPoints(correct: correct)
                updateCard()
            } else {
                resetCard(timeAnimation: 0.3)
            }
            
        }
    }
    
    func checkPoints(correct : Bool) {
        if correct {
            correctCount = correctCount + 1
            lbCorrect.text = String(correctCount)
        } else {
            goToRetro(timeOver: false)
        }
    }
    
    func goToRetro(timeOver:Bool) {
        let retroView = self.storyboard?.instantiateViewController(withIdentifier: "RetroFreeFallViewController") as! RetroFreeFallViewController
        retroView.score = correctCount
        if !timeOver {
            retroView.wrongPhrase = (arrWords[indexWord] as! NSDictionary).object(forKey: "word") as? String
            retroView.solution = ""
            retroView.source = 2
        }
        else {
            retroView.wrongPhrase = nil
            retroView.source = 2
        }
        present(retroView, animated: true, completion: nil)
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
        timeCount = 90
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(counter), userInfo: nil, repeats: true)
        makeCardForm(card: card)
        makeCardForm(card: cardSecond)
        card.center = CGPoint(x: view.center.x, y: view.center.y)
        cardSec.center = CGPoint(x: view.center.x, y: view.center.y)
        // TODO: Shuffle NSArray
        correctCount = 0
        skips = 3
        indexWord = 0
        getData()
        updateCard()
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
            lbTimer.text = "Game Over"
            gameOver = true
        } else {
            timeCount = timeCount! - 1
            lbTimer.text = secondsToString(seconds: timeCount!)
        }
    }
    
    func secondsToString(seconds:Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format:"%02d:%02d", minutes, seconds)
    }
    
    func getData() {
        let path = Bundle.main.path(forResource: "Swiping", ofType: "plist")!
        arrWords = NSArray(contentsOfFile: path)
    }
    
    func updateCard() {
        indexWord = (indexWord + 1) % arrWords.count
        cardLabel.text = (arrWords[indexWord] as! NSDictionary).object(forKey: "word") as? String
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
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
