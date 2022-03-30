//
//  TOTPView.swift
//  Autherio
//
//  Created by Kamil Kozioł on 02/10/2021.
//

import SwiftUI

struct TOTPView: View {
    var totp: TOTP
    @State var showCode: Bool = false
    @Binding var counter: Int
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack() {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(totp.issuer)
                            .foregroundColor(Color.black)
                            .font(.title)
                        
                        
                        if !showCode {
                            Button("Show code") {
                                showCode.toggle()
                            }
                        }
                        
                        else {
                            Text(totp.getCode())
                                .foregroundColor(Color.black)
                        }
                        
                        
                    }
                    Spacer()
                    Button(action: {
                        UIPasteboard.general.string = totp.getCode()
                    }, label: {
                        Image(systemName: "doc.on.doc")
                            .foregroundColor(Color.black)
                            .font(.title)
                    })
                }
                
                ProgressView(value: Double(counter), total: 30.0)
                
            }
        }
        .padding(40)
        .background(colorScheme == .dark ? Color.gray: Color.white)
        .cornerRadius(10)
        .shadow(radius: 1)
        
    }
}

struct TOTPView_Previews: PreviewProvider {
    static var previews: some View {
        let totp = TOTP(secretKey: "JBSWY3DPEHPK3PXP")
        return TOTPView(totp: totp, counter: Binding.constant(10))
    }
}
