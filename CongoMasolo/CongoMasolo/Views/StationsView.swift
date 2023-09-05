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
    
    var body: some View {
        NavigationStack {
            List {
                if let error = stationsVM.errorMessage {
                    Text(error)
                        .fontWeight(.medium)
                        .foregroundColor(.red)
                }
                ForEach(stationsVM.stations) { station in
                    NavigationLink(value: station) {
                        StationRow(station: station)
                    }
                }
            }
            .background(.red)
            .navigationTitle("Congo Radio")
            .sheet(isPresented: $showAboutView, content: AboutView.init)
            .navigationDestination(for: RadioStation.self, destination: RadioPlayerView.init)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showAboutView.toggle()
                    } label: {
                        Image(systemName: "list.bullet")
                            .imageScale(.large)
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                HStack(spacing: 8) {
                    Image("NowPlayingBars")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    
                    Text("Sélectionnez une station pour commencer")
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
            }
            .task {
                await stationsVM.fetchStations()
                print(stationsVM.stations[0])
            }
        }
    }
}

struct StationsView_Previews: PreviewProvider {
    static var previews: some View {
        StationsView()
            .environmentObject(StationsViewModel())
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

@MainActor
final class StationsViewModel: ObservableObject {
    @Published var stations: [RadioStation] = []
    
    @Published var activityIndicator = ActivityIndicator()
    
    @Published var errorMessage: String?
    
    let manager = StationsManager.shared
    
    
    func fetchStations() async {
        activityIndicator.start()
        
        do {
            let resultStations = try await manager.fetch()
            activityIndicator.stop()
            
            self.stations = resultStations
            //            self.delegate?.didFinishLoading(self, stations: stations)
        } catch {
            self.activityIndicator.stop()
            self.handle(error)
        }
    }
    
    private func handle(_ error: Error) {
        errorMessage = error.localizedDescription
    }
    
    func handleRetrial() {
        Task {
            await fetchStations()
        }
    }
}
