//
//  RadioPlayerView.swift
//  CongoMasolo
//
//  Created by Cédric Bahirwe on 05/09/2023.
//

import SwiftUI
import AVKit

struct RadioPlayerView: View {
    @StateObject private var radioManager: RadioPlayerManager
    
    init(_ station: RadioStation) {
        self._radioManager = StateObject(wrappedValue: RadioPlayerManager(station))
    }
    
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
            
            VStack {
                Image(uiImage: radioManager.albumImage ?? UIImage(named: "stationImage")!)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 250, minHeight: 180)
                    .cornerRadius(20)
                    .shadow(color: .black, radius: 2, x: 0, y: 1)
                    .overlay(alignment: .bottom) {
                        if let description = radioManager.currentStation?.desc {
                            Text(description)
                                .frame(height: 21)
                                .opacity(0.8)
                        }
                    }
                    .padding(.top, 50)
                
                
                HStack(spacing: 12) {
                    if !radioManager.previousButtonHidden {
                        Button {
                            radioManager.previousPressed()
                        } label: {
                            Image("btn-previous")
                                .resizable()
                                .frame(width: 45, height: 45)
                        }
                    }
                    
                    Button {
                        radioManager.playingPressed()
                    } label: {
                        Image(radioManager.playingButtonSelected ? "btn-pause" : "btn-play")
                            .resizable()
                            .frame(width: 45, height: 45)
                    }
                    
                    Button {
                        radioManager.stopPressed()
                    } label: {
                        Image("btn-stop")
                            .resizable()
                            .frame(width: 45, height: 45)
                    }
                    
                    if !radioManager.nextButtonHidden {
                        Button {
                            radioManager.nextPressed()
                        } label: {
                            Image("btn-next")
                                .resizable()
                                .frame(width: 45, height: 45)
                        }
                    }
                }
                .padding(.top, 30)
                .padding(.bottom, 12)
                
                
                if radioManager.mpVolumSliderValue != nil {
                    HStack {
                        Image(systemName: "speaker.slash.fill")
                        SliderView(slider: radioManager.mpVolumSliderValue!)
                        Image(systemName: "speaker.wave.3.fill")
                    }
                    .frame(height: 60)
                    .padding(.vertical)
                }
                
                
                VStack(spacing: 8) {
                    if let songLabel = radioManager.songLabel {
                        Text(songLabel)
                            .font(.title)
                    }
                    
                    if let artistName = radioManager.artistLabel {
                        Text(artistName)
                            .font(.title3)
                    }
                }
                .multilineTextAlignment(.center)
                
                Spacer()
                
                HStack {
                    Text("APP LOGO").bold()
                    
                    Spacer()
                    
                    AirPlayButton()
                        .frame(width: 45, height: 45)
                    
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
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
        .toolbar {
            Button {
                
            } label: {
                Label("Now Playing", image: "NowPlayingBars-3")
            }
        }
    }
}

#if DEBUG
struct RadioPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RadioPlayerView(.example)
        }
    }
}
#endif


struct SliderView: UIViewRepresentable {
    let slider: UISlider
    
    func makeUIView(context: Context) -> UISlider {
        return slider
    }
    
    func updateUIView(_ uiView: UISlider, context: Context) {
        
    }
    
}
