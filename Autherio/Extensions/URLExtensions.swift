//
//  URLExtensions.swift
//  Autherio
//
//  Created by Kamil Kozioł on 15/02/2022.
//

import Foundation

extension URL {
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}
