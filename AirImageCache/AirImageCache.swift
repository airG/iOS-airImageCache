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
    enum Error: Swift.Error {
        case AirImageCacheSaveError
    }
    
    public static var log: ((_ message: String, _ file: String, _ function: String, _ line: Int) -> Void)?
    public static var imageURLProvider: AirImageURLProviding?

    fileprivate static var urlSession: URLSession = createUrlSession()
    fileprivate static func createUrlSession() -> URLSession {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        return session
    }

    //MARK: Interface
    /// Checks all cache locations for a UIImage matching the `key`.
    ///
    /// - Parameter key: Unique identifier for an image.
    /// - Parameter completion: Function that executes when the image is found, or the imagecache gives up looking. Dispatches to main thread so safe for UI.
    /// - Returns: Optional URLSessionDataTask, if you want to keep track and cancel early.
    @discardableResult public static func image(for key: String, file: String = #file, function: String = #function, line: Int = #line, completion: @escaping (UIImage?) -> Void) -> URLSessionDataTask? {
        let dispatchCompletionOnMain: (UIImage?) -> Void = { image in
            DispatchQueue.main.async {
                completion(image)
            }
        }

        if let image = inMemoryImage(for: key) {
            log?("Got image for \(key) from in-memory cache", file, function, line)
            dispatchCompletionOnMain(image)
        } else if let image = fileSystemImage(for: key) {
            inMemory(save: image, for: key) // If the image is in the filesystem but not NSCache, should add it for future retrievals
            log?("Got image for \(key) from file system", file, function, line)
            dispatchCompletionOnMain(image)
        } else {
            //Download it
            if let imageURLProvider = imageURLProvider, let url = imageURLProvider.url(for: key) {
                let dataTask = urlSession.dataTask(with: url, completionHandler: { (data, response, error) in
                    if let data = data, let image = UIImage(data: data) {
                        save(image, for: key)
                        dispatchCompletionOnMain(image)
                    } else {
                        if let error = error, (error as NSError).code != -999 { // Only log an error if the operation wasn't cancelled
                            log?("Error downloading image for key \(key): \(error)", file, function, line)
                        }
                        dispatchCompletionOnMain(nil)
                    }
                })
                dataTask.resume()
                return dataTask

            } else {
                dispatchCompletionOnMain(nil)
            }
        }

        return nil
    }

    /// Saves a provided image into the cache.
    ///
    /// - Parameters:
    ///   - image: UIImage to save to the in memory cache and filesystem.
    ///   - key: Unique identifier for an image.
    public static func save(_ image: UIImage, for key: String, file: String = #file, function: String = #function, line: Int = #line) -> Void {
        inMemory(save: image, for: key)
        do {
            try fileSystem(save: image, for: key)
        } catch {
            log?("Error saving image for key \(key): \(error)", file, function, line)
        }
    }

    /// Cancels all in progress image downloads
    public static func cancelAllDownloads() {
        urlSession.invalidateAndCancel()
        urlSession = createUrlSession() // Need to recreate the session
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

    fileprivate static func purgeNSCache(file: String = #file, function: String = #function, line: Int = #line) {
        log?("Purging NSCache", file, function, line)
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
        if let url = fileUrl(forKey: key),
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data) {
            return image
        }

        return nil
    }

    //MARK:- Saving
    fileprivate static func inMemory(save image: UIImage, for key: String) {
        AirImageCache.shared.cache.setObject(image, forKey: key as AnyObject)
    }

    fileprivate static func fileSystem(save image: UIImage, for key: String, file: String = #file, function: String = #function, line: Int = #line) throws {
        if let jpeg = UIImageJPEGRepresentation(image, 1.0), let url = fileUrl(forKey: key) {
            do {
                try jpeg.write(to: url, options: [.atomic])
            } catch {
                log?("Error saving image to filesystem for \(key) - \(error)", file, function, line)
                throw Error.AirImageCacheSaveError
            }
        }
        throw Error.AirImageCacheSaveError
    }

    //MARK:- Keys
    fileprivate static func fileUrl(forKey key: String) -> URL? {
        if let cacheDirectory = cacheDirectory {
            let safeKey = key.replacingOccurrences(of: "/", with: "-")
            return cacheDirectory.appendingPathComponent("\(safeKey).jpg", isDirectory: false)
        }
        return nil
    }
}

/// To enable the AirImageCache to get images from a server, provide AirImageCache with an object conforming to this protocol, and implement `url(for key: String) -> URL`
public protocol AirImageURLProviding {
    /// Creates the URL to get a specified image from
    ///
    /// - Parameter key:
    /// - Returns:
    func url(for key: String) -> URL?
}

private var imageTaskKey: Void?
public extension UIImageView {
    /// Convenience function to set the image on a `UIImageView` from a `key`. Stores the data task on self, call `cancelAirImageDownload` if you want to stop the download.
    ///
    /// - Parameter key:
    public func setAirImage(for key: String, file: String = #file, function: String = #function, line: Int = #line) {
        let task = AirImageCache.image(for: key, file: file, function: function, line: line) { image in
            self.image = image
        }
        setImageTask(task)
    }

    /// Cancels the active image download, if there is one
    public func cancelAirImageDownload() {
        imageDataTask?.cancel()
        setImageTask(nil)
    }

    fileprivate var imageDataTask: URLSessionDataTask? {
        return objc_getAssociatedObject(self, &imageTaskKey) as? URLSessionDataTask
    }

    fileprivate func setImageTask(_ task: URLSessionDataTask?) {
        objc_setAssociatedObject(self, &imageTaskKey, task, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
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
