//
//  FancyCanvasView.swift
//  KanjiLookup-SwiftUI
//
//  Created by Morten Bertz on 2020/07/02.
//  Copyright © 2020 telethon k.k. All rights reserved.
//

import Foundation
import UIKit
import PencilKit
import SwiftUI

@available(iOS 14.0, *)
struct FancyCanvasWrapper: UIViewRepresentable {
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        
        var canvas: FancyCanvasWrapper

        init(_ canvas: FancyCanvasWrapper) {
            self.canvas = canvas
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            let strokes=canvasView.drawing.strokes
                .map({$0.path.interpolatedPoints(by: .parametricStep(1))
                        .map({$0.location})})
            self.canvas.drawnStrokes.strokes=strokes
        }
    }
    
    @Binding var canvas : PKCanvasView
    
    class DrawnStrokes:ObservableObject{
        @Published var strokes=[[CGPoint]]()
    }
    

    let drawnStrokes=DrawnStrokes()
    
    func makeCoordinator() -> Coordinator {
        let coordinator=Coordinator(self)
        return coordinator
    }

    func makeUIView(context: Context) -> PKCanvasView {
        
        canvas.tool = PKInkingTool(.pen, color: .label)
        canvas.allowsFingerDrawing=true
        canvas.delegate = context.coordinator
        canvas.isScrollEnabled=false
        canvas.backgroundColor = .clear
        canvas.isOpaque=false
        return canvas
    }

    func updateUIView(_ canvasView: PKCanvasView, context: Context) {
        
    }
    
    
}



@available(iOS 14.0, *)
struct FancyCanvas:View{
    
    @EnvironmentObject var recognizer:Recognizer
    
    @State private var canvasView = PKCanvasView()
    
    var body: some View{
        let fancyCanvas=FancyCanvasWrapper(canvas: $canvasView)
        
        let buttons=HStack(alignment: .firstTextBaseline, spacing: 0, content: {
            Button(action: {
                canvasView.clear()
                
            }, label: {
                Text("Clear")
                    .foregroundColor(Color.red)
                    .multilineTextAlignment(.center)
            })
            Spacer()
            Button(action: {
                canvasView.removeLastStroke()
                
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
                
                fancyCanvas
                
                buttons.padding()
                
            })
            
            .onAppear {
                recognizer.canvasSize=geometry.size
                fancyCanvas.drawnStrokes.$strokes.subscribe(self.recognizer)
            }
            
        })
    }
}

@available(iOS 14.0, *)
struct FancyCanvasView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FancyCanvas().environmentObject(Recognizer())
            
        }
    }
}

@available(iOS 14.0, *)
extension PKCanvasView{
    func removeLastStroke(){
        self.drawing.strokes=self.drawing.strokes.dropLast()
    }
    func clear(){
        self.drawing=PKDrawing()
    }
}
