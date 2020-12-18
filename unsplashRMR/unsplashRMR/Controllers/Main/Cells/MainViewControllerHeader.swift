//
//  MainViewControllerHeader.swift
//  unsplashRMR
//
//  Created by Артём Скрипкин on 16.12.2020.
//

import UIKit
import Kingfisher

class MainViewControllerHeader: UICollectionReusableView {
    
    static let reusedId = "MainViewControllerHeader"
    
    weak var serviceDelegate: MainCellServiceProtocol?
    
    private var photo: PhotoModel?
    
    //MARK: - UI Elements
    private lazy var imageView: UIButton = {
        let view = UIButton(type: .custom)
        view.contentMode = .scaleAspectFit
        view.imageView?.contentMode = .scaleAspectFit
        view.imageView?.clipsToBounds = true
        view.addTarget(self, action: #selector(showDetails), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - UserIneraction Methods
    @objc private func showDetails() {
        guard let photo = photo else {
            serviceDelegate?.showAlert(type: .error, message: "PhotoModel is nil.")
            return
        }
        guard let image = imageView.currentImage else {
            serviceDelegate?.showAlert(type: .error, message: "Image is nil.")
            return
        }
        serviceDelegate?.showDetailVC(photoModel: photo, image: image)
    }
    
    //MARK: - Methods
    private func setup() {
        activityIndicator.startAnimating()
        NetworkManager.shared.getRandomPhoto() { result in
            switch result {
            case .failure(let error):
                self.serviceDelegate?.showAlert(type: .error, message: "\(error)")
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.activityIndicator.stopAnimating()
                }
            case .success(let photoModel):
//                guard let url = URL(string: photoModel.urls.regular) else { return }
                self.photo = photoModel
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.imageView.kf.setImage(with: photoModel.urls.regular, for: .normal, completionHandler: { _ in
                        self.activityIndicator.stopAnimating()
                    })
                }
            }
        }
    }
    
    private func setupConstraints() {
        addSubview(imageView)
        imageView.addSubview(activityIndicator)
        
        let constraints = [
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    //MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
