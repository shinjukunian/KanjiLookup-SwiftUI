//
//  ContentView.swift
//  KanjiLookup-SwiftUI
//
//  Created by Morten Bertz on 2020/06/17.
//  Copyright © 2020 telethon k.k. All rights reserved.
//

import SwiftUI
import StringTools
import CanvasView
import UIKit

struct ContentView: View {
    
    let recognizer = Recognizer()
    let dictionary = KanjiDictionary(url: KanjiDictionary.dictionaryURL)
    
    @State var characters = [KanjiDictionary.KanjiCharacter]()

    var body: some View {
        
        return VStack(alignment: .center, spacing: 8, content: {
            List(characters, id: \.character, rowContent: {entry in
                return KanjiInfoRow(character: entry)
            }).onReceive(recognizer.$characters, perform: {kanji in
                self.characters = kanji
                    .filter {$0.containsKanjiCharacters}
                    .compactMap {self.dictionary.kanjiCaracter(for: $0)}
            })
            
            if #available(iOS 14.0, *) {
                FancyCanvas()
                    .environmentObject(recognizer)
                    .environmentObject(CanvasConfiguration())
                    .padding(8)
                    .aspectRatio(1, contentMode: .fit)
                    
                    
            } else {
                SimpleCanvasView().aspectRatio(1, contentMode: .fit)
                    .environmentObject(recognizer)
                    .padding(.bottom, 8)
            }
        })

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let dictionary=KanjiDictionary(url: KanjiDictionary.dictionaryURL)
        return ContentView(characters: [
            dictionary.kanjiCaracter(for: "熊")!,
            dictionary.kanjiCaracter(for: "手")!
        ])
    }
}
