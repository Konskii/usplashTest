//
//  PhotoDetailsHeader.swift
//  unsplashRMR
//
//  Created by Артём Скрипкин on 18.12.2020.
//

import UIKit
import Kingfisher

class PhotoDetailsHeader: UICollectionReusableView {
    
    static let reusedId = "MainViewControllerHeader"
    
    weak var serviceDelegate: PhotoDetailsHeaderServiceProtocol?
    
    //MARK: - UI Elements
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Methods
    private func setupConstraints() {
        addSubview(imageView)
        
        let constraints = [
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    //MARK: - Inits
    convenience init(image: UIImage?) {
        self.init()
        self.imageView.image = image
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
