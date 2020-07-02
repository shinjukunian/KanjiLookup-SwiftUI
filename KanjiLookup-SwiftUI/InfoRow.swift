//
//  InfoRow.swift
//  KanjiLookup-SwiftUI
//
//  Created by Morten Bertz on 2020/07/03.
//  Copyright © 2020 telethon k.k. All rights reserved.
//

import Foundation
import SwiftUI

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
