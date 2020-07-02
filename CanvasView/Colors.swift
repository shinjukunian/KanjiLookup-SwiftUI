//
//  File.swift
//  
//
//  Created by Morten Bertz on 2020/07/03.
//

import Foundation
import SwiftUI

#if canImport(UIKit)

internal extension Color{
    static let quaternaryLabel = Color(UIColor.quaternaryLabel)
}
#else

internal extension Color{
    static let quaternaryLabel = Color(NSColor.quaternaryLabelColor)
}

#endif
