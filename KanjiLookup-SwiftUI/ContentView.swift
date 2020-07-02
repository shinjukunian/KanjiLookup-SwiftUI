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
                ZStack(alignment: .bottom, content: {
                    
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .stroke(Color.red, lineWidth: 2)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(.quaternaryLabel), alignment: .center)
                    
                    FancyCanvas().environmentObject(recognizer)
                    
                }).padding(8)
                    
            } else {
                CanvasView().aspectRatio(1, contentMode: .fit)
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
        .contextMenu {
            Button(action: {
                UIPasteboard.general.string = self.character.character
            }, label: {
                Text("Copy Character")
            })
            Button(action: {
                UIPasteboard.general.string = self.character.reading
            }, label: {
                Text("Copy Reading")
            })
        }
        
    }
    
}

struct KanjiInfoRow_Previews: PreviewProvider {
    static var previews: some View {
        guard let entry=KanjiDictionary(url: KanjiDictionary.dictionaryURL).kanjiCaracter(for: "熊") else {fatalError()}
        return KanjiInfoRow(character: entry)
    }
}
