//
//  MainViewController.swift
//  unsplashRMR
//
//  Created by Евгений Скрипкин on 16.12.2020.
//

import UIKit
class MainViewController: UIViewController {
    //MARK: - UI Elements
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let view = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        view.backgroundColor = .white
        return view
    }()
    
    //MARK: - Methods
    private func setup() {
        view.addSubview(collectionView)
        view.backgroundColor = .white
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

//MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell()
    }
}

//MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    
}
