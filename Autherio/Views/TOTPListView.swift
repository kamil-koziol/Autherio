//
//  TOTPListView.swift
//  Autherio
//
//  Created by Kamil Kozioł on 15/02/2022.
//

import SwiftUI

struct TOTPListView: View {
    @ObservedObject var model = TOTPListViewModel()
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var counter: Int = 0
    @Binding var isShowingScanner: Bool;
    @Binding var isShowingAdd: Bool;
    @State var search: String = ""
    
    var body: some View {
        ScrollView {
            ForEach(model.list) { totp in
                if(search == "" || totp.issuer.contains(search) || totp.mail.contains(search)) {
                    TOTPView(totp: totp, counter: $counter)
                        .padding(.horizontal)
                }
            }
            .searchable(text: $search)
        }
        .onReceive(timer, perform: { _ in
            counter = TOTP.getCounter(period: 30);
        })
        
        .sheet(isPresented: $isShowingScanner) {
            CodeScannerView(codeTypes: [.qr], simulatedData: "otpauth://totp/Test?secret=JBSWY3DPEHPK3PXP&issuer=Apple", completion: self.handleScan)
        }
        
        .sheet(isPresented: $isShowingAdd) {
            CreateTOTPView(completion: {totp in
                model.add(totp: totp)
                isShowingAdd = false;
            })
        }
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        switch result {
        case .success(let code):
            if !code.starts(with: "otpauth") { return }
            let url = URL(string: code)!
            let totp = TOTP.parseURL(url: url)
            model.add(totp: totp)
            
        case .failure(let error):
            print("Scanning failed")
            print(error)
        }
    }
}

struct TOTPListView_Previews: PreviewProvider {
    static var previews: some View {
        TOTPListView(isShowingScanner: Binding.constant(false), isShowingAdd: Binding.constant(false))
    }
}
