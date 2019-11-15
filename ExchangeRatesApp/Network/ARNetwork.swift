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

    var userHeaders: [String: String] = ["Content-Type": "application/json"]
    var baseUrl: String {
        return "http://www.nbrb.by/"
    }

    var alamofireManager: SessionManager

    private init() {
        self.alamofireManager = SessionManager()
    }

    func userRequest<T: Decodable>(
        fullPath: String, action: String, model: Encodable? = nil,
        parameters: [String: String]? = nil, okHandler: @escaping (T) -> Void) {
        var url: String = ""

        var _parameters: [String: String] = [:]

        if let parametersTemp = parameters {
            for parameter in parametersTemp {
                _parameters[parameter.key] = parameter.value
            }
        }
        url = self.getUrlWithParams(fullPath: "\(fullPath)\(action)", params: _parameters)

        var modelParameters: [String: Any]?
        var method: HTTPMethod = .get

        if let model = model {
            modelParameters = try? model.asDictionary()
            method = .post
        }

        self.alamofireManager.request(
            url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "",
            method: method,
            parameters: modelParameters,
            encoding: JSONEncoding.default,
            headers: self.userHeaders).responseJSON { (response) in
                let statusCode: Int = response.response?.statusCode ?? 0
                switch statusCode {
                case 200:
                    do {
                        let decoder = JSONDecoder()
                        let res = try decoder.decode(T.self, from: response.data!)
                        okHandler(res)
                    } catch {
                        fatalError("Couldn't decode json from data")
                    }
//                    if let json = response.value as? [String: Any] {
//                        print(json)
//                        do {
//                            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
//                            let decoder = JSONDecoder()
//                            let res = try decoder.decode(T.self, from: data)
//                            okHandler(res)
//                        } catch let error {
//                            print(error)
//                        }
//                    }
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
                url += "\(param.key)=\(param.value)"
            }
        }
        return url
    }
}
