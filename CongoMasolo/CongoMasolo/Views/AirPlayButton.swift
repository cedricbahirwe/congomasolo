//
//  AirPlayButton.swift
//  CongoMasolo
//
//  Created by Cédric Bahirwe on 05/09/2023.
//

import SwiftUI
import MediaPlayer

struct AirPlayButton: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<AirPlayButton>) -> UIViewController {
        return AirPLayViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<AirPlayButton>) {

    }
}

fileprivate class AirPLayViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let button = UIButton()
        let boldConfig = UIImage.SymbolConfiguration(scale: .large)
        let boldSearch = UIImage(systemName: "airplayaudio", withConfiguration: boldConfig)
        
        button.setImage(boldSearch, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.tintColor = UIColor(Color.accentColor)
        
        button.addTarget(self, action: #selector(self.showAirPlayMenu(_:)), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    @objc func showAirPlayMenu(_ sender: UIButton) {
        let rect = CGRect(x: 0, y: 0, width: 0, height: 0)
        let airplayVolume = MPVolumeView(frame: rect)
        airplayVolume.showsVolumeSlider = false
        self.view.addSubview(airplayVolume)
        for view: UIView in airplayVolume.subviews {
            if let button = view as? UIButton {
                button.sendActions(for: .touchUpInside)
                break
            }
        }
        airplayVolume.removeFromSuperview()
    }
}
