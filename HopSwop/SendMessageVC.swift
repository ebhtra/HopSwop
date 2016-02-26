//
//  SendMessageVC.swift
//  HopSwop
//
//  Created by Ethan Haley on 2/22/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import UIKit

class SendMessageVC: BeerLoginController {
    
    var sentMsgDelegate: SentMessageDelegate!

    var toUser: User!
    
    @IBOutlet weak var toLabel: UILabel!
    
    @IBOutlet weak var messageBody: UITextView!
    
    @IBAction func send(sender: UIButton) {
        
        if messageBody.text.isEmpty {
            
            displayGenericAlert("Error:", message: "Your message is empty.")
            
        } else {
            
            ParseClient.sharedInstance.postMessage(toUser, msg: messageBody.text) { success, error in
                
                if let err = error {
                    print("dang")
                    self.displayGenericAlert("Your message could not be sent.", message: err)
                    
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        print("so, so super")
                        self.messageBody.text = ""
                        self.sentMsgDelegate?.msgWasSent()
                        self.navigationController?.popViewControllerAnimated(true)
                        
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toLabel.text = "Message to \(toUser.username)"
        
        messageBody.becomeFirstResponder()
    }
}

protocol SentMessageDelegate {
    
    func msgWasSent()
}