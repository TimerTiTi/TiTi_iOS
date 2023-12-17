//
//  NotificationRepository.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/17.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

final class NotificationRepository: NotificationRepositoryInterface {
    private let api = NotificationAPI()
    
    func get(completion: @escaping (Result<NotificationInfo?, NetworkError>) -> Void) {
        api.get { result in
            switch result.status {
            case .SUCCESS:
                if let data = result.data {
                    guard let dto = try? JSONDecoder.dateFormatted.decode(NotificationDTO.self, from: data) else {
                        print(String(data: data, encoding: .utf8)!)
                        completion(.failure(.DECODEERROR))
                        return
                    }
                    
                    guard dto.visible.value else {
                        completion(.success(nil))
                        return
                    }
                    
                    let info = dto.toDomain()
                    completion(.success(info))
                } else {
                    completion(.success(nil))
                }
            default:
                completion(.failure(.error(result)))
            }
        }
    }
}
