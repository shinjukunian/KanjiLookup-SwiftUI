//
//  KanjiDictionary.swift
//  KanjiLookup-SwiftUI
//
//  Created by Morten Bertz on 2020/06/17.
//  Copyright © 2020 telethon k.k. All rights reserved.
//

import Foundation

class KanjiDictionary{
    
    struct KanjiCharacter:Equatable{
        
        let character:String
        let reading:String
    }
    
    static let dictionaryURL=Bundle.main.url(forResource: "kanjiDict", withExtension: "txt")!
    
    fileprivate let dictionary:[String:String]
    
    init(url:URL) {
        do{
            let text=try String(contentsOf: url)
            let lines=text.split(separator: "\n")
            let items=lines.compactMap({line->(String,String)? in
                let lineItems=line.split(separator: ",")
                guard let character=lineItems.first else{return nil}
                return (String(character),lineItems.dropFirst().joined())
            })
            self.dictionary=Dictionary(items, uniquingKeysWith: {s1,_ in return s1})
        }
        catch let error{
            print(error)
            fatalError(error.localizedDescription)
        }
        
    }
    
    func kanjiCaracter(for character:String)->KanjiCharacter?{
        if let data=self.dictionary[character]{
            return KanjiCharacter(character: character, reading: data)
        }
        else{
            return nil
        }
    }
    
    
    
}
