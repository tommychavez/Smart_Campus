//
//  videofilecontroller.swift
//  SmartCampus
//
//  Created by Tommy Chavez on 6/19/19.
//  Copyright © 2019 Tommy Chavez. All rights reserved.
//


import UIKit

// #1 - Create an object for browsing the iOS file
// system. It adopts a protocols that notifies
// the browser class when users interact with documents.
class viewfilecontroller: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // #1.1 - Set the delegate of the UIDocumentBrowserViewControllerDelegate
        // protocol to the DocumentBrowserViewController class.
        delegate = self
        
        // #1.2 - I'm not going to do anything fancy.
        // COMMENT OUT: allowsDocumentCreation = true
        allowsPickingMultipleItems = false
        
        // Update the style of the UIDocumentBrowserViewController
        // browserUserInterfaceStyle = .dark
        // view.tintColor = .white
        
        // Specify the allowed content types of your application via the Info.plist.
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // MARK: UIDocumentBrowserViewControllerDelegate
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        let newDocumentURL: URL? = nil
        
        // Set the URL for the new document here. Optionally, you can present a template chooser before calling the importHandler.
        // Make sure the importHandler is always called, even if the user cancels the creation request.
        if newDocumentURL != nil {
            importHandler(newDocumentURL, .move)
        } else {
            importHandler(nil, .none)
        }
    }
    
    // #2.0 - "When the user selects one or more documents in the browser view controller,
    // the system calls your delegate's documentBrowser(_:didPickDocumentURLs:) method."
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentURLs documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        print("clicked")
        //vc = PostPopUpViewController()
        print(sourceURL)
//        navigationController?.popViewController(animated: true)
//        let vc = PostPopUpViewController()
//        vc.songurl = sourceURL.absoluteString
//        
        let a = self.navigationController?.viewControllers[0] as! PostPopUpViewController
        a.songurl = sourceURL.absoluteString
        self.navigationController?.popToViewController(a,animated: true)
        
       // self.navigationController?.popViewController(animated: true)
       //self.navigationController?.popViewController(vc, animated: true)
      //  print(sourceURL)

        // #2.1 - Present the Document View Controller for the first document that was picked.
        // If you support picking multiple items, make sure you handle them all.
        presentDocument(at: sourceURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        // Present the Document View Controller for the new newly created document
        presentDocument(at: destinationURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
    }
    
    // MARK: Document Presentation
    
    // #3.0 - Prepare for and present my custom user interface
    // which uses a UIDocument subclass to manipulate and/or
    // display the user-select document.
    func presentDocument(at documentURL: URL) {
        
        // #3.1 - Get the UIViewController scene on the right side of Main.storyboard
        // which is backed by the DocumentViewController class in the
        // DocumentViewController.swift file and instantiate it.
        // That's my custom UI.
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let documentViewController = storyBoard.instantiateViewController(withIdentifier: "DocumentViewController") as! DocumentViewController
        
        // #3.2 - In the template project, the DocumentViewController
        // class has a member "document" of type UIDocument, which is an
        // "abstract base class." I had to subclass UIDocument.
        // I then initialize my UIDocument subclass.
        //documentViewController.document = UIDocument(fileURL: documentURL)
        
        // #3.3 - Present my custom user interface for
        // displaying and manipulating a user-selected
        // document.
       // present(documentViewController, animated: true, completion: nil)
        
    }
    
} // end class DocumentBrowserViewController
