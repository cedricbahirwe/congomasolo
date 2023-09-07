//
//  AboutView.swift
//  CongoMasolo
//
//  Created by Cédric Bahirwe on 05/09/2023.
//

import SwiftUI

struct AboutView: View {
    
    private let appVersion = Bundle.main.appVersion ?? ""
    private let buildVersion = Bundle.main.buildVersion ?? ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 30) {
            VStack {
                Image("appicon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .cornerRadius(15)
                
                Text("Congo Masolo")
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.bold)
            }
            .padding(.top, 30)
            
            Text("Version actuelle: \(appVersion) (\(buildVersion))")
                .fontWeight(.bold)
            
            VStack(spacing: 4) {
                Text("Conçu et développé par")
                    .foregroundColor(.secondary)
                Link("Cedric Bahirwe.", destination: URL(string: Config.linkedIn)!)
                    .foregroundColor(Color.blue)
            }
            .font(.body.weight(.semibold))
            
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Remerciements")
                        .font(.headline)
                    
                    Group {
                        Link("- Aristote Mokekwa \(Image(systemName: "arrow.up.right.square"))", destination: URL(string: Config.aristoteInsta)!)
                        
                        Link("- Fethi El Hassasna \(Image(systemName: "arrow.up.right.square"))", destination: URL(string: Config.sdkLink)!)
                        
                        Text("- La Famille Bahirwe")
                    }
                    .foregroundColor(Color.blue)
                  
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.ultraThinMaterial)
                .cornerRadius(15)
            }
            
            VStack(spacing: 15) {
                Link(destination: URL(string:  Config.stationRequest)!) {
                    Text("Demander une station de radio")
                        .padding()
                        .frame(height: 48)
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .foregroundColor(Color(red: 51/255, green: 51/255, blue: 53/255))
                        .cornerRadius(15)
                        .shadow(color: .white.opacity(0.2), radius: 0.1, x: 0, y: 1)
                }
                OkayButton {
                    dismiss()
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(BlurredBackground())
        .navigationBarTitle("À propos")
        .preferredColorScheme(.dark)
    }
}
struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
