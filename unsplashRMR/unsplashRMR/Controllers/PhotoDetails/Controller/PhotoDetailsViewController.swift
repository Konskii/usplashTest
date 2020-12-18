//
//  PhotoDetailsViewController.swift
//  unsplashRMR
//
//  Created by Артём Скрипкин on 17.12.2020.
//

import UIKit
import Kingfisher
class PhotoDetailsViewController: UIViewController {
    //MARK: - Variables
    private var photo: PhotoModel? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private var image: UIImage?
    
    private let downloader = ImageDownloader.default
    
    //MARK: - UI Elements
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.frame, style: .insetGrouped)
        
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Methods
    private func setup() {
        view.addSubview(tableView)
        setupConstraints()
    }
    
    @objc private func savePhotoCompletion(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            Alert.showAlert(vc: self, title: .error, message: "'\(error)'")
        } else {
            Alert.showAlert(vc: self, title: .succes, message: "Saving completed.")
        }
    }
    
    private func setupConstraints() {
        view.addSubview(activityIndicator)
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    /// - Parameters:
    /// - Parameter photo: модель фотографии детали которой нужно отобразить
    public func setPhoto(photo: PhotoModel) {
        self.photo = photo
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //MARK: - Inits
    convenience init(photoModel: PhotoModel, image: UIImage) {
        self.init()
        self.photo = photoModel
        self.image = image
    }
}

//MARK: - UITableViewDataSource
extension PhotoDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        var configuration = cell.defaultContentConfiguration()
        switch indexPath.row {
        case 0:
            configuration.text = "Описание"
            guard let photoDescription = photo?.description else {
                configuration.secondaryText = "Описание отсутствует"
                break
            }
            configuration.secondaryText = photoDescription
        case 1:
            configuration.text = "Ширина"
            guard let width = photo?.width else { break }
            configuration.secondaryText = "\(width)"
        case 2:
            configuration.text = "Высота"
            guard let height = photo?.height else { break }
            configuration.secondaryText = "\(height)"
        case 3:
            configuration.text = """
                Ссылка на изображение в высоком качестве
                (Нажмите для загрузки)
                """
            guard let url = photo?.urls.full else { break }
            configuration.secondaryText = url.relativeString
        default:
            break
        }
        cell.contentConfiguration = configuration
        return cell
    }
}

//MARK: - UITableViewDelegate
extension PhotoDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = PhotoDetailsHeader(image: image)
        header.serviceDelegate = self
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            guard let url = photo?.urls.full else {
                Alert.showAlert(vc: self, title: .error, message: "photo full string")
                self.tableView.deselectRow(at: indexPath, animated: true)
                return
            }
            activityIndicator.startAnimating()
            downloader.downloadImage(with: url, completionHandler:  { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async { self.activityIndicator.stopAnimating() }
                    Alert.showAlert(vc: self, title: .error, message: "\(error)")
                    self.tableView.deselectRow(at: indexPath, animated: true)
                case .success(let resultImage):
                    DispatchQueue.main.async { self.activityIndicator.stopAnimating() }
                    UIImageWriteToSavedPhotosAlbum(resultImage.image, self, #selector(self.savePhotoCompletion(_:didFinishSavingWithError:contextInfo:)), nil)
                    self.tableView.deselectRow(at: indexPath, animated: true)
                }
            })
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        if (action.description == "copy:") {
            return true
        } else {
            return false
        }
    }

    func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        if (action.description == "copy:") {
            switch indexPath.row {
            case 0:
                guard let photoDescription = photo?.description else { return }
                UIPasteboard.general.string = photoDescription
            case 1:
                guard let photoWidth = photo?.width else { return }
                UIPasteboard.general.string = "\(photoWidth)"
            case 2:
                guard let photoHeight = photo?.height else { return }
                UIPasteboard.general.string = "\(photoHeight)"
            case 3:
                guard let photoFullUrl = photo?.urls.full else { return }
                UIPasteboard.general.url = photoFullUrl
            default:
                return
            }
            
        }
    }

    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

//MARK: - PhotoDetailsHeaderServiceProtocol
extension PhotoDetailsViewController: PhotoDetailsHeaderServiceProtocol {
    func showAlert(type: Alert.alertTypes, message: String) {
        Alert.showAlert(vc: self, title: type, message: message)
    }
}
