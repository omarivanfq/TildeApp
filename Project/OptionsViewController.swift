import UIKit
import AVFoundation

class OptionsViewController: UIViewController {

    var player: AVAudioPlayer?
    
    @IBOutlet weak var switchMusic: UISwitch!
    
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeMusic(_ sender: UISwitch) {
        if sender.isOn {
            player?.play()
        }
        else {
            player?.stop()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if player!.isPlaying {
            switchMusic.isOn = true
        }
        else {
            switchMusic.isOn = false
        }
    }

}
