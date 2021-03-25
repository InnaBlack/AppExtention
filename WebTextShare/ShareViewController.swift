//
//  ShareViewController.swift
//  WebTextShare
//
//  Created by  inna on 01/02/2021.
//

import UIKit
import Social

protocol MySequence: Sequence {

    mutating func sortAbcDESC()
    mutating func sortAbcASC()
}

protocol MyIteratorProtocol: IteratorProtocol {
    associatedtype Element
    mutating func next() -> Self.Element?
}

struct Word: Hashable {
    let letters: String
    let countInText: Int
}

struct Text {
    var words: [Word]
}

struct WordsIterator: MyIteratorProtocol {
        
    private var words: [Word]
    
    init(words: [Word]) {
        self.words = words
    }
    
    mutating func next() -> Word? {
       return self.next()
    }
}

extension Text: MySequence {
    func makeIterator() -> WordsIterator {
        WordsIterator(words: words)
    }
   
    mutating func sortAbcDESC() {
        words.sort(by: { $0.letters < $1.letters })
    }

    mutating func sortAbcASC() {
        words.sort(by: { $0.letters > $1.letters })
    }
    
    mutating func get_3_letter(){
        words =  Array(Array(Set(words))
            .filter({ $0.letters.count == 3 })
                        .sorted(by: { $0.countInText > $1.countInText })
                        .prefix(10))
    }
    
    mutating func get_5_letter() {
        words =  Array(Array(Set(words))
            .filter({ $0.letters.count == 5 })
                        .sorted(by: { $0.countInText > $1.countInText })
                        .prefix(10))
    }
    
}

enum typeOfSuffix: Int {
    case ASC
    case DESC
    case _3h
    case _5h
}

class ShareViewController: SLComposeServiceViewController, UITableViewDelegate, UITableViewDataSource {
    
    var text: Text = Text(words: [Word]())
    
    var tableView: UITableView = .init()
    
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        
        let controller = self.navigationController?.children.first
        
        let segment = UISegmentedControl(items: ["ASC","DESC","3", "5"])
        segment.addTarget(self, action: #selector(ShareViewController.segmentChanged(_:)), for: .allEvents)
        let viewMain: UIStackView = .init()
       
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        viewMain.axis = .vertical
        viewMain.addArrangedSubview(segment)
        viewMain.addArrangedSubview(self.tableView)
        controller?.view = viewMain
        let splitText = contentText.split(separator: " ")
        text = Text(words: splitText.map { word -> Word in
            let countedSet = NSCountedSet(array: splitText)
            return Word(letters: String(word), countInText: countedSet.count(for: word))
        })

        return true
    }
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.text.words.count
    }


    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: "Cell") as UITableViewCell?)!

        // set the text from the data model
        cell.textLabel?.text = self.text.words[indexPath.row].letters + (self.text.words[indexPath.row].countInText > 0 ? " " +  String(self.text.words[indexPath.row].countInText) : "")

        return cell
    }

    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }

    @objc func segmentChanged(_ sender: UISegmentedControl) {
        
        guard let selectedSuffixType = typeOfSuffix(rawValue: sender.selectedSegmentIndex) else {
            fatalError("error")
        }
        switch selectedSuffixType {
        case .ASC:
            self.text.sortAbcASC()
            self.tableView.reloadData()
            print("ASC")
        case .DESC:
            self.text.sortAbcDESC()
            self.tableView.reloadData()
            print("DESC")
        case ._3h:
            self.text.get_3_letter()
            self.tableView.reloadData()
            print("get_3_letter")
        case ._5h:
            self.text.get_5_letter()
            self.tableView.reloadData()
            print("get_3_letter")
        }
    }
    override func didSelectPost() {
                
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    override func configurationItems() -> [Any]! {
               
        return []
    }
}
