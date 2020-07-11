//
//  CanvasView.swift
//  KanjiLookup-SwiftUI
//
//  Created by Morten Bertz on 2020/06/17.
//  Copyright © 2020 telethon k.k. All rights reserved.
//

import SwiftUI

public struct SimpleCanvasView:View, CanvasView{
    
    @EnvironmentObject var recognizer:Recognizer
    @EnvironmentObject var configuration:CanvasConfiguration
    
    public init(){}
    
    public var body: some View{
        let drag=DragGesture(minimumDistance: 1, coordinateSpace: .local)
            .onChanged({gesture in
                self.recognizer.add(point: gesture.location)
            }).onEnded({gesture in
                self.recognizer.finishStroke()
            })
        
        let buttons=HStack(alignment: .center, spacing: 0, content: {
            Button(action: {
                self.recognizer.clear()
                
            }, label: {
                Image(systemName: "clear").imageScale(.large)
                    .foregroundColor(configuration.foregroundColor)
            })
            Spacer()
            Button(action: {
                self.recognizer.undoLast()
                
            }, label: {
                Image(systemName: "arrow.counterclockwise").imageScale(.large)
                    .foregroundColor(configuration.foregroundColor)
            })
        })
        
        return GeometryReader(content: {geometry in
            
            ZStack(alignment: .bottom, content: {
                
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .stroke(configuration.foregroundColor, lineWidth: 2)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(configuration.backgroundColor), alignment: .center)
                
                Path({path in
                    for stroke in self.recognizer.drawStrokes{
                        path.move(to: stroke.points.first?.cgPoint ?? .zero)
                        path.addLines(stroke.points.dropFirst().map {$0.cgPoint})
                    }
                    
                })
                .stroke(style: StrokeStyle(lineWidth: configuration.strokeWidth, lineCap: .round, lineJoin: .round, miterLimit: 1, dash: [], dashPhase: 0))
                
                if configuration.showStandardButtons{
                    buttons.padding()
                }
                
            })
            .gesture(drag)
            .onAppear {
                self.recognizer.canvasSize=geometry.size
            }
            
        })
    
    }
    
    func clear(){
        self.recognizer.clear()
    }
    func undo() {
        self.recognizer.undoLast()
    }
    
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleCanvasView().environmentObject(Recognizer()).environmentObject(CanvasConfiguration())
    }
}
