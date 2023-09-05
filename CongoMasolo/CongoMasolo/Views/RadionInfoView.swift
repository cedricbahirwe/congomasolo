//
//  RadionInfoView.swift
//  CongoMasolo
//
//  Created by Cédric Bahirwe on 05/09/2023.
//

import SwiftUI

struct RadionInfoView: View {
    let station: RadioStation
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var image: Image?

    var body: some View {
        ZStack {
            BlurredBackground()
            
            VStack(alignment: .leading) {
                HStack(spacing: 8) {
                    (image ?? Image("stationImage"))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 110)
                        .frame(height: 70)
                        .clipped()
                        .shadow(color: .black,
                                radius: 0.5,
                                x: 0, y: 1)
                    
                    
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(station.name)
                            .font(.headline)
                        
                        Text(station.name)
                            .font(.subheadline)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Group {
                    if station.longDesc.isEmpty {
                        Text("Vous écoutez Congo Masolo. Parlez-en à vos amis,!!!")
                    } else {
                        Text(station.longDesc)
                    }
                }
                .padding(.top)
                
                Spacer()
                
                OkayButton {
                    dismiss()
                }
            }
            .padding()
            .foregroundColor(.white)
        }
        .task {
            self.image = Image(uiImage: await station.getImage())
        }
    }
}

struct OkayButton: View {
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text("Okay")
                .padding()
                .frame(height: 48)
                .frame(maxWidth: .infinity)
                .background(Color(red: 51/255, green: 51/255, blue: 53/255))
                .cornerRadius(15)
                .shadow(color: .white.opacity(0.2), radius: 0.1, x: 0, y: 1)
        }
    }
}

#if DEBUG
struct RadionInfoView_Previews: PreviewProvider {
    static var previews: some View {
        RadionInfoView(station: .example)
    }
}
#endif

