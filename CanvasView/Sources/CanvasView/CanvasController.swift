//
//  File.swift
//  
//
//  Created by Morten Bertz on 2020/07/03.
//

import Foundation
import SwiftUI
import Combine

#if canImport(UIKit)
import UIKit

@objc public protocol CanvasControllerDelegate{
    func canvasControllerRecognized(characters:[String])
}


public class CanvasController:UIHostingController<AnyView>, Subscriber{
    
    public typealias Input = [String]
    
    public typealias Failure = Never
    
    fileprivate let recognizer=Recognizer()
    
    var cancellables=Set<AnyCancellable>()
    
    public let subject=PassthroughSubject<Input,Failure>()
    
    @objc public weak var delegate:CanvasControllerDelegate?
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        
        let view:AnyView
        if #available(iOS 14.0, *) {
            let canvas=FancyCanvas().environmentObject(recognizer)
            view=AnyView(canvas)
        } else {
            view=AnyView(SimpleCanvasView().environmentObject(recognizer))
        }
        super.init(coder: aDecoder, rootView: view)
        recognizer.$characters.subscribe(self)
    }
        
    public func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    public func receive(_ input: [String]) -> Subscribers.Demand {
        
        subject.send(input)
        if let delegate=self.delegate{
            delegate.canvasControllerRecognized(characters: input)
        }
        return .unlimited
    }
    
    public func receive(completion: Subscribers.Completion<Never>) {
        
    }
    
}
#endif

