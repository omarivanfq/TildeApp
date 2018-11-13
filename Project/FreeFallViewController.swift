import UIKit

class FreeFallViewController: UIViewController, Game {
    
    @IBOutlet weak var btnOption1: UIButton!
    @IBOutlet weak var btnOption2: UIButton!
    @IBOutlet weak var btnOption3: UIButton!
    @IBOutlet weak var btnOption4: UIButton!
    @IBOutlet weak var btnOption5: UIButton!
    @IBOutlet weak var lbScore: UILabel!
    
    var score:Int!
    var gameStarted:Bool!
    var option: Option?
    var options = [Option]()
    var timeCount:Int?
    var timer = Timer()
    var actTimer = Timer()
    var buttons = [UIButton]()
    var solution:String?
    var currentPhrase:String?
    var optionWords = [String]()
    var gameOver:Bool?
    var detail:UIView!
    
    @IBOutlet weak var infoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoButton.tintColor = UIColor.white
        gameStarted = false
        setButtons()
        restart()
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        timer.invalidate()
        actTimer.invalidate()
    }
    
    @IBAction func chooses(_ sender: UIButton) {
        let opcion = sender.titleLabel?.text!
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        lbResult.frame.origin.x = screenWidth * 0.5 - lbResult.frame.width * 0.5
        lbResult.frame.origin.y = screenHeight * 0.5 - lbResult.frame.height * 0.5
        if (opcion == solution!) {
            showCongratsLabel()
            restartPosition()
            getData() // recuperando nueva info
            options.removeAll()
            setOptions()
            score = score + 1
            lbScore.text = "\(score!)"
        }
        else {
            gameOver = true
            goToRetro(timeOver: false)
        }
    }
    
    @IBAction func action(_ sender: Any) {
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
        tv.text = tv.text + "Selecciona la palabra que complete correctamente el enunciado que aparece en la parte inferior de la pantalla.\nPor cada elección correcta obtendrás un punto pero al primer error termina el juego."
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
        actTimer.invalidate()
    }
    
    @IBOutlet weak var lbPhrase: UILabel!
    @IBOutlet weak var lbResult: UILabel!
    @IBOutlet weak var lbTimer: UILabel!
    var arregloDiccionarios : NSArray!
    
    func restart() {
        timeCount = 3
        score = 0
        lbTimer.text = secondsToString(seconds: timeCount!)
        lbScore.text = "0"
        gameOver = false
        lbResult.alpha = 0
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(letsStartPlaying), userInfo: nil, repeats: true)
        getData()
        setOptions()
        restartPosition()
        hideButtons()
    }
    
    @objc func letsStartPlaying() {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(counter), userInfo: nil, repeats: true)
        actTimer = Timer.scheduledTimer(timeInterval: 0.007, target: self, selector: #selector(act), userInfo: nil, repeats: true)
        showButtons()
        gameStarted = true
    }
    
    @objc func continuePlaying(sender: UIButton!) {
        detail.removeFromSuperview()
        if !gameStarted {
            showButtons()
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(counter), userInfo: nil, repeats: true)
        actTimer = Timer.scheduledTimer(timeInterval: 0.007, target: self, selector: #selector(act), userInfo: nil, repeats: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setButtons(){
        buttons.append(btnOption1)
        buttons.append(btnOption2)
        buttons.append(btnOption3)
        buttons.append(btnOption4)
        buttons.append(btnOption5)
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
        optionWords.removeAll()
        for op in optionsArray! {
            optionWords.append(op)
        }
        solution = sol
    }
    
    func setOptions() {
        var c = 0
        options.removeAll()
        for button in buttons {
            options.append(Option(content: optionWords[c], button: button))
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
            goToRetro(timeOver: true)
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
    
    func goToRetro(timeOver:Bool) {

        updateScore()
        timer.invalidate()
        actTimer.invalidate()
        
        let retroView = self.storyboard?.instantiateViewController(withIdentifier: "RetroFreeFallViewController") as! RetroFreeFallViewController
        
        /*
        let retroView = self.storyboard?.instantiateViewController(withIdentifier: "back") as! BackViewController
         */
        
       // retroView.game = self
        
        retroView.score = score
        retroView.game = self
        if !timeOver {
            retroView.wrongPhrase = currentPhrase
            retroView.solution = solution
            retroView.source = 1
        }
        else {
            retroView.wrongPhrase = nil
            retroView.source = 1
        }
        
        present(retroView, animated: true, completion: nil)
    }
    
    func restartPosition() {
        for option in options {
            option.reallocate()
        }
    }
    
    func showCongratsLabel(){
        UIView.animate(withDuration: 0.5, animations: {
            self.lbResult.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 1.2, animations: {
                self.lbResult.alpha = 0
            })
        })
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
             let storedScore = dictionary.object(forKey: "freefall")! as! Int
             if storedScore < score {
             let newDictionary:NSDictionary = [
                 "freefall": score,
                 "swiping": dictionary.object(forKey: "swiping")! as! Int,
                 "catchup": dictionary.object(forKey: "catchup")! as! Int,
             ]
             newDictionary.write(toFile: dataFilePath(), atomically: true)
             }
         }
    }
    
    func hideButtons() {
        for button in buttons {
            button.alpha = 0
        }
    }
    
    func showButtons() {
        for button in buttons {
            button.alpha = 1
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
}



