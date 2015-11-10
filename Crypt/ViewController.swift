//
//  ViewController.swift
//  Crypt
//
//  Created by Faculty of Organisation and Informatics on 09/11/15.
//  Copyright © 2015 air. All rights reserved.
//

import UIKit
import CryptoModule
class ViewController: UIViewController {
    func test(){
        let worker: RSASign = RSASign ()
        let encryptedText = worker.encryptRSA("paDesi")
        print(encryptedText)
        let decryptedText = worker.decryptRSA(encryptedText)
        print (decryptedText) //to radi super
        let signature = worker.sign(decryptedText)
        worker.Verify(decryptedText, signature: signature)
        worker.Verify(decryptedText, signature: signature+"aaa")
        print("privatni="+worker.getPrivateKey())
        print("javni="+worker.getPublicKey())
        worker.getPublicKey()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       test()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

