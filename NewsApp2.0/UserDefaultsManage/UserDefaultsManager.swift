//
//  UserDefaultsManager.swift
//  TestNewsApiApp
//
//  Created by Рустам Т on 9/28/23.
//

import Foundation
import RxSwift

protocol UserDefaultsService {
    func saveNewViewModel(_ viewModel: [NewViewModel])
    func loadNewViewModel() -> [NewViewModel]?
    func clearNewViewModel()
}

final class UserDefaultsManager: UserDefaultsService {
    
    private let userDefaults = UserDefaults.standard
    
    func saveNewViewModel(_ viewModel: [NewViewModel]) {
            do {
                let encodedData = try JSONEncoder().encode(viewModel)
                userDefaults.set(encodedData, forKey: Consts.userDefKey)
            } catch {
                print("Ошибка при кодировании и сохранении NewViewModel: \(error)")
            }
    }
    
    func loadNewViewModel() -> [NewViewModel]? {
        if let encodedData = userDefaults.data(forKey: Consts.userDefKey) {
                do {
                    let viewModel = try JSONDecoder().decode([NewViewModel].self, from: encodedData)
                    return viewModel
                } catch {
                    print("Error decoding NewViewModel: \(error.localizedDescription)")
                }
        }
        return nil
    }
    
    func clearNewViewModel() {
        userDefaults.removeObject(forKey: Consts.userDefKey)
    }
}

private extension UserDefaultsManager {
    enum Consts {
        static let userDefKey = "newViewModel"
    }
}
