//
//  SearchViewController.swift
//  Ozinshe App
//
//  Created by Мерей Булатова on 29.09.2023.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var searchTextField: TextFieldWithPadding!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    
    var categories: [Category] = []
    
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        downloadCategories()
        hideKeyboardWhenTappedAround()
    }
    
    func configureViews() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 16.0, left: 24.0, bottom: 16.0, right: 24.0)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 16
        layout.estimatedItemSize.width = 100
        collectionView.collectionViewLayout = layout
        
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
