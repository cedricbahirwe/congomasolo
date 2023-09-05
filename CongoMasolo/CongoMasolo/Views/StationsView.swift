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
                    Text(station.name)
                }
            }
            .background(.red)
            .navigationTitle("Congo Radio")
            .sheet(isPresented: $showAboutView) {
                AboutView()
            }
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
            .task {
                await stationsVM.fetchStations()
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
