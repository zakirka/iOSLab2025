//
//  UsersCache.swift
//  Actor‑based Cache
//
//  Created by Azamat Zakirov on 18.04.2026.
//

import Foundation

actor UsersCache {
    private var storage: [Int: User] = [:]

    func user(for id: Int) -> User? {
        if let cached = storage[id] {
            print("Пользователь \(id) найден в системе")
            return cached
        }
        print("Пользователь \(id) не найден в системе")
        return nil
    }

    func save(_ user: User ) {
        storage[user.id] = user
        print("Пользователь \(user.id) сохранен в системе")
    }
}
