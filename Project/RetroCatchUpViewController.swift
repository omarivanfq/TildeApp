import UIKit

class RetroCatchUpViewController: UIViewController {

    var score: Int!
    @IBOutlet weak var lbScore: UILabel!
    
    var wrongPhrase: String!
    var correctPhrase: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbScore.text = "\(score!)"
    }

}
