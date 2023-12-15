//
//  GetServerURLUseCaseInterface.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/12/15.
//  Copyright © 2023 FDEE. All rights reserved.
//

import Foundation

protocol GetServerURLUseCaseInterface {
    var repository: ServerURLRepositoryInterface { get }
    func getServerURL(completion: @escaping (Result<String, NetworkError>) -> Void)
}
