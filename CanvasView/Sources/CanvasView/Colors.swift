//
//  File.swift
//  
//
//  Created by Morten Bertz on 2020/07/03.
//

import Foundation
import SwiftUI

#if canImport(UIKit)
import PencilKit

internal extension Color{
    static let quaternaryLabel = Color(UIColor.quaternaryLabel)
}


public class CanvasConfiguration:ObservableObject{
    @Published public var backgroundColor = Color.quaternaryLabel
    @Published public var foregroundColor = Color.red
    @Published public var strokeColor = UIColor.label
    @Published public var strokeWidth : CGFloat = 5
    @Published public var toolType:PKInkingTool.InkType = .pen
    @Published public var showStandardButtons = true
    
    public init(){}
}



#else

internal extension Color{
    static let quaternaryLabel = Color(NSColor.quaternaryLabelColor)
}

#endif
