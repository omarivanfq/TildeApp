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
    var playerCorrect: AVAudioPlayer?
    var playerWrong: AVAudioPlayer?
    var playerTimeOver: AVAudioPlayer?

    var detail:UIView!
    @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet weak var lbScore: UILabel!
    @IBOutlet weak var btnUpPhrase: UIButton!
    @IBOutlet weak var btnDownPhrase: UIButton!
    
    @IBAction func howToPlay(_ sender: UIButton) {
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
        tv.text = tv.text + "¡Este juego lo puedes jugar con tus amigos!\nEn pantalla se muestran dos frases, el jugador debe seleccionar la correcta y pasar el dispositivo al siguiente jugador para que haga lo mismo.\n¡El tiempo del juego puede terminar en cualquier momento y quien tenga el dispositivo en sus manos pierde!"
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
    
    @objc func continuePlaying(sender: UIButton!) {
        detail.removeFromSuperview()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(counter), userInfo: nil, repeats: true)
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        timer.invalidate()
    }
    
    @IBAction func choosesUp(_ sender: Any) {
        if (upCorrect) {
            getData()
            score = score + 1
            lbScore.text = "\(score!)"
            playerCorrect!.play()
        }
        else {
            playerWrong!.play()
            goToRetro(timeOver: false)
        }
    }
    
    @IBAction func choosesDown(_ sender: Any) {
        if (!upCorrect) {
            getData()
            score = score + 1
            lbScore.text = "\(score!)"
            playerCorrect!.play()
        }
        else {
            playerWrong!.play()
            goToRetro(timeOver: false)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        infoButton.tintColor = UIColor.white
        restart()
        setSoundEffectPlayers()
    }

    @objc func counter() {
        if timeCount == 0 {
            goToRetro(timeOver: true)
        }
        else {
            timeCount = timeCount! - 1
        }
    }
    
    func restart() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(counter), userInfo: nil, repeats: true)
        score = 0
        timeCount = Int.random(in: 35...80)
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
            playerTimeOver!.play()
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
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
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
    
}
