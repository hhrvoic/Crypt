//
//  ViewControllerKriptTab.swift
//  Crypt
//
//  Created by Faculty of Organisation and Informatics on 27/11/15.
//  Copyright © 2015 air. All rights reserved.
//

import UIKit
import CryptoModule
import FileModule
class ViewControllerKriptTab: UIViewController,UITextViewDelegate  {
    
    @IBOutlet weak var lblVerified: UILabel!
    @IBOutlet weak var hashTxtView: UITextView!
    @IBOutlet weak var signTxtView: UITextView!
    @IBOutlet weak var rsaPublicKeyTxtView: UITextView!
    @IBOutlet weak var rsaPrivateKeyTxtView: UITextView!
    @IBOutlet weak var rsaEncryptedTxt: UITextView!
    @IBOutlet weak var rsaPrivateKeyLbl: UILabel!
   
    @IBOutlet weak var rsaPublicKeyLbl: UILabel!
    @IBOutlet weak var aesKey: UITextField!
    var fileWorker: File = File()
    @IBOutlet weak var nazivDat: UITextField!
    var RSAworker: RSASign = RSASign ()
    @IBOutlet weak var sadrzajDat: UITextView!
    @IBOutlet weak var simKriptTxtView: UITextView!
    
    @IBAction func OnSecretKeyChange(sender: UITextField) {
        storeSecretKeyToFile()
    }
    @IBAction func onAesCryptSwtichValueChanged(sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex==0){
            loadSimCryptedTextFromFile()
        }
        else {
            let key = fileWorker.returnFileContents("tajni_kljuc.txt")
            let iv = fileWorker.returnFileContents("iv.txt")
            loadDecryptedTextAes("AESEncryptedText.txt",key: key,iv : iv)
        }
        
    }
    @IBAction func onEnDecryptRSA(sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex==0){
            loadEncryptedTextRSA()
        }
        else {
            loadDecryptedTextRSA()
        }
    }
    
    @IBAction func onNazivDatChange(sender: UITextField) {
        print("bokic")
        let sadrzajDatoteke = fileWorker.returnFileContents(sender.text!)
        if(sadrzajDatoteke != ""){
            sadrzajDat.text = sadrzajDatoteke
            aesKriptiraj(sadrzajDatoteke)
            loadSimCryptedTextFromFile()
            loadSecretKeyFromFile()
            rsaKriptiraj(sadrzajDatoteke)
            loadEncryptedTextRSA()
            loadRSAKeysFromFile()
        }
        else {
            //dialog
            sadrzajDat.text = "Nema fajla tog!"
        }
        
    }
    
    @IBAction func onSignBtn(sender: UIButton) {
         storeSignToFile()
         loadSignFromFile()
    }
    @IBAction func onVerifyBtn(sender: UIButton) {
        verifySign()
    }
    
    //POM FUNKCIJE
    internal func randomStringWithLength (len : Int) -> String  {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        
        for (var i=0; i < len; i++){
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString as String
    }
        func aesKriptiraj(originalText:String){
        let iv = randomStringWithLength(16)
        let secretKey = randomStringWithLength(32)
        fileWorker.writeToFile(secretKey, filename: "tajni_kljuc.txt")
        fileWorker.writeToFile(iv, filename: "iv.txt")
        do{
            let aesEncryptedText = try originalText.aesEncrypt(secretKey, iv: iv)
            fileWorker.writeToFile(aesEncryptedText, filename: "AESEncryptedText.txt")
            print("Aes encrypted text:\(aesEncryptedText)")
        }
        catch {
            print ("fail kod kriptiranja") //dialog neki
        }
        
    }
    func loadSimCryptedTextFromFile(){
        simKriptTxtView.text=fileWorker.returnFileContents("AESEncryptedText.txt")
    }
    func loadSecretKeyFromFile(){
        aesKey.text=fileWorker.returnFileContents("tajni_kljuc.txt")
    }
    func storeSecretKeyToFile(){
        if(aesKey.text!.characters.count != 16 && aesKey.text!.characters.count != 24 && aesKey.text!.characters.count != 32 ){
                //tu ide dialog/modal
                print("loš odabir ključa")
                fileWorker.writeToFile(randomStringWithLength(32), filename: "tajni_kljuc.txt")
                loadSecretKeyFromFile()
            }
        else {
            fileWorker.writeToFile(aesKey.text!, filename: "tajni_kljuc.txt")
        }
    }
    func loadDecryptedTextAes(filename: String, key:String, iv:String){
        do{
            let aesEncryptedTextFromFile = fileWorker.returnFileContents("AESEncryptedText.txt")
             simKriptTxtView.text = try aesEncryptedTextFromFile.aesDecrypt(key, iv: iv)
        }
        catch {
             simKriptTxtView.text = "fail kod dekriptiranja"
        }

    }
   //RSA
    func rsaKriptiraj(originalText:String){
        let privateKey = RSAworker.getPrivateKey()
        let publicKey = RSAworker.getPublicKey()
        fileWorker.writeToFile(privateKey, filename: "privatni_kljuc.txt")
        fileWorker.writeToFile(publicKey, filename: "javni_kljuc.txt")
        fileWorker.writeToFile(RSAworker.encryptRSA(originalText), filename: "RSAEncryptedText.txt")
        
    }

    func loadEncryptedTextRSA(){
        rsaEncryptedTxt.text = fileWorker.returnFileContents("RSAEncryptedText.txt")
    }
    func loadDecryptedTextRSA(){
        rsaEncryptedTxt.text = RSAworker.decryptRSA(fileWorker.returnFileContents("RSAEncryptedText.txt"))
    }
    func loadRSAKeysFromFile(){
        print("velicina kljuca je")
        var kljuc = fileWorker.returnFileContents("privatni_kljuc.txt")
        print (kljuc.characters.count)
  
        rsaPrivateKeyTxtView.text! = fileWorker.returnFileContents("privatni_kljuc.txt")
        rsaPublicKeyTxtView.text! = fileWorker.returnFileContents("javni_kljuc.txt")
    }
    //SIGN
    func storeSignToFile () {
        hashTxtView.text = sadrzajDat.text.sha512()
        //tu dodat
        //digitalni potpis
        fileWorker.writeToFile(RSAworker.sign(sadrzajDat.text), filename: "potpis.txt")
    }
    func storeModifiedSignToFile(){
        fileWorker.writeToFile(signTxtView.text, filename: "potpis.txt")
    }
    func loadSignFromFile(){
        signTxtView.text = fileWorker.returnFileContents("potpis.txt")
        
    }
    func verifySign () {
        let sign = fileWorker.returnFileContents("potpis.txt")
        let verified = RSAworker.Verify(sadrzajDat.text,signature: sign)
        if(verified){
            let alert = UIAlertController(title: "✅", message: "Potpis je verificiran", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "❌", message: "Potpis nije verificiran", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            
        }
    }
    func prettyfyTextView(txtview:UITextView){
        txtview.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
        txtview.layer.borderWidth = 1.0
        txtview.layer.cornerRadius = 5
        txtview.layer.borderWidth = 1
    }
    func prettyfyTextViews(){
        prettyfyTextView(hashTxtView)
        prettyfyTextView(rsaPublicKeyTxtView)
        prettyfyTextView(rsaPrivateKeyTxtView)
        prettyfyTextView(rsaEncryptedTxt)
        prettyfyTextView(sadrzajDat)
        prettyfyTextView(simKriptTxtView)
        prettyfyTextView(hashTxtView)
        prettyfyTextView(signTxtView)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        signTxtView.delegate=self
        prettyfyTextViews()
        
    }
    func textViewDidChange(textView: UITextView) {//Handle the text changes here
        if(textView==signTxtView){
          storeModifiedSignToFile()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

