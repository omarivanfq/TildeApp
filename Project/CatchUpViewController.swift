import UIKit
import AVFoundation

class CatchUpViewController: UIViewController, Game {
    
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
            goToRetro(timeOver: false)
        }
    }
    
    @IBAction func choosesDown(_ sender: Any) {
        if (!upCorrect) {
            getData()
            score = score + 1
            lbScore.text = "\(score!)"
        }
        else {
            goToRetro(timeOver: false)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        restart()
    }

    @objc func counter() {
        if timeCount == 0 {
            goToRetro(timeOver: true)
        }
        else {
            timeCount = timeCount! - 1
            print(timeCount!)
        }
    }
    
    func restart() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(counter), userInfo: nil, repeats: true)
        score = 0
        timeCount = Int.random(in: 20 ... 60)
        lbScore.text = "0"
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
            upPhrase = correctPhrase
            downPhrase = wrongPhrase
        }
        else {
            upPhrase = wrongPhrase
            downPhrase = correctPhrase
        }
        btnUpPhrase.setTitle(upPhrase, for: .normal)
        btnDownPhrase.setTitle(downPhrase, for: .normal)
    }
    

    func goToRetro(timeOver:Bool) {
        updateScore()
        player?.stop()
        timer.invalidate()
        let retroView = self.storyboard?.instantiateViewController(withIdentifier: "RetroFreeFallViewController") as! RetroFreeFallViewController
        retroView.score = score
        retroView.game = self
        if !timeOver {
            if (upCorrect) {
                retroView.wrongPhrase = downPhrase
                retroView.solution = upPhrase
            }
            else {
                retroView.wrongPhrase = upPhrase
                retroView.solution = downPhrase
            }
        }
        else {
            retroView.wrongPhrase = nil
        }
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
            let storedScore = dictionary.object(forKey: "catchup")! as! Int
            if storedScore < score {
                let newDictionary:NSDictionary = [
                    "freefall": dictionary.object(forKey: "freefall")! as! Int,
                    "swiping": dictionary.object(forKey: "swiping")! as! Int,
                    "catchup": score,
                    ]
                newDictionary.write(toFile: dataFilePath(), atomically: true)
            }
        }
    }
    
}
