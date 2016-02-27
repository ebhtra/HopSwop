//
//  MessageDetailVC.swift
//  HopSwop
//
//  Created by Ethan Haley on 2/21/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import UIKit

class MessageDetailVC: BeerLoginController, SentMessageDelegate {
    
    var message: Message!
    
    var otherUser: User {
        if message.msgFrom == User.thisUser {
            return message.msgTo
        }
        return message.msgFrom
    }
    
    @IBOutlet weak var msgBody: UITextView!
    @IBOutlet weak var toFromLabel: UILabel!
    
    @IBAction func makeNewMsg(sender: AnyObject) {
        
        let messageWriter = storyboard?.instantiateViewControllerWithIdentifier("SendMessage") as! SendMessageVC
        messageWriter.toUser = otherUser
        messageWriter.sentMsgDelegate = self
        
        navigationController?.presentViewController(messageWriter, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let toFrom = (message.msgFrom == User.thisUser) ? "Sent to" : "Received from"

        toFromLabel.text = "\(toFrom) \(otherUser.username) \(message.createdAt)"
        
        msgBody.text = message.msgText
    }
    
    // SentMessageDelegate protocol:
    func msgWasSent() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
