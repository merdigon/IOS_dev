//
//  ViewController.swift
//  MusicSearch
//
//  Created by Użytkownik Gość on 13.10.2016.
//  Copyright © 2016 Użytkownik Gość. All rights reserved.
//

import UIKit

class ViewController : UIViewController {
    var albums: NSMutableArray = []
    var albumsDocPath: String = ""
    let plistPath = NSBundle.mainBundle().pathForResource("albums", ofType: "plist")!
    var selectedIndex = 0
    var isNew = false

    @IBOutlet weak var tbArtist: UITextField!
    @IBOutlet weak var tbTittle: UITextField!
    @IBOutlet weak var tbGenre: UITextField!
    @IBOutlet weak var tbYear: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var stpRating: UIStepper!
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBAction func tbArtistTextChanged(sender: AnyObject) {
        allowToSave()
    }
    
    @IBAction func btnCancel_Pressed(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func tbTitleTextChanged(sender: AnyObject) {
        allowToSave();
    }
    
    @IBAction func tbGenreTextChanged(sender: AnyObject) {
        allowToSave();
    }
    
    @IBAction func tbYearTextChanged(sender: AnyObject) {
        allowToSave();
    }
    
    
    func allowToSave(){
        btnSave.enabled = true;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        albumsDocPath = documentsPath.stringByAppendingString("/albums.plist")
        let fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(albumsDocPath)
        {
            try? fileManager.copyItemAtPath(plistPath, toPath: albumsDocPath)
        }
        albums = NSMutableArray(contentsOfFile: albumsDocPath)!
		loadAlbumToView();
        btnSave.enabled = false;
    }
    
    @IBAction func stpRatingChanged(sender: AnyObject) {
        if stpRating.value < 0
        {
            stpRating.value = 0;
        }
        else if stpRating.value > 5
        {
            stpRating.value = 5;
        }
        else
        {
            btnSave.enabled = true
        }
        
        lblRating.text = NSString(format: "%.0f", stpRating.value) as String;
    }
	
	@IBAction func btnSavePressed(sender: AnyObject) 
    {
            albums = NSMutableArray(contentsOfFile: albumsDocPath)!
		if(isNew)
        {
            let newDict =  NSDictionary(dictionary:[ "artist":tbArtist.text!, "genre":tbGenre.text!, "title":tbTittle.text!, "date":tbYear.text!, "rating":lblRating.text!  ]);
            albums.addObject(newDict);
		}
        else
        {
            let newDict =  NSDictionary(dictionary:[ "artist":tbArtist.text!, "genre":tbGenre.text!, "title":tbTittle.text!, "date":tbYear.text!, "rating":lblRating.text! ]);
            albums.replaceObjectAtIndex(selectedIndex, withObject: newDict);
		}
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.setObject(albums, forKey: "albums")
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func btnDeletePressed(sender: AnyObject) {
            albums = NSMutableArray(contentsOfFile: albumsDocPath)!
        albums.removeObjectAtIndex(selectedIndex);
        let userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.setObject(albums, forKey: "albums")
        navigationController?.popViewControllerAnimated(true)
    }
	
	func loadAlbumToView()
	{
		if(!isNew)
		{
            let artist = albums.objectAtIndex(selectedIndex).objectForKey("artist")
            tbArtist.text = "\(artist!)";
            let genre = albums.objectAtIndex(selectedIndex).objectForKey("genre")
            tbGenre.text = "\(genre!)";
            
            let title = albums.objectAtIndex(selectedIndex).objectForKey("title")
            if let titlev = title
            {
                tbTittle.text = "\(titlev)";
            }
            else{
                tbTittle.text = "";
            }
            
            let year = albums.objectAtIndex(selectedIndex).objectForKey("date")
            if let yearv = year
            {
                tbYear.text = "\(yearv)";
            }
            else{
                tbYear.text = ""
            }
            
            let rating = albums.objectAtIndex(selectedIndex).objectForKey("rating")
            if let ratingv = rating
            {
                lblRating.text = "\(ratingv)";
                let ratingd = Double("\(ratingv)");
                stpRating.value = ratingd!;
            }
            else{
                lblRating.text = "0"
                stpRating.value = 0
            }
		}
		else
		{
			tbArtist.text = "";
			tbGenre.text = "";
			tbTittle.text = "";
            tbYear.text = "";
            lblRating.text = "0";
            stpRating.value = 0
            btnDelete.enabled = false
		}		
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            let viewController = segue.destinationViewController as! MusicTableViewController
            viewController.RefreshTableView()
    }
}

