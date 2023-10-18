//
//  MainBannerTableViewCell.swift
//  Ozinshe App
//
//  Created by Мерей Булатова on 13.10.2023.
//

import UIKit

class MainBannerTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate : MovieProtocol?
    
    var mainMovie = MainMovies()
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        let layout = TopAlignedCollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 22.0, left: 24.0, bottom: 10, right: 24.0)
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.estimatedItemSize.width = 300
        layout.estimatedItemSize.height = 218
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData(mainMovie: MainMovies) {
        
        self.mainMovie = mainMovie
        
        collectionView.reloadData()
    }
    //MARK: - collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainMovie.bannerMovie.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerCell", for: indexPath) as! BannerCollectionViewCell
        
        cell.setData(bannerMovie: mainMovie.bannerMovie[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.movieDidSelect(movie: mainMovie.bannerMovie[indexPath.row].movie)
    }
}

