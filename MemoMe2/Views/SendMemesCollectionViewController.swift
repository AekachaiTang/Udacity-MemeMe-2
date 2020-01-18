//
//  SendMemesCollectionViewController.swift
//  MemoMe2
//
//  Created by aekachai tungrattanavalee on 18/1/2563 BE.
//  Copyright © 2563 aekachai tungrattanavalee. All rights reserved.
//

import UIKit

private let reuseIdentifier = "cell"

class SendMemesCollectionViewController: UICollectionViewController {

    @IBOutlet weak var layoutFlow: UICollectionViewFlowLayout!
    var memes: [MemeModel] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    @IBAction func AddMeme(_ sender: AnyObject) {
        let meme = storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController")
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = true
        navigationController!.pushViewController(meme, animated: true)
    }
    
  
    
    override func viewWillAppear(_ animated: Bool) {
       
        let spacex: CGFloat = 0.5
        let spacey: CGFloat = 0.5
        
        let dimensionx = (self.view.frame.width -  2*spacex)/3
        layoutFlow.minimumLineSpacing = spacey
        layoutFlow.minimumInteritemSpacing = spacex
        if self.view.frame.width < self.view.frame.height{
            layoutFlow.itemSize = CGSize( width: dimensionx , height: dimensionx)}
        else{
            layoutFlow.itemSize = CGSize( width: dimensionx/1.5 , height: dimensionx/1.5)
        }
        
        //make Sure the tab bar is present and navigation bar are present
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
        
        //reload the data in case there is new memes
        self.collectionView?.reloadData()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition( to: size, with: coordinator)
        
        
        let spacex: CGFloat = 0.5
        let spacey: CGFloat = 0.5
        let dimensionx = (size.width - 2*spacex)/3
       
        layoutFlow.minimumLineSpacing = spacey
        layoutFlow.minimumInteritemSpacing = spacex
        if size.width < size.height{
            layoutFlow.itemSize = CGSize( width: dimensionx , height: dimensionx)}
        else{
            layoutFlow.itemSize = CGSize( width: dimensionx/1.5 , height: dimensionx/1.5)
        }
        
    }
    

    // MARK: UICollectionViewDataSource


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        //print(memes.count)
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TabCollectionViewCell
        let meme = memes[indexPath.row]
        cell.collectionCellImage.image = meme.memedImage
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let meme = memes[indexPath.row]
        controller.meme = meme
        
        //set the title of the back button
        let leftBackButton = UIBarButtonItem()
        leftBackButton.title = "CollectionView"
        navigationItem.backBarButtonItem = leftBackButton
        navigationController?.pushViewController(controller, animated: true)
        
    }

    

}
