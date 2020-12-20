//
//  PhotosListProvider.swift
//  unsplashRMR
//
//  Created by Евгений Скрипкин on 20.12.2020.
//

import Foundation
class PhotosListProvider {
    private var isLoading = false
    private var currentPage = 1
    
    public var items = [PhotoModel]()
    
    private let semaphore = DispatchSemaphore(value: 1)
    
    public func fetchData(completion: @escaping (Result<Bool, Error>) -> Void) {
        guard !isLoading else { return }
        semaphore.wait()
        isLoading = true
        NetworkManager.shared.getPhotoList(page: currentPage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                completion(.failure(error))
                self.isLoading = false
                self.semaphore.signal()
            case .success(let photos):
                completion(.success(true))
                self.items.append(contentsOf: photos)
                self.currentPage += 1
                self.isLoading = false
                self.semaphore.signal()
            }
        }
    }
    
    public func item(at: Int) -> PhotoModel? {
        if at > items.count - 1 {
            return nil
        } else {
            return items[at]
        }
    }
}
