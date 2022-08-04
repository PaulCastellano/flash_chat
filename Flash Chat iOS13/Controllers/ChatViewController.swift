//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages : [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.appName
        self.navigationItem.hidesBackButton = true
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
    
        loadMessages()
    }
    
    func loadMessages() {
        db.collection(Constants.FStore.colletionName).order(by: Constants.FStore.dateField).addSnapshotListener { querySnapshot, error in
            self.messages = []
            if let e = error {
                print("Error: \(e)")
            } else {
                if let documents = querySnapshot?.documents {
                    for doc in documents {
                        let data = doc.data()
                        guard let sender = data[Constants.FStore.senderField] as? String else { continue }
                        guard let body = data[Constants.FStore.bodyField] as? String else { continue }
                        
                        self.messages.append(Message(sender: sender, body: body))
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        guard let messageBody = messageTextfield.text else { return }
        guard let messageSender = Auth.auth().currentUser?.email else { return }
        let dict: [String: Any] = [Constants.FStore.bodyField: messageBody,
                                   Constants.FStore.senderField: messageSender,
                                   Constants.FStore.dateField: Date().timeIntervalSince1970]
        db.collection(Constants.FStore.colletionName).addDocument(data: dict) { error in
            if let e = error {
                print("Error: \(e)")
            } else {
                print("Success")
                self.loadMessages()
                DispatchQueue.main.async {
                    self.messageTextfield.text = ""
                }
            }
        }
        
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let error as NSError {
            print ("Error sign out: %@", error)
        }
    }
    
}

//MARK: - UITableViewDataSource section

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as? MessageCell else {
            return UITableViewCell()
        }
        
        let message = messages[indexPath.row]
        
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: Constants.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: Constants.BrandColors.purple)
        } else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: Constants.BrandColors.purple)
            cell.label.textColor = UIColor(named: Constants.BrandColors.lightPurple)

        }
        
        cell.label.text = message.body
        
        return cell
    }
}
