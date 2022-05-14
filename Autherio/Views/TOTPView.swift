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
                            .foregroundColor(Color.white)
                            .font(.title)
                        
                        
                        if showCode {
                            Text(totp.getCode())
                                .foregroundColor(Color.white)
                        }
                        
                        else {
                            Text(" ")
                        }
                        
                        
                    }
                    Spacer()
                    Button(action: {
                        showCode.toggle()
                    }, label: {
                        Image(systemName: "eye.square.fill")
                            .foregroundColor(Color.blue)
                            .font(.title)
                    })
                }
                
                ProgressView(value: Double(counter), total: 30.0)
                
            }
        }
        .padding(40)
        .background(colorScheme == .dark ? Color.gray: Color.ui.dark_accent)
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
