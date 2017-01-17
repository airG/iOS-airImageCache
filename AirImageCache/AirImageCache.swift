//
//  AirImageCache.swift
//  AirImageCache
//
//  Created by Steven Thompson on 2017-01-17.
//  Copyright © 2017 airg. All rights reserved.
//

import Foundation
import airGiOSTools

public struct ImageCache {
    public static var shared = ImageCache()

    fileprivate let cache = NSCache<AnyObject, AnyObject>()
    fileprivate var myImageKeys: [String] = []

    fileprivate static let cacheDirectory: URL? = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first

    //MARK:- Retrieving
    static func image(forUsername username: String, size: CGSize) -> UIImage? {
        return image(forKey: key(forUsername: username, size: size))
    }

    static func image(forFile file: String, folder: String) -> UIImage? {
        return image(forKey: key(forFile: file, folder: folder))
    }

    static func image(forGiftID giftID: String, path: String) -> UIImage? {
        return image(forKey: key(forGiftID: giftID, path: path))
    }

    fileprivate static func image(forKey key: String) -> UIImage? {
        if let image = ImageCache.shared.cache.object(forKey: key as NSString) as? UIImage {
            return image
        } else if let image = fileSystemImage(forKey: key) {
            return image
        } else {
            return nil
        }
    }

    fileprivate static func fileSystemImage(forKey key: String) -> UIImage? {
        if let path = filepath(forKey: key),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
            let image = UIImage(data: data) {
            return image
        }

        return nil
    }

    //MARK:- Saving
    fileprivate static func save(_ image: UIImage, forKey key: String) {
        ImageCache.shared.cache.setObject(image, forKey: key as AnyObject)
        fileSystem(save: image, forKey: key)
    }

    fileprivate static func fileSystem(save image: UIImage, forKey key: String) {
        if let jpeg = UIImageJPEGRepresentation(image, 1.0), let path = filepath(forKey: key) {
            try? jpeg.write(to: URL(fileURLWithPath: path), options: [.atomic])
        }
    }

    //MARK:- Keys
    fileprivate static func key(forUsername username: String, size: CGSize) -> String {
        return username + "-" + String(describing: size.width) + "-" + String(describing: size.height)
    }

    fileprivate static func key(forFile file: String, folder: String) -> String {
        return file + "-" + folder
    }

    fileprivate static func key(forGiftID giftID: String, path: String) -> String {
        return giftID + "-" + path
    }

    fileprivate static func filepath(forKey key: String) -> String? {
        if let cacheDirectory = cacheDirectory {
            return "\(cacheDirectory)/\(key).jpg"
        }
        return nil
    }

    //MARK:- Purge
    static func purgeMyImages() {
        let fileManager = FileManager()
        for key in ImageCache.shared.myImageKeys {
            ImageCache.shared.cache.removeObject(forKey: key as AnyObject)
            if let path = filepath(forKey: key) {
                do {
                    try fileManager.removeItem(atPath: path)
                } catch {
//                    ALog("Unable to delete item at \(path): \(error)", level: .error)
                }
            }
        }
        ImageCache.shared.myImageKeys = []
    }
}

/*
 Example of Extension:
 
 static func save(_ image: UIImage, forUsername username: String, size: CGSize, mine: Bool = false) {
 if username == Me.sharedInstance.username || mine {
 ImageCache.shared.myImageKeys.append(key(forUsername: username, size: size))
 }
 save(image, forKey: key(forUsername: username, size: size))
 }

 static func save(_ image: UIImage, forFile file: String, folder: String, mine: Bool = false) {
 if mine {
 ImageCache.shared.myImageKeys.append(key(forFile: file, folder: folder))
 }
 save(image, forKey: key(forFile: file, folder: folder))
 }

 static func save(_ image: UIImage, forGiftID giftID: String, path: String) {
 save(image, forKey: key(forGiftID: giftID, path: path))
 }
*/
