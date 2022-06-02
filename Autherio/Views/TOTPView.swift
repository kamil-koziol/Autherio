//
//  TOTPView.swift
//  Autherio
//
//  Created by Kamil Kozioł on 02/10/2021.
//

import SwiftUI
import UniformTypeIdentifiers

struct TOTPView: View {
    var totp: TOTP
    @State var showCode: Bool = false
    @Binding var timer: Timer.TimerPublisher
    @State var counter = 0
    @State var isShowingQR: Bool = false;
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
            VStack {
                Text(totp.getCode().prefix(3) + " " + totp.getCode().suffix(3))
                    .font(.title)
                    .onLongPressGesture(perform: {
                        UIPasteboard.general.setValue(totp.getCode(), forPasteboardType: UTType.plainText.identifier)
                    })
                
                ProgressView(value: Double(counter), total: Double(totp.period))
                    .padding()
                
                
                Form {
                    Section(header: Text("Secret Key")) {
                        HStack {
                            if showCode {
                                TextField("Enter key...", text: Binding.constant(totp.secretKey))
                                    .disabled(true)
                            } else {
                                SecureField("Enter key...", text: Binding.constant(totp.secretKey))
                                    .disabled(true)
                            }
                            
                            Button(action: {
                                showCode.toggle()
                            }, label: {
                                if showCode {
                                    Image(systemName: "eye.slash")
                                        .foregroundColor(Color.blue)
                                }
                                else {
                                    Image(systemName: "eye")
                                        .foregroundColor(Color.blue)
                                }
                            })
                            .buttonStyle(PlainButtonStyle())
                            .onLongPressGesture(perform: {
                                UIPasteboard.general.setValue(totp.secretKey, forPasteboardType: UTType.plainText.identifier)
                            })
                        }
                    }
                    
                    Section(header: Text("Issuer")) {
                        TextField("Enter issuer...", text: Binding.constant(totp.issuer))
                    }
                    .disabled(true)
                    
                    Section(header: Text("Mail")) {
                        TextField("Enter mail...", text: Binding.constant(totp.mail))
                    }
                    .disabled(true)
                    
                    Section(header: Text("Digits")) {
                        TextField("Enter digits...", text: Binding.constant(String(totp.digits)))
                    }
                    .disabled(true)
                    
                    Section(header: Text("Period")) {
                        TextField("Enter period...", text: Binding.constant(String(totp.period)))
                    }
                    .disabled(true)
                    
                    Button(action: {
                        isShowingQR.toggle()
                    }, label: {
                        Text("Generate QR Code")
                    })
                }
            }
            .onAppear() {
                counter = TOTP.getCounter(period: totp.period)
            }
            .onReceive(timer, perform: { _ in
                counter = TOTP.getCounter(period: totp.period);
            })
            .sheet(isPresented: $isShowingQR) {
                QRView(qr: QRCoder.generate(from: totp.getURL()), qr_url: totp.getURL().absoluteString)
            }
        
    }
}
