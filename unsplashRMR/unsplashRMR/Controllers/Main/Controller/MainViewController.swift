//
//  MainViewController.swift
//  unsplashRMR
//
//  Created by Артём Скрипкин on 16.12.2020.
//

import UIKit
class MainViewController: UIViewController {
    
    private let dataSource = PhotosListProvider()
    
    //MARK: - UI Elements
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: self.view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        view.register(MainViewControllerCell.self, forCellWithReuseIdentifier: MainViewControllerCell.reusedId)
        view.register(MainViewControllerHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MainViewControllerHeader.reusedId)
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .white
        return view
    }()
    
    //MARK: - Methods
    private func setup() {
        view.addSubview(collectionView)
        view.backgroundColor = .white
    }
    
    private func loadPhotos() {
        dataSource.fetchData() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                Alert.showAlert(vc: self, title: .error, message: "\(error)")
            case .success(_):
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadPhotos()
    }
}

//MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(dataSource.items.count)
        return dataSource.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainViewControllerCell.reusedId, for: indexPath)
        
        if let cell = cell as? MainViewControllerCell {
            guard let photo = dataSource.item(at: indexPath.row) else { return cell }
            cell.setPhoto(photo: photo)
        }
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MainViewControllerHeader.reusedId, for: indexPath) as? MainViewControllerHeader else { fatalError() }
            cell.serviceDelegate = self
            return cell
        default:
            fatalError()
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: view.bounds.width, height: 200)
    }
}

//MARK: - MainCellServiceProtocol
extension MainViewController: MainCellServiceProtocol {
    func showAlert(type: Alert.alertTypes, message: String) {
        Alert.showAlert(vc: self, title: type, message: message)
    }
    
    func showDetailVC(photoModel: PhotoModel, image: UIImage) {
        let vc = PhotoDetailsViewController(photoModel: photoModel, image: image)
        present(vc, animated: true, completion: nil)
    }
}
