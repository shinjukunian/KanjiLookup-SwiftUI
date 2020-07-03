//
//  ViewController.swift
//  KanjiLookup-UIKit
//
//  Created by Morten Bertz on 2020/07/03.
//  Copyright © 2020 telethon k.k. All rights reserved.
//

import UIKit
import CanvasView
import Combine

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CanvasControllerDelegate {
    
    @IBOutlet weak var tableView:UITableView!

    
    var items:[KanjiDictionary.KanjiCharacter]=[KanjiDictionary.KanjiCharacter](){
        didSet{
            self.tableView.reloadData()
        }
    }
       
    let dictionary=KanjiDictionary(url: KanjiDictionary.dictionaryURL)
    
    
    var cancellables=Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate=self
        self.tableView.dataSource=self
        
//        self.children.compactMap({$0 as? CanvasController}).first?.delegate=self
        
        self.children.compactMap({$0 as? CanvasController}).first?.subject.sink(receiveValue: {characters in
            self.items=characters.compactMap({self.dictionary.kanjiCaracter(for: $0)})
        }).store(in: &cancellables)
        
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "characterCell", for: indexPath)
        cell.textLabel?.text=self.items[indexPath.row].character
        cell.detailTextLabel?.text=self.items[indexPath.row].reading
        return cell
    }
    
    func canvasControllerRecognized(characters: [String]) {
        self.items=characters.compactMap({self.dictionary.kanjiCaracter(for: $0)})
    }
    
}

