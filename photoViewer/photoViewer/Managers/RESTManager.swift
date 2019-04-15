//
//  RESTManager.swift

import Foundation
import Alamofire
import RxSwift

//
protocol RESTManager {
    func images(page: Int) -> Single<Photos>
    func imageDetails(id: String) -> Single<PhotoDetails>
}

//
final class RESTManagerImpl: RESTManager {
    
    private let networkQueue = DispatchQueue(label: "com.solocez.api.network", qos: .background, attributes: .concurrent)
    private var accessToken: String? = nil

    //
    func imageDetails(id: String) -> Single<PhotoDetails> {
        return _imageDetails(id: id)
            .retryWhen(authenticationRetryHandler())
    }
    
    //
    private func _imageDetails(id: String) -> Single<PhotoDetails> {
        return Single<PhotoDetails>.create(subscribe: { [unowned self] (observer) in
            guard let url = URL(string: Settings().RESTEndpoint + "/images/\(id)") else {
                observer(.error(AppError(title: R.string.loc.error(), description: "FAILED TO CONSTRUCT URL REQUEST", code: 1)))
                return Disposables.create()
            }
            
            Log.debug("RETRIEVING PHOTOS: \(url.absoluteString)")
            
            let headers: HTTPHeaders = ["Authorization": "Bearer " + (self.accessToken ?? "")]
            
            Alamofire.request(url, method: .get, headers: headers)
                .validate()
                .responseJSON(queue: self.networkQueue) { response in
                    guard response.result.isSuccess else {
                        observer(.error(AppError(response.result.error as! AFError)))
                        return
                    }
                    
                    guard let data = response.data else {
                        observer(.error(AppError(title: R.string.loc.error(), description: "NO DATA TO DECODE", code: 3)))
                        return
                    }
                    
                    guard let result = try? JSONDecoder().decode(PhotoDetails.self, from: data) else {
                        observer(.error(AppError(title: R.string.loc.error(), description: "COULD NOT DECODE RESPONSE", code: 4)))
                        return
                    }
                    
                    observer(.success(result))
            }
            return Disposables.create()
        })
    }
    
    //
    func images(page: Int) -> Single<Photos> {
        return _images(page: page)
                .retryWhen(authenticationRetryHandler())
    }
    
    //
    private func _images(page: Int) -> Single<Photos> {
        return Single<Photos>.create(subscribe: { [unowned self] (observer) in
            guard var url = URL(string: Settings().RESTEndpoint + "/images") else {
                observer(.error(AppError(title: R.string.loc.error(), description: "FAILED TO CONSTRUCT URL REQUEST", code: 1)))
                return Disposables.create()
            }
            
            url = url.appending("page", value: String(page))
            Log.debug("RETRIEVING PHOTOS: \(url.absoluteString)")
            
            let headers: HTTPHeaders = ["Authorization": "Bearer " + (self.accessToken ?? "")]
            
            Alamofire.request(url, method: .get, headers: headers)
                .validate()
                .responseJSON(queue: self.networkQueue) { response in
                    guard response.result.isSuccess else {
                        observer(.error(AppError(response.result.error as! AFError)))
                        return
                    }
                    
                    guard let data = response.data else {
                        observer(.error(AppError(title: R.string.loc.error(), description: "NO DATA TO DECODE", code: 3)))
                        return
                    }
                    
                    guard let result = try? JSONDecoder().decode(Photos.self, from: data) else {
                        observer(.error(AppError(title: R.string.loc.error(), description: "COULD NOT DECODE RESPONSE", code: 4)))
                        return
                    }
                    
                    observer(.success(result))
            }
            return Disposables.create()
        })
    }
    
    //
    private func auth() -> Single<String> {
        return Single<String>.create(subscribe: { [unowned self] (observer) in
            guard let url = URL(string: Settings().RESTEndpoint + "/auth") else {
                observer(.error(AppError(title: R.string.loc.error(), description: "FAILED TO CONSTRUCT URL REQUEST", code: 1)))
                return Disposables.create()
            }
            
            let configuration = URLSessionConfiguration.default
            configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
            
            Alamofire.request(url, method: .post, parameters: [:]
                , encoding: JSONStringArrayEncoding.init(string: "{ \"apiKey\": \"\(Settings().apiKey)\" }"))
                .validate()
                .responseJSON(queue: self.networkQueue) { [unowned self] response in
                    guard response.result.isSuccess else {
                        observer(.error(AppError(response.result.error as! AFError)))
                        return
                    }
                    
                    guard let data = response.data else {
                        observer(.error(AppError(title: R.string.loc.error(), description: "NO DATA TO DECODE", code: 3)))
                        return
                    }
                    
                    guard let result = try? JSONDecoder().decode(AuthToken.self, from: data) else {
                        observer(.error(AppError(title: R.string.loc.error(), description: "COULD NOT DECODE RESPONSE", code: 4)))
                        return
                    }
                    
                    self.accessToken = result.token
                    
                    observer(.success(result.token))
            }
            return Disposables.create()
        })
    }
    
    //
    private func authenticationRetryHandler() -> ((Observable<Error>) -> Observable<String>) {
        return { [unowned self] err in
            err.enumerated().flatMap({ [unowned self] (attempt, error) throws -> Observable<String> in
                
                if attempt >= 1 {
                    return Observable.error(error)
                }
                
                if let appError = error as? AppError, appError.code == 401 {
                    Log.warning("TOKEN RENEWAL IS REQUIRED: \(error.localizedDescription)")
                    return self.auth().asObservable()
                }
                return Observable.error(error)
            })
        }
    }
}

//
struct JSONStringArrayEncoding: ParameterEncoding {
    private let stringToEncode: String
    
    //
    init(string: String) {
        self.stringToEncode = string
    }
    
    //
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = urlRequest.urlRequest
        
        let data = stringToEncode.data(using: .utf8)!
        
        if urlRequest?.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        urlRequest?.httpBody = data
        return urlRequest!
    }
}

//
struct AuthToken: Decodable {
    let token: String
    
    enum CodingKeys : String, CodingKey {
        case token
    }
}
