//
//  MealNetworkService.swift
//  MealDB
//
//  Created by Владислав Галкин on 15.06.2021.
//

import UIKit.UIImage
import Foundation

final class MealNetworkService {
    
    private let session: URLSession = .shared
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}

extension MealNetworkService: MealNetworkServiceProtocol {
    
    typealias Handler = (Data?, URLResponse?, Error?) -> Void
    
    func getPopularMeal(completion: @escaping (GetMealAPIResponse) -> Void) {
        
        let components = URLComponents(string: Constants.MealAPIMethods.getPopularMeal)
        guard let url = components?.url else { completion(.failure(.unknownError)); return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let handler: Handler = { rawData, response, taskError in
            do {
                let data = try self.httpResponse(data: rawData, response: response)
                let response = self.decodeJson(type: GetMealsResponse.self, from: data)
                if let response = response {
                    completion(.success(response))
                }
            } catch _ as NetworkServiceError {
                completion(.failure(.networkError))
            } catch {
                completion(.failure(.unknownError))
            }
        }
        session.dataTask(with: request, completionHandler: handler).resume()
    }
    
    func getMealByCategory(with category: String, completion: @escaping (GetMealAPIResponse) -> Void) {
        
        var components = URLComponents(string: Constants.MealAPIMethods.getMealByCategory)
        components?.queryItems = [URLQueryItem(name: "c", value: category)]
        guard let url = components?.url else { completion(.failure(.unknownError)); return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let handler: Handler = { rawData, response, taskError in
            do {
                let data = try self.httpResponse(data: rawData, response: response)
                let response = self.decodeJson(type: GetMealsResponse.self, from: data)
                if let response = response {
                    completion(.success(response))
                }
            } catch let error as NetworkServiceError {
                completion(.failure(error))
            } catch {
                completion(.failure(.unknownError))
            }
        }
        session.dataTask(with: request, completionHandler: handler).resume()
    }
    
    func getMealById(with id: String, completion: @escaping (GetMealDetailAPIResponse) -> Void) {
        
        var components = URLComponents(string: Constants.MealAPIMethods.getMealById)
        components?.queryItems = [URLQueryItem(name: "i", value: id)]
        guard let url = components?.url else { completion(.failure(.unknownError)); return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let handler: Handler = { rawData, response, taskError in
            do {
                let data = try self.httpResponse(data: rawData, response: response)
                let response = self.decodeJson(type: GetMealsDetailResponse.self, from: data)
                if let response = response {
                    completion(.success(response))
                }
            } catch let error as NetworkServiceError {
                completion(.failure(error))
            } catch {
                completion(.failure(.unknownError))
            }
        }
        session.dataTask(with: request, completionHandler: handler).resume()
    }
    
    func downloadImageFromUrl(from url: String?, completion: @escaping (UIImage?) -> ()) {
        
        guard let imageUrl = url, let url = URL(string: imageUrl) else { return }
        var request = URLRequest(url: url)
        request.cachePolicy = .returnCacheDataElseLoad
        
        let handler: Handler = { rawData, response, taskError in
            do {
                let data = try self.httpResponse(data: rawData, response: response)
                if let image = UIImage(data: data) {
                    completion(image)
                }
            } catch {
                print("other error")
            }
        }
        session.dataTask(with: request, completionHandler: handler).resume()
    }
    
    private func httpResponse(data: Data?, response: URLResponse?) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode),
              let data = data else {
            throw NetworkServiceError.networkError
        }
        return data
    }
    
    private func decodeJson<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = from else { return nil }
        do {
            let result = try decoder.decode(type.self, from: data)
            return result
        } catch {
            print("Ошибка парсинга")
        }
        return nil
    }
}
