//
//  ContentView.swift
//  Autherio
//
//  Created by Kamil Kozioł on 02/10/2021.
//

import SwiftUI

struct ContentView: View {
    @State private var isShowingScanner = false
    @State private var isShowingAdd = false

    var body: some View {
        NavigationView {
            TOTPListView(isShowingScanner: $isShowingScanner, isShowingAdd: $isShowingAdd)
            .navigationTitle("Autherio")
            .toolbar {
                HStack {
                    Button(action: {
                        isShowingScanner = true
                        
                    }, label: {
                        Image(systemName: "qrcode.viewfinder")
                    })
                    Button(action: {
                        isShowingAdd = true
                        
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
