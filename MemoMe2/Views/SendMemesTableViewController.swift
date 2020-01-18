//
//  SendMemesTableViewController.swift
//  MemoMe2
//
//  Created by aekachai tungrattanavalee on 18/1/2563 BE.
//  Copyright © 2563 aekachai tungrattanavalee. All rights reserved.
//

import UIKit

class SendMemesTableViewController: UITableViewController {

    var memes: [MemeModel] {
       return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    @IBAction func AddMeme(_ sender: AnyObject) {
           let meme = storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController")
           navigationController?.isNavigationBarHidden = true
           tabBarController?.tabBar.isHidden = true
           navigationController!.pushViewController(meme, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       return memes.count
    }

    override func tableView(_ tableView: UITableView,  cellForRowAt indexPath: IndexPath)-> UITableViewCell {
        //obtain a cell of type Table Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TabTableViewCell
        let meme = memes[indexPath.row]
        cell.tableCellImageView.image = meme.memedImage
        cell.tableCellLabel.text = meme.topText + " " + meme.bottomText
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let meme = memes[indexPath.row]
        controller.meme = meme
    
        let backButton = UIBarButtonItem()
        backButton.title = "TableView"
        navigationItem.backBarButtonItem = backButton
        navigationController?.pushViewController(controller, animated: true)
        
        
    }

}
