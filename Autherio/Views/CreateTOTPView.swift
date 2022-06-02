//
//  CreateTOTPView.swift
//  Autherio
//
//  Created by Kamil Kozioł on 15/02/2022.
//

import SwiftUI

struct CreateTOTPView: View {
    
    @ObservedObject var totp = TOTP(secretKey: "", issuer: "", mail: "")
    public var completion: (TOTP) -> Void
    
    init(completion: @escaping (TOTP) -> Void = {_ in }) {
        self.completion = completion
    }
    
    var body: some View {
        Form {
            Section(header: Text("Secret Key")) {
                HStack {
                    TextField("Enter key...", text: $totp.secretKey)
                    Button(action: {
                        totp.secretKey = TOTP.getRandomSecretKey()
                    }, label: {
                        Image(systemName: "goforward")
                    })
                }
            }
            
            Section(header: Text("Issuer")) {
                TextField("Enter issuer...", text: $totp.issuer)
            }
            
            Section(header: Text("Mail")) {
                TextField("Enter mail...", text: $totp.mail)
            }
            
            Section(header: Text("Digits")) {
                TextField("Enter digits...", text: Binding(
                    get: { String(totp.digits) },
                    set: { totp.digits = Int($0) ?? 0 }
                ))
                    .keyboardType(.numberPad)
            }
            
            Section(header: Text("Period")) {
                TextField("Enter period...", text: Binding(
                    get: { String(totp.period) },
                    set: { totp.period = Int($0) ?? 0 }
                )).keyboardType(.numberPad)
            }
            
            Button(action: {
                completion(totp)
            }, label: {
                Text("Add")
            })
            .disabled(totp.mail.isEmpty || totp.issuer.isEmpty || totp.secretKey.isEmpty)
        }
        .navigationTitle("Add new TOTP")
    }
}

struct CreateTOTPView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTOTPView()
    }
}
