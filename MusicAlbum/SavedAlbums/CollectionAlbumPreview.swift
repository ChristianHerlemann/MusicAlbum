//
//  CollectionAlbumPreview.swift
//  MusicAlbum
//
//  Created by Chris Herlemann on 2020-07-25.
//  Copyright © 2020 Chris Herlemann. All rights reserved.
//

import UIKit

protocol AlbumPreviewDelegate: class {
   func longPress(_ album: Album)
}

class AlbumPreview: UICollectionViewCell {
   
   @IBOutlet var albumCover: UIImageView!
   @IBOutlet var albumName: UILabel!
   @IBOutlet var albumArtist: UILabel!
   
   var album: Album?
   weak var delegate: AlbumPreviewDelegate?
   
   override func awakeFromNib() {
      albumCover.layer.cornerRadius = 12
      albumCover.clipsToBounds = true
      
      let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressGestureDetected))
      self.addGestureRecognizer(longPressGesture)
   }
   
   @objc func longPressGestureDetected() {
      guard let album = album else { return }
      
      delegate?.longPress(album)
   }
}
