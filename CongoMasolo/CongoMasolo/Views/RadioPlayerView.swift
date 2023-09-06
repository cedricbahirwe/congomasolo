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
    
    init(_ station: RadioStation?) {
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
                        if radioManager.stationDescHidden == false,
                           let stationDesc = radioManager.stationDesc  {
                            Text(stationDesc)
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
                        VolumeSliderView(slider: radioManager.mpVolumSliderValue!)
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
                .lineLimit(2)
                .minimumScaleFactor(0.7)
                .animation(.easeInOut, value: radioManager.playingButtonSelected)
                
                Spacer()
                
                HStack(alignment: .center) {
                    Image("appicon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .cornerRadius(6)
                        .onTapGesture {
                            radioManager.handleCompanyButton()
                        }
                    
                    
                    Spacer(minLength: 0)
                    
                    HStack(alignment: .center, spacing: 20) {
                        if let station = radioManager.currentStation {
                            Button {
                                radioManager.shareButtonPressed()
                            } label: {
                                Image(systemName: "square.and.arrow.up")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                            }
                            
                            
                            NavigationLink {
                                RadionInfoView(station: station)
                            } label: {
                                Image(systemName: "info")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18, height: 18)
                                    .padding(4)
                                    .overlay {
                                        Circle()
                                            .stroke(Color.white, lineWidth: 1.5)
                                    }
                                    .frame(width: 30, height: 30)
                            }
                        }
                        
                    }
                }
                .overlay(alignment: .center) {
                    AirPlayButton()
                        .frame(width: 35, height: 35)
                        .scaleEffect(1.4)
                }
            }
            .padding()
        }
        .sheet(isPresented: $radioManager.showAboutView, content: AboutView.init)
        .userActivity(Config.radioActivity,
                      element: radioManager.currentStation,
                      updateHandoffUserActivity)
        .navigationTitle(radioManager.stationTitle ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func updateHandoffUserActivity(station: RadioStation, _ activity: NSUserActivity) {
        if let dictionary = station.dictionary {
            activity.addUserInfoEntries(from: dictionary)
        }
    }
}

#if DEBUG
struct RadioPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RadioPlayerView(.example)
                .preferredColorScheme(.dark)
        }
    }
}
#endif
