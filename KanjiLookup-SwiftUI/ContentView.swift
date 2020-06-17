//
//  ContentView.swift
//  KanjiLookup-SwiftUI
//
//  Created by Morten Bertz on 2020/06/17.
//  Copyright © 2020 telethon k.k. All rights reserved.
//

import SwiftUI
import StringTools

struct ContentView: View {
    
    let recognizer=Recognizer()
    let dictionary=KanjiDictionary(url: KanjiDictionary.dictionaryURL)
    
    @State var characters:[KanjiDictionary.KanjiCharacter]=[KanjiDictionary.KanjiCharacter]()

    
    var body: some View {
        
        return VStack(alignment: .center, spacing: 10, content: {
            List(characters, id: \.character, rowContent: {entry in
                return KanjiInfoRow(character: entry)
            }).onReceive(recognizer.$characters, perform: {kanji in
                self.characters = kanji
                    .filter {$0.containsKanjiCharacters}
                    .compactMap {self.dictionary.kanjiCaracter(for: $0)}
            })
            
            CanvasView().aspectRatio(1, contentMode: .fit)
                .environmentObject(recognizer)
        })
        .padding(.horizontal, 12.0)
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(characters: [KanjiDictionary(url: KanjiDictionary.dictionaryURL).kanjiCaracter(for: "熊")!, KanjiDictionary(url: KanjiDictionary.dictionaryURL).kanjiCaracter(for: "手")!])
    }
}


struct KanjiInfoRow:View{
    var character:KanjiDictionary.KanjiCharacter
    
    var body: some View{
        HStack {
            Text(character.character)
            Spacer()
            Text(character.reading)
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.trailing)
        }
        
    }
    
}

struct KanjiInfoRow_Previews: PreviewProvider {
    static var previews: some View {
        guard let entry=KanjiDictionary(url: KanjiDictionary.dictionaryURL).kanjiCaracter(for: "熊") else {fatalError()}
        return KanjiInfoRow(character: entry)
    }
}
