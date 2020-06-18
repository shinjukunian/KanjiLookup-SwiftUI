//
//  CanvasView.swift
//  KanjiLookup-SwiftUI
//
//  Created by Morten Bertz on 2020/06/17.
//  Copyright © 2020 telethon k.k. All rights reserved.
//

import SwiftUI

struct CanvasView:View{
    
    @EnvironmentObject var recognizer:Recognizer
    
    var body: some View{
        let drag=DragGesture(minimumDistance: 1, coordinateSpace: .local)
            .onChanged({gesture in
                self.recognizer.add(point: gesture.location)
            }).onEnded({gesture in
                self.recognizer.finishStroke()
            })
        
        let buttons=HStack(alignment: .firstTextBaseline, spacing: 0, content: {
            Button(action: {
                self.recognizer.clear()
                
            }, label: {
                Text("Clear")
                    .foregroundColor(Color.red)
                    .multilineTextAlignment(.center)
            })
            Spacer()
            Button(action: {
                self.recognizer.undoLast()
                
            }, label: {
                Text("Undo")
                    .foregroundColor(Color.red)
                    .multilineTextAlignment(.center)
            })
        })
        
        return GeometryReader(content: {geometry in
            
            ZStack(alignment: .bottom, content: {
                
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .stroke(Color.red, lineWidth: 2)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.quaternaryLabel), alignment: .center)
                
                Path({path in
                    for stroke in self.recognizer.drawStrokes{
                        path.move(to: stroke.points.first?.cgPoint ?? .zero)
                        path.addLines(stroke.points.dropFirst().map {$0.cgPoint})
                    }
                    
                })
                .stroke(lineWidth: 1)
                
                buttons.padding()
                
            })
            .gesture(drag)
            .onAppear {
                self.recognizer.canvasSize=geometry.size
            }
            
        })
    
    }
    
    
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView().environmentObject(Recognizer())
    }
}
