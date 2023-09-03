//
//  Debouncer.swift
//  ImagesFeedApp
//
//  Created by Людмила Долонтаева on 2023-09-02.
//

import Foundation

class Debouncer: DebouncerProtocol {
  private var timer: Timer?
  private let delay: TimeInterval

  required init(delay: TimeInterval) {
    self.delay = delay
  }

  func debounce(action: @escaping () -> Void) {
    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
      action()
    }
  }
}
