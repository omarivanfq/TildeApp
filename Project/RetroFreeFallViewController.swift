import UIKit

class RetroFreeFallViewController: UIViewController {

    var score:Int!
    @IBOutlet weak var lbScore: UILabel!
    @IBOutlet weak var lbWrongPhrase: UILabel!
    @IBOutlet weak var lbSolution: UILabel!
    var wrongPhrase:String!
    var solution:String!
    
    @IBOutlet weak var lbTimeOver: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbScore.text = "\(score!)"
        if wrongPhrase != nil {
            lbWrongPhrase.text = wrongPhrase
            lbSolution.text = solution
            lbTimeOver.alpha = 0
        }
        else {
            lbTimeOver.alpha = 1
            lbWrongPhrase.text = "Time Over!!"
            lbSolution.text = ""
        }
        updateScore()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
