//
//  LocalStorage .swift
//  ImagesFeedApp
//
//  Created by Людмила Долонтаева on 6/14/23.
//

import Foundation

final class LocalStorage {

    private let userDefaults = UserDefaults.standard
    private let photosKey = "BookmarkPhoto"
    private var selectedPhotos: [String: ImagesScreenModel] = [:]
    private var shouldSave = false

    init() {
        update()
    }

    func unlikePhoto(photoItem: ImagesScreenModel) {
        selectedPhotos[photoItem.id] = nil
        updateIfNeeded()
    }

    func likePhoto(photoItem: ImagesScreenModel) {
        selectedPhotos[photoItem.id] = photoItem
        updateIfNeeded()
    }

    func isLiked(photoId: String) -> Bool {
        selectedPhotos.keys.contains(photoId)
    }

    func toggle(photoItem: ImagesScreenModel) {
        if isLiked(photoId: photoItem.id) {
            unlikePhoto(photoItem: photoItem)
        } else {
            likePhoto(photoItem: photoItem)
        }
    }

    func getSavedPhotos() -> [ImagesScreenModel] {
        Array(selectedPhotos.values)
    }

    func update() {
        let photos = fetchPhotos()

        for photo in photos {
            selectedPhotos[photo.id] = photo
        }
    }

    private func updateIfNeeded() {
        shouldSave = true
        DispatchQueue.main.async {
            self.save()
        }
    }

    private func save() {
        guard shouldSave
        else { return }

        savePhotos()
        shouldSave = false
    }

    private func fetchPhotos() -> [ImagesScreenModel] {
        guard let data = userDefaults.object(forKey: photosKey) as? Data
        else { return [] }
        return (try? JSONDecoder().decode([ImagesScreenModel].self, from: data)) ?? []
    }

    private func savePhotos() {
        guard let data = try? JSONEncoder().encode(Array(selectedPhotos.values))
        else { return }
        userDefaults.set(data, forKey: photosKey)
    }
}
