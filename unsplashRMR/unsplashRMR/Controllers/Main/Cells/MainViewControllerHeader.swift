//
//  MainViewControllerHeader.swift
//  unsplashRMR
//
//  Created by Артём Скрипкин on 16.12.2020.
//

import UIKit

class MainViewControllerHeader: UICollectionReusableView {
    
    static let reusedId = "MainViewControllerHeader"
    
    private var photo: PhotoModel?
    
    //MARK: - UI Elements
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .top
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Methods
    private func setup() {
        NetworkManager.shared.getRandomPhoto() { result in
            switch result {
            case .failure(let error):
                print("\(error)")
            case .success(let photo):
                DispatchQueue.main.async {
                    self.imageView.image = photo
                }
            }
        }
    }
    
    private func setupConstraints() {
        addSubview(imageView)
        
        let constraints = [
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    //MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        backgroundColor = .green
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
