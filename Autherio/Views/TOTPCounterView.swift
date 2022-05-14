//
//  TOTPCounterView.swift
//  Autherio
//
//  Created by Kamil Kozioł on 13/05/2022.
//

import SwiftUI

struct TOTPCounterView: View {
    @Binding var totp: TOTP
    var body: some View {
        HStack {
            
        }
    }
}

struct TOTPCounterView_Previews: PreviewProvider {
    static var previews: some View {
        TOTPCounterView(totp: Binding.constant(TOTP.getRandom()))
    }
}
