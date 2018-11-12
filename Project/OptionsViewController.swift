import UIKit
import AVFoundation

class OptionsViewController: UIViewController {

    var player: AVAudioPlayer?
    
    @IBOutlet weak var switchMusic: UISwitch!
    
    @IBOutlet weak var switchVibration: UISwitch!
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        updateOptions()
    }
    
    @IBAction func changeMusic(_ sender: UISwitch) {
        if sender.isOn {
            player?.play()
        }
        else {
            player?.stop()
        }
        updateOptions()
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
    
    func dataOptionsFilePath() -> String {
        let url = FileManager().urls(for: .documentDirectory,
                                     in: .userDomainMask).first!
        let pathArchivo =
            url.appendingPathComponent("options.plist")
        return pathArchivo.path
    }
    
    func updateOptions() {
        let filePath = dataOptionsFilePath()
        let newDictionary:NSDictionary = [
            "music": switchMusic.isOn,
            "vibration": switchVibration.isOn
        ]
        newDictionary.write(toFile: filePath, atomically: true)
    }

}
