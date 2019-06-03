//
//  PhotoSelectorController.swift
//  SmartCampus
//
//  Created by Tommy Chavez on 1/17/19.
//  Copyright © 2019 Tommy Chavez. All rights reserved.
//

import UIKit

class PhotoSelectorController: UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        //collectionView?.backgroundColor = .yellow
        setupNavigationButtons()
        
}
fileprivate func setupNavigationButtons(){
    navigationController?.navigationBar.tintColor = .black
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleCancel))
    }
    
    @objc func handleCancel(){
        
    }

}
