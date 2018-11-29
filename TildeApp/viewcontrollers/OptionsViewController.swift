import UIKit
import AVFoundation

class OptionsViewController: UIViewController {

    var player: AVAudioPlayer?
    var viewPrincipal : ViewController!
    @IBOutlet weak var switchMusic: UISwitch!
    
    @IBOutlet weak var switchEffects: UISwitch!
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
    
    @IBAction func changeEffects(_ sender: UISwitch) {
        viewPrincipal.wantSoundEffects = sender.isOn
        updateOptions()
    }
    
    @IBAction func changeVibration(_ sender: UISwitch) {
        viewPrincipal.wantVibration = sender.isOn
        updateOptions()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice.current.userInterfaceIdiom == .pad {
            switchMusic.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            switchEffects.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            switchVibration.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }
        switchMusic.isOn = player!.isPlaying
        switchVibration.isOn = viewPrincipal.wantVibration
        switchEffects.isOn = viewPrincipal.wantSoundEffects
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
            "vibration": switchVibration.isOn,
            "soundEffect": switchEffects.isOn
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
