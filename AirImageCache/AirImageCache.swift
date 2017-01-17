//
//  AirImageCache.swift
//  AirImageCache
//
//  Created by Steven Thompson on 2017-01-17.
//  Copyright © 2017 airg. All rights reserved.
//

import Foundation
import airGiOSTools

/// ImageCache saves and returns images from an NSCache stored in memory and in the `/Caches` directory.
/// Uses an NSCache, which operates on a
public struct AirImageCache {
    //MARK: Interface
    /// Checks all cache locations for a UIImage matching the `key`.
    ///
    /// - Parameter key: Unique identifier for an image.
    /// - Returns: UIImage if it exists, otherwise nil.
    public static func image(forKey key: String) -> UIImage? {
        if let image = inMemoryImage(forKey: key) {
            Log("Got image for \(key) from in-memory cache", level: .verbose)
            return image
        } else if let image = fileSystemImage(forKey: key) {
            inMemory(save: image, forKey: key) // If the image is in the filesystem but not NSCache, should add it for future retrievals
            Log("Got image for \(key) from file system", level: .verbose)
            return image
        } else {
            Log("No image for \(key) in ImageCache", level: .verbose)
            return nil
        }
    }

    /// Saves a provided image into the cache.
    ///
    /// - Parameters:
    ///   - image: UIImage to save to the in memory cache and filesystem.
    ///   - key: Unique identifier for an image.
    public static func save(_ image: UIImage, forKey key: String) {
        inMemory(save: image, forKey: key)
        fileSystem(save: image, forKey: key)
    }

    //MARK: Properties
    fileprivate static var shared = AirImageCache()
    fileprivate let cache = NSCache<AnyObject, AnyObject>()
    fileprivate static let cacheDirectory: URL? = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first

    fileprivate init() {
        NotificationCenter.default.addObserver(forName: Notification.Name.UIApplicationDidReceiveMemoryWarning, object: self, queue: OperationQueue.current) { (note) in
            AirImageCache.purgeNSCache()
        }
    }

    fileprivate static func purgeNSCache() {
        Log("Purging NSCache", level: .verbose)
        AirImageCache.shared.cache.removeAllObjects()
    }

    //MARK:- Retrieving
    fileprivate static func inMemoryImage(forKey key: String) -> UIImage? {
        if let image = AirImageCache.shared.cache.object(forKey: key as NSString) as? UIImage {
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
    fileprivate static func inMemory(save image: UIImage, forKey key: String) {
        AirImageCache.shared.cache.setObject(image, forKey: key as AnyObject)
    }

    @discardableResult fileprivate static func fileSystem(save image: UIImage, forKey key: String) -> Bool {
        if let jpeg = UIImageJPEGRepresentation(image, 1.0), let path = filepath(forKey: key) {
            do {
                try jpeg.write(to: URL(fileURLWithPath: path), options: [.atomic])
                return true
            } catch {
                Log("Error saving image to filesystem for \(key) - \(error)")
            }
        }
        return false
    }

    //MARK:- Keys
    fileprivate static func filepath(forKey key: String) -> String? {
        if let cacheDirectory = cacheDirectory {
            return "\(cacheDirectory)/\(key).jpg"
        }
        return nil
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
 
 fileprivate static func key(forUsername username: String, size: CGSize) -> String {
 return username + "-" + String(describing: size.width) + "-" + String(describing: size.height)
 }

 fileprivate static func key(forFile file: String, folder: String) -> String {
 return file + "-" + folder
 }

 fileprivate static func key(forGiftID giftID: String, path: String) -> String {
 return giftID + "-" + path
 }

*/
