//
//  Recognizer.swift
//  KanjiLookup-SwiftUI
//
//  Created by Morten Bertz on 2020/06/17.
//  Copyright © 2020 telethon k.k. All rights reserved.
//

import Foundation
import SwiftUI
import Zinnia_Swift
import Combine

public class Recognizer:ObservableObject, Subscriber{

    public typealias Input = [[CGPoint]]
    public typealias Failure = Never
    
    @Published var currentStroke: Stroke = Stroke()
    @Published var strokes:[Stroke]=[Stroke]()
    
    @Published public var characters:[String] = [String]()
    
    var drawStrokes:[Stroke]{
        return self.strokes + [self.currentStroke]
    }
    
    var canvasSize:CGSize = .zero{
        didSet{
            _recognizer.canvasSize=Zinnia_Swift.Recognizer.Size(cgSize: canvasSize)
        }
    }
    
    fileprivate lazy var _recognizer: Zinnia_Swift.Recognizer = {
        do{
            let recognizer=try Zinnia_Swift.Recognizer(modelURL: modelURL)
            return recognizer
        }
        catch let error{
            fatalError(error.localizedDescription)
        }
    }()
    
    fileprivate let modelURL:URL
    
    public var queue=DispatchQueue(label: "recognizerQueue", qos: .userInitiated)
    
    public init(){
        guard let url=Bundle.main.url(forResource: "zinnia", withExtension: "model") else{
            fatalError("Model not found")
        }
        self.modelURL=url
    }
    
    
    init(url:URL){
        self.modelURL=url
    }
    
    func clear(){
        self.strokes.removeAll()
        self.currentStroke = Stroke()
        _recognizer.clear()
        self.characters.removeAll()
    }
    
    func add(point:CGPoint){
        self.currentStroke.add(point: point)
    }
    
    func finishStroke(){
        self.strokes.append(self.currentStroke)
        _recognizer.add(stroke: self.currentStroke)
        self.queue.async {
            let characters = self._recognizer.classify().map({$0.character})
            DispatchQueue.main.async {
                self.characters=characters
            }
        }
        self.currentStroke = Stroke()
    }
    
    func undoLast(){
        self.strokes=self.strokes.dropLast()
        _recognizer.clear()
        self.currentStroke = Stroke()
        self.characters = _recognizer.classify(strokes: self.strokes).map({$0.character})
    }
    
    func add(stroke:[CGPoint]){
        stroke.forEach {self.add(point: $0)}
        finishStroke()
    }
    
    public func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    public func receive(_ input: [[CGPoint]]) -> Subscribers.Demand {
        self.clear()
        input.forEach({self.add(stroke: $0)})
        return .unlimited
    }
    
    public func receive(completion: Subscribers.Completion<Never>) {
        
    }
}
