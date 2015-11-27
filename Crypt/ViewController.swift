//
//  ViewController.swift
//  Crypt
//
//  Created by Faculty of Organisation and Informatics on 09/11/15.
//  Copyright © 2015 air. All rights reserved.
//

import UIKit
import CryptoModule
import FileModule
class ViewController: UIViewController {
    func test(){
//        let worker: RSASign = RSASign ()
//        let encryptedText = worker.encryptRSA("paDesi")
//        print(encryptedText)
//        let decryptedText = worker.decryptRSA(encryptedText)
//        print (decryptedText) //to radi super
//        let signature = worker.sign(decryptedText)
//        worker.Verify(decryptedText, signature: signature)
//        worker.Verify(decryptedText, signature: signature+"aaa")
//        print("privatni="+worker.getPrivateKey())
//        print("javni="+worker.getPublicKey())
//        worker.getPublicKey()
//        let key = "asdfqweeasdfqweeasdfqweeasdfqwee"
//        let key2 = "asdfqweeasdfqweeasdfqweeasdfqwee"// length == 32
//        let iv = "mamamamamamamama" // lenght == 16
//        let s = "string to encrypt"
//        let enc = try! s.aesEncrypt(key, iv: iv)
//        do{
//            let dec = try enc.aesDecrypt(key2, iv: iv)
//            print(s) //string to encrypt
//            print("enc:\(enc)") //2r0+KirTTegQfF4wI8rws0LuV8h82rHyyYz7xBpXIpM=
//            print("dec:\(dec)") //string to encrypt
//            print(dec.characters.count)
//            print(s.characters.count)
//        }
//        catch {
//            print ("magda")
//        }
         //stvaranje kljuceva
          let RSAworker: RSASign = RSASign ()
          let privateKey = RSAworker.getPrivateKey()
          let publicKey = RSAworker.getPublicKey()
          let fileWorker = File()
          let secretKey = "asdfqweeasdfqweeasdfqweeasdfqwee"
          let iv = "mamamamamamamama" // lenght == 16
          fileWorker.writeToFile("Ovo je text u datoteci", filename: "plaintext.txt")
          fileWorker.writeToFile(privateKey, filename: "privatni_kljuc.txt")
          fileWorker.writeToFile(publicKey, filename: "javni_kljuc.txt")
          fileWorker.writeToFile(secretKey, filename: "tajni_kljuc.txt")
          let plainText = fileWorker.returnFileContents("plaintext.txt")
          //kriptiranje asimetricno
       
          fileWorker.writeToFile(RSAworker.encryptRSA(plainText), filename: "RSAEncryptedText.txt")
          let rsaEncryptedText = fileWorker.returnFileContents("RSAEncryptedText.txt")
          let originalText = RSAworker.decryptRSA(rsaEncryptedText)
          print("RSA encrypted text:\(rsaEncryptedText)")
          print("original text:\(originalText)")
          //kriptiranje simetricno 
            do{
                let aesEncryptedText = try originalText.aesEncrypt(secretKey, iv: iv)
                fileWorker.writeToFile(aesEncryptedText, filename: "AESEncryptedText.txt")
                print("Aes encrypted text:\(aesEncryptedText)")
            }
           catch {
               print ("fail kod kriptiranja")
           }
            do{
                let aesEncryptedTextFromFile = fileWorker.returnFileContents("AESEncryptedText.txt")
                   let aesDecryptedText = try aesEncryptedTextFromFile.aesDecrypt(secretKey, iv: iv)
                   print("Aes decrypted text:\(aesDecryptedText)")
               
             }
                catch {
                    print ("fail kod dekriptiranja")
                }
           //sazetak
          let shaedText = plainText.sha512()
          fileWorker.writeToFile(shaedText, filename: "shaedText.txt")
          print("Text in sha512:\(shaedText)")
          //digitalni potpis
          let plainTextToVerify = fileWorker.returnFileContents("plaintext.txt")
          fileWorker.writeToFile(RSAworker.sign(plainTextToVerify), filename: "potpis.txt")
          let sign = fileWorker.returnFileContents("potpis.txt")
          let verified  = RSAworker.Verify(plainText,signature:sign)
        if(verified) {
            print ("Message integrity and authenticity has been verified")
        }
        else {
            print("Message integrity or authenticity has been compromised")
        }
        
        
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

