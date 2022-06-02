//
//  QRView.swift
//  Autherio
//
//  Created by Kamil Kozioł on 03/06/2022.
//

import SwiftUI

struct QRView: View {
    var qr: UIImage
    var qr_url: String
    
    var body: some View {
        VStack{
            Text("QR Code")
                .font(.title)
                .padding(.bottom)
            Text(qr_url)
                .padding(.bottom)
            Image(uiImage: qr)
                .resizable()
                .interpolation(.none)
                .scaledToFit()
                .padding(.bottom)
            Button(action: {
                // TODO:
            }, label: {
                Text("Save to images")
                
            })
        }
        .padding()
    }
}
