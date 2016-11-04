//
//  ViewController.swift
//  MusicSearch
//
//  Created by Użytkownik Gość on 13.10.2016.
//  Copyright © 2016 Użytkownik Gość. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var albums: NSMutableArray = []
    var albumsDocPath: String = ""
    let plistPath = NSBundle.mainBundle().pathForResource("albums", ofType: "plist")!
	var currentItem  = 0

    @IBOutlet weak var lblRecords: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPrev: UIButton!
    @IBOutlet weak var tbArtist: UITextField!
    @IBOutlet weak var tbTittle: UITextField!
    @IBOutlet weak var tbGenre: UITextField!
    @IBOutlet weak var tbYear: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var stpRating: UIStepper!
    
    @IBAction func tbArtistTextChanged(sender: AnyObject) {
        allowToSave()
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
		
		if albums.count > 0
		{
			currentItem = 1;
		}
		loadAlbumToView();
        btnPrev.enabled = false;
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
	
	@IBAction func btnNextPressed(sender: AnyObject) 
	{
		if currentItem == albums.count
		{
			currentItem = 0;
		}
		else
		{
			currentItem += 1;
		}
        
        if currentItem != 1
        {
            btnPrev.enabled = true;
        }
        
		loadAlbumToView();
	}
	
	@IBAction func btnPrevPressed(sender: AnyObject) 
	{
        if currentItem == 0
        {
            currentItem = (albums.count);
        }
		else
		{
			currentItem -= 1;
            
            if currentItem == 1
            {
                btnPrev.enabled = false
            }
		}
		loadAlbumToView();
	}
	
	@IBAction func btnNewPressed(sender: AnyObject) 
	{
		currentItem = 0;
        btnPrev.enabled = true
		loadAlbumToView();
	}
	
	@IBAction func btnSavePressed(sender: AnyObject) 
    {
            albums = NSMutableArray(contentsOfFile: albumsDocPath)!
        let ud = NSUserDefaults.standardUserDefaults()
		if(currentItem != 0)
		{
        let newDict =  NSDictionary(dictionary:[ "artist":tbArtist.text!, "genre":tbGenre.text!, "title":tbTittle.text!, "date":tbYear.text!, "rating":lblRating.text! ]);
            albums.replaceObjectAtIndex(currentItem - 1, withObject: newDict);
		}
        else{
            let newDict =  NSDictionary(dictionary:[ "artist":tbArtist.text!, "genre":tbGenre.text!, "title":tbTittle.text!, "date":tbYear.text!, "rating":lblRating.text!  ]);
            albums.addObject(newDict);
            currentItem = (albums.count)
		}
        
        ud.setObject(albums, forKey: "album")
        btnSave.enabled = false;
        loadAlbumToView()
	}
    
    @IBAction func btnDeletePressed(sender: AnyObject) {
            albums = NSMutableArray(contentsOfFile: albumsDocPath)!
            albums.removeObjectAtIndex(currentItem - 1);
			let ud = NSUserDefaults.standardUserDefaults()
			ud.setObject(albums, forKey: "album")
            currentItem -= 1;
            loadAlbumToView();
    }
	
	func loadAlbumToView()
	{
		if(currentItem != 0)
		{
            let artist = (albums.objectAtIndex(currentItem - 1)).objectForKey("artist")
            tbArtist.text = "\(artist!)";
            let genre = (albums.objectAtIndex(currentItem - 1)).objectForKey("genre")
            tbGenre.text = "\(genre!)";
            
            let title = (albums.objectAtIndex(currentItem - 1)).objectForKey("title")
            if let titlev = title
            {
                tbTittle.text = "\(titlev)";
            }
            else{
                tbTittle.text = "";
            }
            
            let year = (albums.objectAtIndex(currentItem - 1)).objectForKey("date")
            if let yearv = year
            {
                tbYear.text = "\(yearv)";
            }
            else{
                tbYear.text = ""
            }
            
            let rating = (albums.objectAtIndex(currentItem - 1)).objectForKey("rating")
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
            
            lblRecords.text = "Record \(currentItem) of \(albums.count)";
            btnNext.enabled = true
		}
		else
		{
			tbArtist.text = "";
			tbGenre.text = "";
			tbTittle.text = "";
            tbYear.text = "";
            lblRating.text = "0";
            stpRating.value = 0
            lblRecords.text = "New album";
            btnNext.enabled = false
		}		
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

