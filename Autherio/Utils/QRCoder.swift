//
//  QRCode.swift
//  Auther
//
//  Created by Kamil Kozioł on 24/04/2021.
//

import Foundation
import UIKit
import CoreImage.CIFilterBuiltins

public class QRCoder {
    
    static var shared: QRCoder = {
        let instance = QRCoder()
        return instance
    }()
    
    private init() {}
    
    public static func generate(from: String) -> UIImage {
        let data = from.data(using: String.Encoding.ascii)!
        let filter = CIFilter.qrCodeGenerator()
        filter.message = data
        filter.correctionLevel = "Q"
        
        let context = CIContext()
        
//        filter.setValue(data, forKey: "inputMessage")
        
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
                }
        
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    public static func generate(from: URL) -> UIImage {
        return generate(from: from.absoluteString)
    }
}
