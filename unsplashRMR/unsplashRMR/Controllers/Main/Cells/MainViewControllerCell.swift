//
//  MainViewControllerCell.swift
//  unsplashRMR
//
//  Created by Артём Скрипкин on 16.12.2020.
//

import UIKit
import Kingfisher

class MainViewControllerCell: UICollectionViewCell {
    
    static let reusedId = "MainViewControllerCell"
    
    //MARK: - UI Elements
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Methods
    public func setPhoto(photo: PhotoModel) {
        ImageDownloader.default.downloadImage(with: photo.urls.regular, options: [.cacheMemoryOnly, .transition(.fade(0.2))], completionHandler: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error)
            case .success(let succesResult):
                self.imageView.image = succesResult.image
            }
        })
    }
    
    private func setupConstraints() {
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    //MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
