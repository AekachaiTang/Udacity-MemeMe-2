//
//  MemeEditorViewController.swift
//  MemoMe2
//
//  Created by aekachai tungrattanavalee on 18/1/2563 BE.
//  Copyright © 2563 aekachai tungrattanavalee. All rights reserved.
//

import UIKit
import Foundation

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var memeImage: UIImage!
     let textFieldDelegate = MemeTextFieldDelegate()
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var pickImageButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var imageToolbar: UIToolbar!
    
    var countTopEdits = 0
    var countBottomEdits = 0
    var meme: MemeModel?
 
 
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        cameraButton.isEnabled =  UIImagePickerController.isSourceTypeAvailable(.camera)
        
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewWillAppear(_ animated: Bool) {
           subscribeToKeyBoardNotifications()
    }
       
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           unsubscribeToKeyBoardNotifications()
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        imagePickerView.image = info[.originalImage] as? UIImage
        if let _ = imagePickerView.image {
            self.shareButton.isEnabled = true
        } else {
            self.shareButton.isEnabled = false
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        self.shareButton.isEnabled = false
        imagePickerView.image = nil
    }

    @IBAction func cancelButton(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    //IBAction
        @IBAction func share() {
            memeImage = generateImage()
            let activity = UIActivityViewController(activityItems: [memeImage!], applicationActivities: nil)
            show(activity, sender: self)
            activity.completionWithItemsHandler = {(activity, completed, items, error) in
                if (completed){
                    self.save()
                    return
                }
            }
        }
    
       @IBAction func pickAnImageFromCamera(_ sender: Any) {
           pickAnImage(.camera)
       }

       @IBAction func pickAnImageFromAlbum(_ sender: Any) {
           pickAnImage(.photoLibrary)
       }
    
    
    //End Action
    
    fileprivate func pickAnImage(_ source : UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
    }
    
    fileprivate func setTextFieldProps(_ textField: UITextField) {
        let textAttributes : [NSAttributedString.Key : Any] = [
            .strokeColor: UIColor.black,
            .foregroundColor: UIColor.white,
            .strikethroughColor: UIColor.white,
            .font: UIFont(name: "Impact", size: 40)!,
            .strokeWidth: -4.0
        ]
        textField.defaultTextAttributes = textAttributes
        textField.adjustsFontSizeToFitWidth = true
        textField.textAlignment = .center
        textField.allowsEditingTextAttributes = true
    }
    
    @objc fileprivate func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isEditing {
            view.frame.origin.y = -getKeyboardHeight(notification)
            
        }
    }
    
    @objc fileprivate func keyboardWillHide(_ notification: Notification) {
        if bottomTextField.isEditing {
            view.frame.origin.y = 0
        }
    }
    
    fileprivate func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    fileprivate func subscribeToKeyBoardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    fileprivate func unsubscribeToKeyBoardNotifications(){
           NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func generateImage() -> UIImage {
        
        hideToolbars(true)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        hideToolbars(false)
        
        return memedImage
    }
    @IBAction func sendingThePicture(_ sender: Any) {
        let memedImage = generateImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        //completion handeler
        controller.completionWithItemsHandler = {
            (_,completed: Bool,_,_)->Void
            in if completed{
                self.save()
                self.navigationController?.popToRootViewController(animated: true)
            } else{ print("The image was not saved")}
        }
        
        //controller.completionWithItemsHandler
        self.present(controller, animated: true, completion: nil)
    }
    
    fileprivate func prepareView() {
        
        //Prepare Text fields within image view
        self.topTextField.delegate = self.textFieldDelegate
        self.bottomTextField.delegate = self.textFieldDelegate
        
        self.setTextFieldProps(self.topTextField)
        self.setTextFieldProps(self.bottomTextField)
        
        //share button settings
        self.shareButton.isEnabled = false
        
    }
    
    fileprivate func hideToolbars(_ hide: Bool) {
        topToolbar.isHidden = hide
        imageToolbar.isHidden = hide
    }
    
    fileprivate func save() {
        meme = MemeModel(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generateImage())
        print("memed saved")
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        if let meme = meme{
        appDelegate.memes.append(meme)
        }
    }
    
    

}
