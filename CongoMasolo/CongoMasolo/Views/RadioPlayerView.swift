//
//  RadioPlayerView.swift
//  CongoMasolo
//
//  Created by Cédric Bahirwe on 05/09/2023.
//

import SwiftUI
import MediaPlayer

@MainActor
class RadioPlayerManager: ObservableObject {
//    @Published var station: RadioStation
    @Published var isNewStation: Bool = false
    
    var currentStation: RadioStation? {
        manager.currentStation
    }
    
    @Published var albumImage: UIImage?
    @Published var stationDesc: String?
    @Published var stationDescIsHidden: Bool = true
    
    
    
    @Published var songLabel: String?
    @Published var artistLabel: String?
    
    private let player = FRadioPlayer.shared
    private let manager = StationsManager.shared
    
    init(_ station: RadioStation) {
        self.isNewStation = isNewStation
        
        isNewStation = station != manager.currentStation
        if isNewStation {
            manager.set(station: station)
        }
        
        performSetup()
    }
    
    func performSetup() {
        // Check for station change
        if isNewStation {
            stationDidChange()
        } else {
            updateTrackArtwork()
            //            playerStateDidChange(player.state, animate: false)
        }
    }
    
    
    func stationDidChange() {
        albumImage = nil
        Task {
            albumImage = await manager.currentStation?.getImage()
        }
        stationDesc = manager.currentStation?.desc
        stationDescIsHidden = player.currentArtworkURL != nil
        updateLabels()
    }
    
    func updateLabels(with statusMessage: String? = nil, animate: Bool = true) {
        
        guard let statusMessage = statusMessage else {
            // Radio is (hopefully) streaming properly
            songLabel = manager.currentStation?.trackName
            artistLabel = manager.currentStation?.artistName
            //            shouldAnimateSongLabel(animate)
            return
        }
        
        // There's a an interruption or pause in the audio queue
        
        // Update UI only when it's not aleary updated
        guard songLabel != statusMessage else { return }
        
        songLabel = statusMessage
        artistLabel = manager.currentStation?.name
        
        //        if animate {
        //            songLabel.animation = "flash"
        //            songLabel.repeatCount = 2
        //            songLabel.animate()
        //        }
    }
    
    // Update track with new artwork
    func updateTrackArtwork() {
        guard let artworkURL = player.currentArtworkURL else {
            Task {
                self.albumImage = await manager.currentStation?.getImage()
            }
            //            manager.currentStation?.getImage { [weak self] image in
            //                self?.albumImageView.image = image
            //                self?.stationDescLabel.isHidden = false
            //            }
            return
        }
        
        //        albumImageView.load(url: artworkURL) { [weak self] in
        //            self?.albumImageView.animation = "wobble"
        //            self?.albumImageView.duration = 2
        //            self?.albumImageView.animate()
        //            self?.stationDescLabel.isHidden = true
        //
        //            // Force app to update display
        //            self?.view.setNeedsDisplay()
        //        }
    }
    
    
    func setupVolumeSlider() {
        
    }
    
}

struct RadioPlayerView: View {
    @StateObject private var radioManager: RadioPlayerManager
    
    init(_ station: RadioStation) {
        self._radioManager = StateObject(wrappedValue: RadioPlayerManager(station))
    }
    
//    @State private var image: Image?
    @State private var volume = 0.5

    var body: some View {
        ZStack {
            Group {
                Color.red
                Color.green.padding(50)
                    .position()
                
                Color.blue.padding(50)
                    .position(x: 52, y: 500)
                Ellipse()
                    .fill(Color.black.opacity(0.5))
                    .ignoresSafeArea().blur(radius: 150)
                    .background(.ultraThickMaterial)
            }
//            .colorInvert()
            
            VStack {
                Image(uiImage: radioManager.albumImage ?? UIImage(named: "stationImage")!)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 250, minHeight: 180)
                    .cornerRadius(20)
                    .shadow(color: .black,
                            radius: 2,
                            x: 0, y: 1)
                    .overlay {
                        if let description = radioManager.currentStation?.desc {
                            Text(description)
                                .frame(height: 21)
                                .opacity(0.8)
                        }
                    }
                    .padding(.top, 50)
                
                
                HStack(spacing: 12) {
                    Button {
                        
                    } label: {
                        Image("btn-previous")
                            .resizable()
                            .frame(width: 45, height: 45)
                    }
                    
                    Button {
                        
                    } label: {
                        Image("btn-play")
                            .resizable()
                            .frame(width: 45, height: 45)
                    }
                    
                    Button {
                        
                    } label: {
                        Image("btn-stop")
                            .resizable()
                            .frame(width: 45, height: 45)
                    }
                    
                    Button {
                        
                    } label: {
                        Image("btn-next")
                            .resizable()
                            .frame(width: 45, height: 45)
                    }
                    
                }
                .padding(.top, 30)
                .padding(.bottom, 12)
                
                
                HStack {
                    Slider(
                        value: $volume,
                        in: 0...1,
                        step: 0.1
                    ) {
                        Text("Values from 0 to 100")
                    } minimumValueLabel: {
                        Text("\(Image(systemName: "speaker.slash.fill"))")
                    } maximumValueLabel: {
                        Text("\(Image(systemName: "speaker.wave.3.fill"))")
                    } onEditingChanged: { editing in
                    }
                }
                .frame(height: 60)
                .padding(.vertical)
                
                VStack(spacing: 8) {
//                    Text(station.trackName)
//                        .font(.title)
                    
//                    Text(station.artistName)
//                        .font(.title3)
                }
                .multilineTextAlignment(.center)
                
                Spacer()
                
                HStack {
                    Text("APP LOGO").bold()
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "airplayaudio")
                            .imageScale(.large)
                    }
                    
                    Spacer()
                    
                    HStack(alignment: .bottom, spacing: 15) {
                        Button {
                            
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                                .imageScale(.large)
                        }
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "info.circle")
                                .imageScale(.large)
                        }

                    }
                    .tint(.primary)
                }
            }
            .padding()
        }
        .navigationTitle(radioManager.currentStation?.name ?? "")
        .preferredColorScheme(.dark)
        .task {
//            if let uiImage = await radioManager.currentStation?.getImage() {
//                self.image = Image(uiImage: uiImage)
//            }
        }
    }
}



#if DEBUG
struct RadioPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RadioPlayerView(.example)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
#endif
