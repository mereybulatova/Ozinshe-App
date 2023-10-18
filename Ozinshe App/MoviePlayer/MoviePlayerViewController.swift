//
//  MoviePlayerViewController.swift
//  Ozinshe App
//
//  Created by Мерей Булатова on 16.10.2023.
//

import UIKit
import YouTubePlayer

class MoviePlayerViewController: UIViewController {
    @IBOutlet weak var player: YouTubePlayerView!
    
    var video_link = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        player.loadVideoID(video_link)
    }

}
