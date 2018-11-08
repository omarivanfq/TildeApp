import UIKit

class RetroCatchUpViewController: UIViewController {
 /*
    var score: Int!
    @IBOutlet weak var lbScore: UILabel!
    var game: CatchUpViewController!
    
    @IBAction func playAgain(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        game.restart()
    }
    
    var wrongPhrase: String!
    var correctPhrase: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbScore.text = "\(score!)"
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
            let storedScore = dictionary.object(forKey: "catchup")! as! Int
            if storedScore < score {
                let newDictionary:NSDictionary = [
                    "freefall": dictionary.object(forKey: "swiping")! as! Int,
                    "swiping": dictionary.object(forKey: "swiping")! as! Int,
                    "catchup": score,
                    ]
                newDictionary.write(toFile: dataFilePath(), atomically: true)
            }
        }
    }
 */

}
