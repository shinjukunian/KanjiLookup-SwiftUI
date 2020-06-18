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

class Recognizer:ObservableObject{
    
    @Published var currentStroke: Stroke = Stroke()
    @Published var strokes:[Stroke]=[Stroke]()
    
    @Published var characters:[String] = [String]()
    
    var drawStrokes:[Stroke]{
        return self.strokes + [self.currentStroke]
    }
    
    var canvasSize:CGSize = .zero{
        didSet{
            _recognizer.canvasSize=Zinnia_Swift.Recognizer.Size(cgSize: canvasSize)
        }
    }
    
    fileprivate lazy var _recognizer: Zinnia_Swift.Recognizer = {
        
        guard let url=Bundle.main.url(forResource: "zinnia", withExtension: "model") else{
            fatalError("Model not found")
        }
        do{
            let recognizer=try Zinnia_Swift.Recognizer(modelURL: url)
            return recognizer
        }
        catch let error{
            fatalError(error.localizedDescription)
        }
    }()
    
    
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
        self.characters = _recognizer.classify().map({$0.character})
        self.currentStroke = Stroke()
    }
    
    func undoLast(){
        self.strokes=self.strokes.dropLast()
        _recognizer.clear()
        self.currentStroke = Stroke()
        self.characters = _recognizer.classify(strokes: self.strokes).map({$0.character})
    }
}
