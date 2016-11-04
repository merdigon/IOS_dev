//
//  MusicTableViewController.swift
//  MusicSearch
//
//  Created by merdigon on 11/1/16.
//  Copyright © 2016 Użytkownik Gość. All rights reserved.
//

import UIKit

class MusicTableViewController: UITableViewController {

    var albums: NSMutableArray = []
    var albumsDocPath: String = ""
    let plistPath = NSBundle.mainBundle().pathForResource("albums", ofType: "plist")!
    var selectedIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RefreshTableView()
    }
    
    @IBAction func onBack(sender: UIStoryboardSegue)
    {
        RefreshTableView()
        tableView!.reloadData()
    }
    
    func RefreshTableView(){
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        albumsDocPath = documentsPath.stringByAppendingString("/albums.plist")
        let fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(albumsDocPath)
        {
            try? fileManager.copyItemAtPath(plistPath, toPath: albumsDocPath)
        }
        albums = NSMutableArray(contentsOfFile: albumsDocPath)!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "MusicTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MusicTableViewCell
        
        let album = albums[indexPath.row]
        let artist = album.objectForKey("artist")
        let title = album.objectForKey("title")
        if let titlev = title
        {
            cell.lblTitle.text = "\(titlev)"
        }
        else{
            cell.lblTitle.text = ""
        }
        if let artistv = artist
        {
            cell.lblArtist.text = "\(artistv)"
        }
        else
        {
            cell.lblArtist.text = ""
        }
        
        return cell
    }
    /*
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //selectedIndex = indexPath.row
        //performSegueWithIdentifier("showMusic", sender: self)
    }
*/
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showMusic"){
            let viewController = segue.destinationViewController as! ViewController
            let index = tableView.indexPathForCell(sender as! MusicTableViewCell)
            viewController.selectedIndex = index!.row
        }
        else if(segue.identifier == "newMusic"){
            let viewController = segue.destinationViewController as! ViewController
            viewController.isNew = true;
        }
    }
 

}
