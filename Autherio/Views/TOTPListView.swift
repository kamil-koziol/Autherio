//
//  TOTPListView.swift
//  Autherio
//
//  Created by Kamil Kozioł on 15/02/2022.
//

import SwiftUI

struct TOTPListView: View {
    @ObservedObject var model = TOTPListViewModel()
    @State var timer = Timer.publish(every: 1, on: .main, in: .common)
    @State var counter: Int = 0
    @Binding var isShowingScanner: Bool;
    @Binding var isShowingAdd: Bool;
    @State var search: String = ""
    
    var body: some View {
        ScrollView {
                ForEach(model.list) { totp in
                    if(search == "" || totp.issuer.contains(search) || totp.mail.contains(search)) {
                        TOTPListItemView(totp: totp, timer: $timer)
                            .padding(.horizontal)
                    }
                }
            .searchable(text: $search)
        }
        .onAppear(perform: {
            timer.connect()
        })
        .onReceive(timer, perform: { _ in
            counter = TOTP.getCounter(period: TOTP.DEFAULT_PERIOD);
        })
        
        .sheet(isPresented: $isShowingScanner) {
            CodeScannerView(codeTypes: [.qr], simulatedData: TOTP.getRandom().getURL().path, completion: self.handleScan)
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
