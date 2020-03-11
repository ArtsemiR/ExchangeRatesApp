//
//  ARNetwork.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 11/12/19.
//  Copyright © 2019 Artsemi Ryzhankou. All rights reserved.
//

import Foundation
import Alamofire

class ARNetwork {
    static let shared = ARNetwork()

    var baseUrl: String {
        return "http://www.nbrb.by/"
    }

    func request<T: Decodable>(action: String,
                                   model: Encodable? = nil,
                                   parameters: [String: String]? = nil,
                                   okHandler: @escaping (T) -> Void) {
        var url: String = "\(self.baseUrl)\(action)"
        if let parameters = parameters {
            url = self.getUrlWithParams(fullPath: "\(self.baseUrl)\(action)", params: parameters)
        }
        let method: HTTPMethod = .get

        var modelParameters: [String: String]?
//        if let model = model {
//            modelParameters = try? model.asDictionary() as! [String : String]
//        }

        AF.request(url,
                   method: method,
                   parameters: modelParameters,
                   encoder: JSONParameterEncoder.default).responseJSON { (response) in
                    ARLogManager.logToConsole(response)
                    let statusCode: Int = response.response?.statusCode ?? 0

                    switch statusCode {
                    case 200:
                        do {
                            let decoder = JSONDecoder()
                            if let jsonData = response.data {
                                let res = try decoder.decode(T.self, from: jsonData)
                                okHandler(res)
                            } else {
                                fatalError("Couldn't decode json from data")
                            }
                        } catch {
                            fatalError("Couldn't decode json from data")
                        }
                    default:
                        break
                    }
        }
    }

    func getUrlWithParams(fullPath: String, params: [String: String]) -> String {
        var url: String = fullPath
        if params.count > 0 {
            url += "?"
            for param in params {
                if url[url.count - 1] != "?" &&
                    url[url.count - 1] != "&" {
                    url += "&"
                }

                let key: String = param.key.encodeForURL()
                let value: String = param.value.encodeForURL()
                url += "\(key)=\(value)"
            }
        }
        return url
    }
}

final class ARLogManager {

    private static func prettyPrint(with json: [[String: Any]]) -> String? {
        if let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            let string = String(data: data, encoding: String.Encoding.utf8)
            return string
        }
        return nil
    }

    public static func logToConsole<T>(_ response: AFDataResponse<T>) {
        #if DEBUG
        if let httpBody = response.request?.httpBody {
            var body: String?
            do {
                if let dict = try JSONSerialization.jsonObject(with: httpBody, options: []) as? [[String: Any]] {
                    body = ARLogManager.prettyPrint(with: dict) ?? ""
                }
            } catch {
                body = String(data: httpBody, encoding: String.Encoding.utf8)
            }
            if let request = body {
                self.printRequest(
                    url: response.request?.url?.absoluteString,
                    request: request)
            }
        } else {
            if let url = response.request?.url?.absoluteString {
                self.printRequest(request: url)
            }
        }

        if let error = response.error {
            print(error.localizedDescription)
        } else if let data = response.data {
            if let str = String(data: data, encoding: String.Encoding.utf8),
                let response = response.response {
                do {
                    if let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                        print("\nRESPONSE\(String(repeating: "-", count: 25))\n Status Code: \(response.statusCode) \n \(self.prettyPrint(with: dict) ?? String())")
                    }
                } catch {
                    print("\nRESPONSE\(String(repeating: "-", count: 25))\n Status Code: \(response.statusCode) \n \(str)")
                }
            }
        } else {
            print(response.error?.localizedDescription ?? "Error loading data")
        }
        #endif
    }

    private static func printRequest(url: String? = nil, request: String) {
        if let url = url {
            print("\nREQUEST\(String(repeating: "-", count: 100))\n URL: \(url) \n \(request)")
        } else {
            print("\nREQUEST\(String(repeating: "-", count: 50))\n \(request)")
        }
    }
}
