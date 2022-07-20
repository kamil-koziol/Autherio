//
//  TOTPListView.swift
//  Autherio
//
//  Created by Kamil Kozioł on 15/02/2022.
//

import SwiftUI
import CodeScanner

struct TOTPListView: View {
    @ObservedObject var model = TOTPListViewModel()
    @State var timer = Timer.publish(every: 1, on: .main, in: .common)
    @State var counter: Int = 0
    @Binding var isShowingScanner: Bool
    @Binding var isShowingAdd: Bool
    @State var search: String = ""
    
    var body: some View {
            ScrollView {
                ForEach(model.list.reversed()) { totp in
                        if(search == "" || totp.issuer.contains(search) || totp.mail.contains(search)) {
                            NavigationLink(destination: {
                                TOTPView(totp: totp, timer: $timer)
                                    .onItemRemove {
                                        model.remove(totp: totp)
                                    }
                            }, label: {
                                TOTPListItemView(totp: totp, timer: $timer)
                                    .padding(.horizontal)
                            })
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
            CodeScannerView(codeTypes: [.qr], simulatedData: TOTP.getRandom().getURL().absoluteString, completion: self.handleScan)
        }
        
        .sheet(isPresented: $isShowingAdd) {
            CreateTOTPView(completion: {totp in
                model.add(totp: totp)
                isShowingAdd = false;
            })
        }
    }
    
    func onRemove(_ totp: TOTP) {
        model.remove(totp: totp)
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        switch result {
        case .success(let result):
            guard let url = URL(string: result.string) else {
                isShowingScanner = false
                return
            }

            if(!TOTP.isURLValid(url: url)) {
                isShowingScanner = false
                return
            }
            
            let totp = TOTP.parseURL(url: url)
            model.add(totp: totp)
            isShowingScanner = false
            
        case .failure(let error):
            print("Scanning failed")
            print(error)
            isShowingScanner = false
        }
    }
}
