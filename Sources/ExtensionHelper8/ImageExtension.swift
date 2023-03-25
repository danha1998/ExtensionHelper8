//
//  File.swift
//  
//
//  Created by DanHa on 25/03/2023.
//

import Foundation
import SwiftUI

@available(iOS 14.0, *)
extension Image {
    init(packageResource name: String, ofType type: String) {
            #if canImport(UIKit)
            guard let path = Bundle.module.path(forResource: name, ofType: type),
                  let image = UIImage(contentsOfFile: path) else {
                self.init(name)
                return
            }
            self.init(uiImage: image)
            #elseif canImport(AppKit)
            guard let path = Bundle.module.path(forResource: name, ofType: type),
                  let image = NSImage(contentsOfFile: path) else {
                self.init(name)
                return
            }
            self.init(nsImage: image)
            #else
            self.init(name)
            #endif
        }
}
