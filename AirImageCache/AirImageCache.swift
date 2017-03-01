//
//  AirImageCache.swift
//  AirImageCache
//
//  Created by Steven Thompson on 2017-01-17.
//  Copyright © 2017 airg. All rights reserved.
//

import Foundation

/// AirImageCache saves and returns images from an NSCache stored in memory and in the `/Caches` directory.
public struct AirImageCache {
    static var log: ((String)->Void)?
    static var imageURLProvider: AirImageURLProviding?

    //MARK: Interface
    /// Checks all cache locations for a UIImage matching the `key`.
    ///
    /// - Parameter key: Unique identifier for an image.
    /// - Returns: UIImage if it exists, otherwise nil.
    public static func image(for key: String, completion: @escaping (UIImage?) -> Void) {
        if let image = inMemoryImage(for: key) {
            print("Got image for \(key) from in-memory cache")
            completion(image)
        } else if let image = fileSystemImage(for: key) {
            inMemory(save: image, for: key) // If the image is in the filesystem but not NSCache, should add it for future retrievals
            print("Got image for \(key) from file system")
            completion(image)
        } else {
            //Download it
            if let url = imageURLProvider?.url(for: key) {
                URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                    if let data = data, let image = UIImage(data: data) {
                        completion(image)
                    } else {
                        if let error = error {
                            print("Error downloading image for key \(key): \(error)")
                        }
                        completion(nil)
                    }
                })
            } else {
                completion(nil)
            }
        }
    }

    /// Saves a provided image into the cache.
    ///
    /// - Parameters:
    ///   - image: UIImage to save to the in memory cache and filesystem.
    ///   - key: Unique identifier for an image.
    public static func save(_ image: UIImage, for key: String) -> Void {
        inMemory(save: image, for: key)
        fileSystem(save: image, for: key)
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
        print("Purging NSCache")
        AirImageCache.shared.cache.removeAllObjects()
    }

    //MARK:- Retrieving
    fileprivate static func inMemoryImage(for key: String) -> UIImage? {
        if let image = AirImageCache.shared.cache.object(forKey: key as NSString) as? UIImage {
            return image
        } else {
            return nil
        }
    }

    fileprivate static func fileSystemImage(for key: String) -> UIImage? {
        if let path = filepath(forKey: key),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
            let image = UIImage(data: data) {
            return image
        }

        return nil
    }

    //MARK:- Saving
    fileprivate static func inMemory(save image: UIImage, for key: String) {
        AirImageCache.shared.cache.setObject(image, forKey: key as AnyObject)
    }

    @discardableResult fileprivate static func fileSystem(save image: UIImage, for key: String) -> Bool {
        if let jpeg = UIImageJPEGRepresentation(image, 1.0), let path = filepath(forKey: key) {
            do {
                try jpeg.write(to: URL(fileURLWithPath: path), options: [.atomic])
                return true
            } catch {
                print("Error saving image to filesystem for \(key) - \(error)")
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

/// To enable the AirImageCache to get images from a server, provide AirImageCache with an object conforming to this protocol, and implement `url(for key: String) -> URL`
public protocol AirImageURLProviding {
    /// Creates the URL to get a specified image from
    ///
    /// - Parameter key: <#key description#>
    /// - Returns: <#return value description#>
    public func url(for key: String) -> URL
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
