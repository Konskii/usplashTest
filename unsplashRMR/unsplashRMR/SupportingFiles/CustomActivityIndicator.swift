//
//  ActivityIndicatorExtension.swift
//  unsplashRMR
//
//  Created by Артём Скрипкин on 18.12.2020.
//

import UIKit

class CustomActivityIndicator: UIView {
    
    private lazy var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var percantageLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Methods
    public func stopAnimating() {
        indicator.stopAnimating()
        percantageLabel.isHidden = true
        backgroundView.isHidden = true
    }
    
    public func startAnimating() {
        backgroundView.isHidden = false
        percantageLabel.isHidden = false
        indicator.startAnimating()
    }
    
    ///  Вы можете показать пользователю прогресс выполнения чего-либо, это отобразиться в виде  "22%/100%"
    /// - Parameter percantage: Процент выолненной части от выполняемой
    public func setPercantage(percantage: Float) {
        percantageLabel.text = "\(percantage.rounded(.toNearestOrAwayFromZero))%/100%"
    }
    
    ///  Вы можете показать пользователю прогресс загрузки файла
    /// - Parameter MBytes: Количество загруженного от загружаемого (в мегабайтах)
    /// - Parameter maxMBytes: Количество  загружаемого (в мегабайтах)
    public func setMBytes(MBytes: Float, maxMBytes: Float) {
        let mbytes = MBytes
        let maxmbytes = maxMBytes
        percantageLabel.text = "Downloaded \(mbytes.rounded(.toNearestOrEven))MBytes/\(maxmbytes.rounded(.toNearestOrEven))MBytes"
    }
    
    //TODO
    //MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backgroundView)
        backgroundView.isHidden = true
        backgroundView.addSubview(indicator)
        backgroundView.addSubview(percantageLabel)
        
        indicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        indicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        percantageLabel.topAnchor.constraint(equalTo: indicator.bottomAnchor, constant: 5).isActive = true
        percantageLabel.centerXAnchor.constraint(equalTo: indicator.centerXAnchor).isActive = true
        
        backgroundView.topAnchor.constraint(equalTo: indicator.topAnchor, constant: -10).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: percantageLabel.leadingAnchor, constant: -10).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: percantageLabel.bottomAnchor, constant: 10).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: percantageLabel.trailingAnchor, constant: 10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
