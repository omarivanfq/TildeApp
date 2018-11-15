import UIKit
import AVFoundation

class ViewController: UIViewController {

    var player: AVAudioPlayer?
    var wantVibration : Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        setMusic()
        getOptions()
    }

    func setMusic() {
        let url = Bundle.main.url(forResource: "the-ting-tings-earthquake-official-audio", withExtension: "mp3")!
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.numberOfLoops = -1
            player.prepareToPlay()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toOptions" {
            let view = segue.destination as! OptionsViewController
            view.player = player
            view.viewPrincipal = self
        }
    }
    
    func dataOptionsFilePath() -> String {
        let url = FileManager().urls(for: .documentDirectory,
                                     in: .userDomainMask).first!
        let pathArchivo =
            url.appendingPathComponent("options.plist")
        return pathArchivo.path
    }
    
    func getOptions() {
        let filePath = dataOptionsFilePath()
        if FileManager.default.fileExists(atPath: filePath) {
            let dictionary = NSDictionary(contentsOfFile: filePath)!
            let musicPlaying = dictionary.object(forKey: "music") as! Bool
            wantVibration = (dictionary.object(forKey: "vibration") as! Bool)
            if musicPlaying {
                player!.play()
            }
        }
        else {
            wantVibration = true
            player!.play()
        }
    }
    
}

// https://www.quora.com/How-should-I-add-background-music-in-Swift-playground-not-a-project
// https://stackoverflow.com/questions/26455880/how-to-make-iphone-vibrate-using-swift
