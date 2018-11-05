import UIKit

class FreeFallViewController: UIViewController {
    
    @IBOutlet weak var btnOption1: UIButton!
    @IBOutlet weak var btnOption2: UIButton!
    @IBOutlet weak var btnOption3: UIButton!
    @IBOutlet weak var btnOption4: UIButton!
    @IBOutlet weak var btnOption5: UIButton!
    @IBOutlet weak var lbScore: UILabel!
    var score:Int!
    
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
            lbResult.text = "¡Que mal!"
            gameOver = true
            goToRetro(timeOver: false)
        }
    }
    
    var option:Option?
    var options = [Option]()
    
    var timeCount:Int?
    var timer = Timer()
    var actTimer = Timer()
    var buttons = [UIButton]()
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
        timeCount = 20
        score = 0
        lbTimer.text = secondsToString(seconds: timeCount!)
        gameOver = false
        lbResult.alpha = 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(counter), userInfo: nil, repeats: true)
        actTimer = Timer.scheduledTimer(timeInterval: 0.007, target: self, selector: #selector(act), userInfo: nil, repeats: true)
        getData()
        setButtons()
        setOptions()
        restartPosition()
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
        for label in buttons {
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
        let retroView = self.storyboard?.instantiateViewController(withIdentifier: "RetroFreeFallViewController") as! RetroFreeFallViewController
        retroView.score = score
        if !timeOver {
            retroView.wrongPhrase = currentPhrase
            retroView.solution = solution
        }
        else {
            retroView.wrongPhrase = nil
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}



