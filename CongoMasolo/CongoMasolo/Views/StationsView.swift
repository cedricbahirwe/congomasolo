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
                
                logUserActivity(userActivity, label: "on activity")
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

struct NavigationStackModifier<Item, Destination: View>: ViewModifier {
    let item: Binding<Item?>
    let destination: (Item) -> Destination

    func body(content: Content) -> some View {
        content.background(NavigationLink(isActive: item.mappedToBool()) {
            if let item = item.wrappedValue {
                destination(item)
            } else {
                EmptyView()
            }
        } label: {
            EmptyView()
        })
    }
}

extension View {
    func navigationDestination<Item, Destination: View>(
        forItem binding: Binding<Item?>,
        @ViewBuilder destination: @escaping (Item) -> Destination
    ) -> some View {
        self.modifier(NavigationStackModifier(item: binding, destination: destination))
    }
}

extension Binding where Value == Bool {
    init<Wrapped>(bindingOptional: Binding<Wrapped?>) {
        self.init(
            get: {
                bindingOptional.wrappedValue != nil
            },
            set: { newValue in
                guard newValue == false else { return }

                /// We only handle `false` booleans to set our optional to `nil`
                /// as we can't handle `true` for restoring the previous value.
                bindingOptional.wrappedValue = nil
            }
        )
    }
}

extension Binding {
    func mappedToBool<Wrapped>() -> Binding<Bool> where Value == Wrapped? {
        return Binding<Bool>(bindingOptional: self)
    }
}
