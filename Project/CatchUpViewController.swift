import UIKit
import AVFoundation

class CatchUpViewController: UIViewController {

    var arregloDiccionarios : NSArray!
    var upCorrect: Bool!
    var upPhrase: String!
    var downPhrase: String!
    var score:Int!
    var timer:Timer!
    var timeCount:Int!
    var player: AVAudioPlayer?

    @IBOutlet weak var lbScore: UILabel!
    @IBOutlet weak var btnUpPhrase: UIButton!
    @IBOutlet weak var btnDownPhrase: UIButton!
    
    @IBAction func choosesUp(_ sender: Any) {
        if (upCorrect) {
            getData()
            score = score + 1
            lbScore.text = "\(score!)"
        }
        else {
            goToRetro(timeOver: true)
        }
    }
    
    @IBAction func choosesDown(_ sender: Any) {
        if (!upCorrect) {
            getData()
            score = score + 1
            lbScore.text = "\(score!)"
        }
        else {
            goToRetro(timeOver: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(counter), userInfo: nil, repeats: true)
        restart()
    }

    @objc func counter() {
        if timeCount == 0 {
        //    lbTimer.text = "Game Over"
        //    gameOver = true
            goToRetro(timeOver: true)
        }
        else {
            timeCount = timeCount! - 1
            print(timeCount)
        //   lbTimer.text = secondsToString(seconds: timeCount!)
        }
    }
    
    func restart() {
        score = 0
        timeCount = Int.random(in: 20 ... 21)
        getData()
        playMusic()
    }
    
    func getData() {
        let path = Bundle.main.path(forResource: "CatchUp", ofType: "plist")!
        arregloDiccionarios = NSArray(contentsOfFile: path)
        
        let randomIndex = Int.random(in: 0 ... arregloDiccionarios.count - 1)
        let dic = arregloDiccionarios[randomIndex] as! NSDictionary
        
        let correctPhrase = dic.object(forKey: "right") as? String
        let wrongPhrase = dic.object(forKey: "wrong") as? String
        upCorrect = Bool.random()
        
        if (upCorrect) {
            btnUpPhrase.setTitle(correctPhrase, for: .normal)
            btnDownPhrase.setTitle(wrongPhrase, for: .normal)
        }
        else {
            btnUpPhrase.setTitle(wrongPhrase, for: .normal)
            btnDownPhrase.setTitle(correctPhrase, for: .normal)
        }
    }
    
    func goToRetro(timeOver:Bool) {
     //   playTimeOverSound()
        let retroView = self.storyboard?.instantiateViewController(withIdentifier: "RetroCatchUpViewController") as! RetroCatchUpViewController
        retroView.score = score
        present(retroView, animated: true, completion: nil)
    }
    
    func playMusic() {
        let url = Bundle.main.url(forResource: "clock-sound", withExtension: "mp3")!
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            player.numberOfLoops = -1
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func pla() {
        let url = Bundle.main.url(forResource: "clock-sound", withExtension: "mp3")!
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            player.numberOfLoops = -1
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}
