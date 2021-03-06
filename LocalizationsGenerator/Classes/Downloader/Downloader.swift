//
//  Downloader.swift
//  nstack-localizations-generator
//
//  Created by Dominik Hádl on 08/02/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation

struct Downloader {
    var semaphore = DispatchSemaphore(value: 0)

    static func dataWithDownloaderSettings(_ settings: DownloaderSettings, localization: Localization) throws -> Data? {
        return try Downloader().dataWithLocalization(localization, settings: settings)
    }

    static func localizationsWithDownloaderSettings(_ settings: DownloaderSettings) throws -> [Localization]? {
        return try Downloader().getLocalizationUrlsWithDownloaderSettings(settings)
    }

    func getLocalizationUrlsWithDownloaderSettings(_ settings: DownloaderSettings) throws -> [Localization]? {

        var headers: [String : String]  = [:]
        // Add headers
        if let id = settings.appID, let key = settings.appKey {
            headers["X-Application-Id"] = id
            headers["X-Rest-Api-Key"] = key
        }
        if let authorization = settings.authorization {
            headers["Authorization"] = authorization
        }

        var versionString = "1.0"
        if let bundleVersionString = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            versionString = bundleVersionString
        }
        headers["n-meta"] = "ios;nstack-localizations-generator;\(versionString);macOS;mac"

        let url = settings.localizationsURL

        let session = URLSession.shared

        var request = session.request(url, method: .get, parameters: ["dev": "true"], headers: headers)
        
        // add headers
        for header in settings.extraHeaders ?? [] {
            let comps = header.components(separatedBy: ":")
            guard comps.count == 2 else { continue }
            request.setValue(comps[1].trimmingCharacters(in: .whitespacesAndNewlines),
                             forHTTPHeaderField: comps[0].trimmingCharacters(in: .whitespacesAndNewlines))
        }

        var responseLocalizations: [Localization]?
        var finalError: Error?

        let completion: Completion<DataModel<[Localization]>> = { (result) in
            switch  result {
            case .success(let response):
                responseLocalizations = response.model
            case .failure(let error):
                finalError = error
            }

            self.semaphore.signal()
        }
        session.startDataTask(with: request, convertFromSnakeCase: settings.convertFromSnakeCase, completionHandler: completion)

        _ = semaphore.wait(timeout: DispatchTime.distantFuture)

        if let error = finalError {
            throw error
        }

        return responseLocalizations
    }

    func dataWithLocalization(_ localization: Localization, settings: DownloaderSettings) throws -> Data? {
        guard let requestURL = URL(string: localization.url) else {
            return nil
        }
        let request = NSMutableURLRequest(url: requestURL)

        // Add headers
        if let id = settings.appID, let key = settings.appKey {
            request.setValue(id, forHTTPHeaderField: "X-Application-Id")
            request.setValue(key, forHTTPHeaderField: "X-Rest-Api-Key")
        }
    
        // Add auth
        if let authorization = settings.authorization {
            request.setValue(authorization, forHTTPHeaderField: "Authorization")
        }
        
        // add headers
        for header in settings.extraHeaders ?? [] {
            let comps = header.components(separatedBy: ":")
            guard comps.count == 2 else { continue }
            request.setValue(comps[1].trimmingCharacters(in: .whitespacesAndNewlines),
                             forHTTPHeaderField: comps[0].trimmingCharacters(in: .whitespacesAndNewlines))
        }
        
        var versionString = "1.0"
        if let bundleVersionString = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            versionString = bundleVersionString
        }

        request.setValue("ios;nstack-localizations-generator;\(versionString);macOS;mac", forHTTPHeaderField: "n-meta")
        
        var actualData: Data?
        var finalError: Error?

        // Start data task
        URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            var customError: NSError?

            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 300...999:
                    let content: String?
                    if let data = data {
                        let object = try? JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                        let json = object as? [String: AnyObject]
                        content = "\(json ?? [:])"
                    } else {
                        content = nil
                    }

                    let errorString = "Server response contained error: \(content ?? "")"
                    customError = NSError(domain: Constants.ErrorDomain.tGenerator.rawValue,
                                          code: ErrorCode.downloaderError.rawValue,
                                          userInfo: [NSLocalizedDescriptionKey : errorString])
                default: break
                }
            }

            if let dat = data {

                //convert data to a JSON object
                let object = try? JSONSerialization.jsonObject(with: dat, options: [.allowFragments])
                var json = object as? [String: AnyObject]
                var newLanguageJSON = json?["meta"]?["language"] as? [String : Any]

                //manipulate the fields required from the config meta to copy over to the fallback jsons
                if let _ = newLanguageJSON?["is_default"] as? Bool {
                    newLanguageJSON?["is_default"] = localization.language.isDefault
                }

                //overwrite the inital json response with the update json response with new meta values
                if var newMeta = json?["meta"] as? [String : Any] {
                    if let nlj = newLanguageJSON {
                        newMeta["language"] = nlj
                        json?["meta"] = newMeta as AnyObject
                    }
                }
                let newData = try? JSONSerialization.data(withJSONObject: json, options: [])
                actualData = newData
            }
            else {
                actualData = data
            }

            finalError = customError ?? error

            self.semaphore.signal()
        }.resume()

        _ = semaphore.wait(timeout: DispatchTime.distantFuture)

        if let error = finalError {
            throw error
        }

        return actualData
    }
}
