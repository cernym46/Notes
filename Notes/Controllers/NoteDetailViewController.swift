//
//  NoteDetailViewController.swift
//  Notes
//
//  Created by Michal Černý on 13/07/2018.
//  Copyright © 2018 Michal Černý. All rights reserved.
//

import UIKit


class NoteDetailViewController: UIViewController {

    // MARK: Variables
    var note: Note?
    let network = Network()
    
    @IBOutlet weak var noteTextField: UITextView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextField.text = note?.title
    }
    
    // back btn clicked
    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        
        // delete / put / post
        if parent == nil{
            if let id = note?.id {
                if ( noteTextField.text.isEmpty ) {
                    network.deleteRequest(id: id)
                } else {
                    network.putRequest(id: id, title: noteTextField.text)
                }
            } else if !noteTextField.text.isEmpty {
                network.postRequest(title: noteTextField.text)
            }
        }
    }
    
    // MARK: Actions
    @IBAction func deleteBtnClick(_ sender: UIBarButtonItem) {
        // if a note already exists, then delete it
        if let id = note?.id {
            Network().deleteRequest(id: id)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
}
