//
//  StationsView.swift
//  CongoMasolo
//
//  Created by Cédric Bahirwe on 05/09/2023.
//

import SwiftUI


struct StationsView: View {
    @EnvironmentObject
    private var stationsVM: StationsViewModel
    
    @State private var showAboutView = false
    @State private var selectedStation: RadioStation?

    var body: some View {
        NavigationStack {
            List {
                if stationsVM.activityIndicator.isAnimating() {
                    placeholderView
                } else {
                    ForEach(stationsVM.stations) { station in
                        NavigationLink(value: station) {
                            StationRow(station: station)
                        }
                    }
                }
            }
            .overlay {
                if stationsVM.activityIndicator.isAnimating() {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding(20)
                        .background(.regularMaterial)
                        .cornerRadius(15)
                        .scaleEffect(2)
                } else if let error = stationsVM.errorMessage {
                    Text(error)
                        .fontWeight(.medium)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .navigationTitle("Masolo Radio")
            .sheet(isPresented: $showAboutView, content: AboutView.init)
            .navigationDestination(for: RadioStation.self, destination: RadioPlayerView.init)
            .navigationDestination(forItem: $selectedStation, destination: { station in
                RadioPlayerView.init(station)
                
            })
            .onContinueUserActivity(Config.radioActivity) { userActivity in
                if let dictionary = userActivity.userInfo as? [String: Any] {
                    selectedStation = RadioStation(dictionary: dictionary)
                }                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showAboutView.toggle()
                    } label: {
                        Image(systemName: "info.circle")
                            .imageScale(.large)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if stationsVM.stationNowPlayingButtonEnabled {
                        NavigationLink {
                            RadioPlayerView(stationsVM.currentStation)
                        } label: {
                            Image("btn-nowPlaying")
                                .imageScale(.large)
                        }
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                bottomBarView
            }
            .task {
                await stationsVM.fetchStations()
            }
        }
    }
    
    private var placeholderView: some View {
        GroupBox {
            ForEach(0..<10, id: \.self) { _ in
                StationRow(station: RadioStation(name: "", streamURL: "", imageURL: "", desc: "", longDesc: "", wesbite: ""))
            }
        }
        .redacted(reason: .placeholder)
    }
    
    private var bottomBarView: some View {
        NavigationLink {
            RadioPlayerView(stationsVM.currentStation)
        } label: {
            HStack(spacing: 8) {
                Image("NowPlayingBars")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                
                Text(stationsVM.stationNowPlayingButtonTitle)
                Spacer()
            }
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            .foregroundColor(Color(red: 128/255, green: 128/255, blue: 128/255))
            .frame(maxWidth: .infinity)
            .padding()
            .frame(height: 44)
            .background(
                Color.black
                    .ignoresSafeArea(edges: .bottom)
            )
            .containerShape(Rectangle())
        }
        .disabled(stationsVM.currentStation==nil)
    }

}

struct StationsView_Previews: PreviewProvider {
    static var previews: some View {
        StationsView()
            .environmentObject(StationsViewModel())
            .preferredColorScheme(.dark)
    }
}

struct ActivityIndicator: Identifiable {
    private(set) var animating: Bool = false
    
    var id: Bool { animating }
    
    mutating func start() {
        animating = true
    }
    
    mutating func stop() {
        animating = false
    }
    
    func isAnimating() -> Bool {
        animating
    }
}
