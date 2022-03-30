//
//  TOTPViewModel.swift
//  Autherio
//
//  Created by Kamil Kozioł on 15/02/2022.
//

import Foundation

class TOTPListViewModel: ObservableObject {
    @Published private(set) var list: [TOTP]

    init() {
        if let data = UserDefaults.standard.data(forKey: "totps") {
            if let decoded = try? JSONDecoder().decode([TOTP].self, from: data) {
                self.list = decoded
                return
            }
        }
        
        self.list = []
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(list) {
            UserDefaults.standard.set(encoded, forKey: "totps")
        }
    }
    
    func add(totp: TOTP) {
        self.list.append(totp)
        self.save()
    }
}
