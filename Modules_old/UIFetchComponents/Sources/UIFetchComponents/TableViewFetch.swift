import Foundation
import UIKit
import SwiftUI


enum typeOfSuffix: Int {
    case ASC
    case DESC
    case _3h
    case _5h
    case feed
}


 public class TableViewFetchUI: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var text: Text = Text(words: [Word]())
    var tableView: UITableView
    
    required init?(coder aDecoder: NSCoder) {
        
        self.tableView = .init()
        
        super.init(coder: aDecoder)
    }
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init(nibName: nil, bundle: nil)
    }
    
    public override func viewDidLoad() {
       
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        // make segmentConrol
        let segment = UISegmentedControl(items: ["ASC","DESC","3", "5"])
        segment.addTarget(self, action: #selector(self.segmentChanged(_:)), for: .allEvents)
    
        let viewMain: UIStackView = .init()
        viewMain.axis = .vertical
        viewMain.addArrangedSubview(segment)
        viewMain.addArrangedSubview(tableView)
        self.view = viewMain
        
    }
    
    // number of rows in table view
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.text.words.count
    }


    // create a cell for each table view row
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // create a new cell if needed or reuse an old one
        let cell: UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: "Cell") as UITableViewCell?)!

        // set the text from the data model
        cell.textLabel?.text = self.text.words[indexPath.row].letters + (self.text.words[indexPath.row].countInText > 0 ? " " +  String(self.text.words[indexPath.row].countInText) : "")

        return cell
    }

    // method to run when table view cell is tapped
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        case .feed:
            self.tableView.reloadData()
            print("feed")
        }
    }
}

public final class TableViewFetch: UIViewControllerRepresentable {

    var data: String
   
   
    public init(data: String) {
        self.data = data
    }

    public func makeUIViewController(context: Context) -> TableViewFetchUI {

        let splitText = data.split(separator: " ")
        let text = Text(words: splitText.map { word -> Word in
            let countedSet = NSCountedSet(array: splitText)
            return Word(letters: String(word), countInText: countedSet.count(for: word))
        })
        
        let tableViewController: TableViewFetchUI = .init(tableView: .init())
        tableViewController.text = text
        
        return tableViewController
    }
    
    public func updateUIViewController(_ uiViewController: TableViewFetchUI, context: Context) {
     //   TableViewFetchUI(data: data)
    }
    
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(control: self)
    }
    
    public class Coordinator: NSObject {
        
        var control: TableViewFetch
        
        init(control: TableViewFetch) {
            self.control = control
        }
    }
    
    struct TableViewFetch_Previews: PreviewProvider {
      
        @available(iOS 13.0, *)
        static var previews: some View {
            Group {
                TableViewFetch(data: "dsfsdf")
            }
        }
    }
}

