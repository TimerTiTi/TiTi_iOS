//
//  Storage.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/04/06.
//  Copyright © 2021 FDEE. All rights reserved.
//

import Foundation

// MARK: Singleton 클래스, Widget과 공동접근 가능
public class Storage {
    private init() { }
    
    // TODO: directory 설명
    // TODO: FileManager 설명
    enum Directory {
        case documents
        case caches
        case sharedContainer
        
        var url: URL {
            switch self {
            case .documents:
                return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            case .caches:
                return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
            case .sharedContainer:
                return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.FDEE.TiTi")!
            }
        }
    }
    
    // TODO: Codable 설명, JSON 타입 설명
    // TODO: Codable encode 설명
    // TODO: Data 타입은 파일 형태로 저장 가능
    
    static func store<T: Encodable>(_ obj: T, to directory: Directory, as fileName: String) {
        let url = directory.url.appendingPathComponent(fileName, isDirectory: false)
        if Infos.isDevMode {
            print("---> save to here: \(url)")
        }
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            
            let data = try encoder.encode(obj)
            
            // 동일한 파일이 있으면 백업후 삭제
            if let backupData = FileManager.default.contents(atPath: url.path) {
                let backupURL = directory.url.appendingPathComponent("tmp_\(fileName)", isDirectory: false)
                if FileManager.default.fileExists(atPath: backupURL.path) {
                    try FileManager.default.removeItem(at: backupURL)
                }
                FileManager.default.createFile(atPath: backupURL.path, contents: backupData)
                
                try FileManager.default.removeItem(at: url)
            }
            
            // 데이터 저장
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch let error {
            if Infos.isDevMode {
                print("---> Failed to store msg: \(error.localizedDescription)")
            }
        }
    }
    
    // TODO: 파일은 Data 타입형태로 읽을수 있음
    // TODO: Data 타입은 Codable decode 가능
    
    static func retrive<T: Decodable>(_ fileName: String, from directory: Directory, as type: T.Type) -> T? {
        let url = directory.url.appendingPathComponent(fileName, isDirectory: false)
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        guard let data = FileManager.default.contents(atPath: url.path) else { return nil }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            let model = try decoder.decode(type, from: data)
            return model
        } catch let error {
            if Infos.isDevMode {
                print("---> Failed to decode msg: \(error.localizedDescription)")
            }
            return retrivePastFormat(data: data, as: type.self)
        }
    }
    
    static func retrivePastFormat<T: Decodable>(data: Data, as type: T.Type) -> T? {
        let decoder = JSONDecoder()
        
        do {
            let model = try decoder.decode(type, from: data)
            return model
        } catch let error {
            if Infos.isDevMode {
                print("---> Failed to Past decode msg: \(error.localizedDescription)")
            }
            return nil
        }
    }
    
    static func remove(_ fileName: String, from directory: Directory) {
        let url = directory.url.appendingPathComponent(fileName, isDirectory: false)
        guard FileManager.default.fileExists(atPath: url.path) else { return }
        
        do {
            try FileManager.default.removeItem(at: url)
        } catch let error {
            if Infos.isDevMode {
                print("---> Failed to remove msg: \(error.localizedDescription)")
            }
        }
    }
    
    static func clear(_ directory: Directory) {
        let url = directory.url
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
            for content in contents {
                try FileManager.default.removeItem(at: content)
            }
        } catch {
            if Infos.isDevMode {
                print("---> Failed to clear directory ms: \(error.localizedDescription)")
            }
        }
    }
    
    static func filePath<T: Decodable>(_ fileName: String, from directory: Directory, as type: T.Type) -> T? {
        let url = directory.url.appendingPathComponent(fileName, isDirectory: false)
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        guard let data = FileManager.default.contents(atPath: url.path) else { return nil }
        
        let decoder = JSONDecoder()
        
        do {
            let model = try decoder.decode(type, from: data)
            return model
        } catch let error {
            if Infos.isDevMode {
                print("---> Failed to decode msg: \(error.localizedDescription)")
            }
            return nil
        }
    }
}
