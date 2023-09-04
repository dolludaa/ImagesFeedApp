//
//  LocalStorage .swift
//  ImagesFeedApp
//
//  Created by Людмила Долонтаева on 6/14/23.
//

import Foundation

final class LocalStorage: LocalStorageProtocol {

  private let userDefaults = UserDefaults.standard
  private let photosKey = "BookmarkPhoto"
  private var selectedPhotos: [String: ImagesScreenModel] = [:]
  private var shouldSave = false

  init() {
    update()
  }

  func unlikePhoto(photoItem: ImagesScreenModel) {
    selectedPhotos[photoItem.id] = nil
    updateAndNotify()
  }

  func likePhoto(photoItem: ImagesScreenModel) {
    selectedPhotos[photoItem.id] = photoItem
    updateAndNotify()
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
    selectedPhotos = Dictionary(uniqueKeysWithValues: photos.map { ($0.id, $0) })
  }

  private func updateAndNotify() {
    save()
    NotificationCenter.default.post(name: .didUpdateLikes, object: nil)
  }

  private func save() {
    guard let data = try? JSONEncoder().encode(Array(selectedPhotos.values)) else {
      return
    }
    userDefaults.set(data, forKey: photosKey)
  }

  private func fetchPhotos() -> [ImagesScreenModel] {
    guard let data = userDefaults.object(forKey: photosKey) as? Data else { return [] }
    return (try? JSONDecoder().decode([ImagesScreenModel].self, from: data)) ?? []
  }
}

extension Notification.Name {
  static let didUpdateLikes = Notification.Name("didUpdateLikes")
}
