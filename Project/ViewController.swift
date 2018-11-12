import UIKit
import AVFoundation

class ViewController: UIViewController {

    var player: AVAudioPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        playMusic()
    }

    func playMusic() {
        let url = Bundle.main.url(forResource: "the-ting-tings-earthquake-official-audio", withExtension: "mp3")!
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.numberOfLoops = -1
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toOptions" {
            let view = segue.destination as! OptionsViewController
            view.player = player
        }
    }
    
}

// https://www.quora.com/How-should-I-add-background-music-in-Swift-playground-not-a-project
