//
//  ViewController.swift
//  Notes
//
//  Created by Michal Černý on 13/07/2018.
//  Copyright © 2018 Michal Černý. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Variables
    let network = Network()
    @IBOutlet weak var editDoneBtn: UIBarButtonItem!
    private var editMode = false
    var notes: [Note] = [] {
        didSet {
            cntNotesLabel.text = String.localizedStringWithFormat(
                NSLocalizedString( "%d Notes", comment: "The list contains more than one note"), notes.count
            )
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cntNotesLabel: UILabel!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView() // hiding unnecessary separators
        setBtnTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notes = network.getAllRequest()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "showSelectedNote":
                if let vc = segue.destination as? NoteDetailViewController {
                    vc.note = sender as? Note
                }
//            case "showCreateNewNote":
            default: break
            }
        }
    }
    
    // MARK: Actions
    @IBAction func editBtnClick(_ sender: UIBarButtonItem) {
        editMode = !editMode
        setBtnTitle()
        tableView.reloadData() // show/hide trash cans
    }
    
    // MARK: Functions
    private func setBtnTitle () {
        editDoneBtn.title = editMode ? NSLocalizedString("Done", comment: "") : NSLocalizedString("Edit", comment: "")
    }
}

// MARK: Extensions
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if editMode {
            network.deleteRequest(id: indexPath.row)
            notes = network.getAllRequest()
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
            performSegue(withIdentifier: "showSelectedNote", sender: notes[indexPath.row])
        }
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "myCell")
        cell.textLabel?.text = notes[indexPath.row].title
        
        cell.imageView?.image = editMode ? #imageLiteral(resourceName: "trash") : nil
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.layer.masksToBounds = true
        
        return cell
    }
    
}

