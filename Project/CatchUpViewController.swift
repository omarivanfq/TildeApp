import UIKit

class CatchUpViewController: UIViewController {

    var arregloDiccionarios : NSArray!
    var upCorrect: Bool!
    var upPhrase: String!
    var downPhrase: String!
    var score:Int!

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
        restart()
    }

    func restart() {
        score = 0
        getData()
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
        let retroView = self.storyboard?.instantiateViewController(withIdentifier: "RetroCatchUpViewController") as! RetroCatchUpViewController
        retroView.score = score
        present(retroView, animated: true, completion: nil)
    }
    
}
