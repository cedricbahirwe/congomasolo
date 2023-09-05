//
//  RadioPlayerView.swift
//  CongoMasolo
//
//  Created by Cédric Bahirwe on 05/09/2023.
//

import SwiftUI
import MediaPlayer

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
                        value: $radioManager.volume,
                        in: radioManager.volumRange,
                        step: radioManager.volumeStep
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
        .navigationBarTitleDisplayMode(.inline)
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
        }
    }
}
#endif
