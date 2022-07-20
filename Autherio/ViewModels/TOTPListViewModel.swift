//
//  TOTPViewModel.swift
//  Autherio
//
//  Created by Kamil Kozioł on 15/02/2022.
//

import Foundation

class TOTPListViewModel: ObservableObject {
    @Published private(set) var list: [TOTP]
    public static var key: String = "totps"

    init() {
        if let data = UserDefaults.standard.data(forKey: TOTPListViewModel.key) {
            if let decoded = try? JSONDecoder().decode([TOTP].self, from: data) {
                self.list = decoded
                return
            }
        }
        
        self.list = []
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(list) {
            UserDefaults.standard.set(encoded, forKey: TOTPListViewModel.key)
        }
    }
    
    func remove(totp: TOTP) {
        if let index = list.firstIndex(of: totp) {
            list.remove(at: index)
            self.save()
        }
        
        return
    }
    
    func add(totp: TOTP) {
        self.list.append(totp)
        self.save()
    }
}
