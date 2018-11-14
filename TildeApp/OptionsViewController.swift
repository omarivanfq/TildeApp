import UIKit
import AVFoundation

class OptionsViewController: UIViewController {

    var player: AVAudioPlayer?
    var viewPrincipal : ViewController!
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
    
    @IBAction func changeVibration(_ sender: UISwitch) {
        viewPrincipal.wantVibration = sender.isOn
        updateOptions()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switchMusic.isOn = player!.isPlaying
        switchVibration.isOn = viewPrincipal.wantVibration
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

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
}
