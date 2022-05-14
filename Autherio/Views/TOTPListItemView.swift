//
//  TOTPListItemView.swift
//  Autherio
//
//  Created by Kamil Kozioł on 13/05/2022.
//

import SwiftUI
import Foundation

struct TOTPListItemView: View {
    var totp: TOTP
    @State var showCode: Bool = false
    @State var counter: Int = 0
    @Environment(\.colorScheme) var colorScheme
    @Binding var timer: Timer.TimerPublisher
    
    var body: some View {
        ZStack() {
            VStack(alignment: .leading) {
                Text(totp.issuer)
                    .foregroundColor(Color.white)
                    .font(.title)
                    .fontWeight(.semibold)
                
                Text(totp.mail)
                    .foregroundColor(Color(uiColor: UIColor.systemGray))
                    .font(.subheadline)
                
                ProgressView(value: Double(counter), total: Double(totp.period))
                
            }
        }
        .onAppear(perform: {
            counter = TOTP.getCounter(period: totp.period)
        })
        .onReceive(timer, perform: { _ in
            counter = TOTP.getCounter(period: totp.period);
        })
        .padding(30)
        .background(colorScheme == .dark ? Color(UIColor.systemGray6): Color(UIColor.label))
        .cornerRadius(10)
//        .overlay(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(Color.ui.dark_accent, lineWidth: 1)
//                )
        
    }
}
