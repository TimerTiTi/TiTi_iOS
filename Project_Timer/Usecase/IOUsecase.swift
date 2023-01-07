//
//  IOUsecase.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/01/07.
//  Copyright © 2023 FDEE. All rights reserved.
//

import UIKit

struct IOUsecase {
    // MARK: Images
    static func saveImagesToIOS(views: [UIView]) {
        let images = views.map({ UIImage(view: $0) })
        images.forEach { image in
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
    
    static func saveImagesToMAC(views: [UIView], fileName: String) -> [URL]? {
        let images = views.map({ UIImage(view: $0) })
        let imageDatas = images.compactMap({ $0.jpegData(compressionQuality: 1) })
        let fileManager = FileManager.default.temporaryDirectory
        var fileURLs: [URL] = []
        
        for (idx, imageData) in imageDatas.enumerated() {
            let fileURL = fileManager.appendingPathComponent("\(fileName)_\(idx+1).jpg")
            fileURLs.append(fileURL)
            do {
                try imageData.write(to: fileURL)
            } catch {
                return nil
            }
        }
        
        return fileURLs
    }
}
