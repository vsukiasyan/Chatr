//
//  ChatVC.swift
//  Chatr
//
//  Created by Vic Sukiasyan on 5/18/18.
//  Copyright © 2018 Vic Sukiasyan. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageText: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var messageArray : [Message] = [Message]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        messageText.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (tableViewTapped))
        
        tableView.addGestureRecognizer(tapGesture)
        
        
        configureTableView()
        retrieveMessages()
        tableView.separatorStyle = .none
        
    }


    // Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        
        if cell.senderUsername.text == Auth.auth().currentUser?.email as String! {
            
            //Set background to blue if message is from logged in user.
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
            
        } else {
            
            //Set background to grey if message is from another user.
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
        }
        
        return cell
    }
    
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120.0
    }
    
    @objc func tableViewTapped() {
        messageText.endEditing(true)
    }

    
    // Text Fields
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 348
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }

    }
    
    @IBAction func sendPressed(_ sender: Any) {
        messageText.endEditing(true)
        messageText.isEnabled = false
        sendBtn.isEnabled = false

        let messagesDB = Database.database().reference().child("Messages")
        let messageDictionary = ["Sender": Auth.auth().currentUser?.email,
                                 "MessageBody": messageText.text!]
        
        messagesDB.childByAutoId().setValue(messageDictionary) {
            (error, reference) in
            
            if error != nil {
                print(error!)
            }
            else {
                print("Message saved successfully!")
            }
            
            self.messageText.isEnabled = true
            self.sendBtn.isEnabled = true
            self.messageText.text = ""
            
            
        }
    }
    
    func retrieveMessages() {
        let messageDB = Database.database().reference().child("Messages")
        messageDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            let text = snapshotValue["MessageBody"]
            let sender = snapshotValue["Sender"]
            
            let message = Message()
            message.messageBody = text!
            message.sender = sender!
            
            self.messageArray.append(message)
            self.configureTableView()
            self.tableView.reloadData()
        }
        
    }
    
    

    @IBAction func logout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let vc = storyboard?.instantiateViewController(withIdentifier: "WelcomVC") as! WelcomeVC
            present(vc, animated: true, completion: nil)
        } catch {
            print("Error: There was a problem logging out.")
        }
    }
    
    

}
