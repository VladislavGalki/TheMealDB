//
//  MealNetworkService.swift
//  MealDB
//
//  Created by Владислав Галкин on 15.06.2021.
//

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
    
    func getPopularMeal(after cursor: String?, completion: @escaping (GetMealAPIResponse) -> Void) {
        
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
            } catch let error as NetworkServiceError {
                completion(.failure(error))
            } catch {
                completion(.failure(.unknownError))
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
