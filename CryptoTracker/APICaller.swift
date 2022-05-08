//
//  APICaller.swift
//  CryptoTracker
//
//  Created by Claudius Kockelmann on 08.05.22.
//

import Foundation
import UIKit

final class APICaller {
    static let shared = APICaller()
    
    struct Constants {
        static let apiKey = "19C24B79-550A-494A-89B0-3DC44E4C8A2E"
        static let assetsEndpoint = "https://rest.coinapi.io/v1/assets/"
    }
    
    public var icons : [Icon] = []
    
    private var whenReadyBlock: ((Result<[Crypto], Error>) -> Void)?
    
    init() {}
    
    // MARK: - Public functions
    public func getAllCryptoData(completion: @escaping (Result<[Crypto], Error>) -> Void) {
        guard !icons.isEmpty else {
            whenReadyBlock = completion
            print("icons should not be nil")
            return
        }
        guard let url = URL(string: Constants.assetsEndpoint + "?apikey=" + Constants.apiKey) else {
            print("invalid endpoint url")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                // Decode response
                let cryptos = try JSONDecoder().decode([Crypto].self, from: data)
                
                completion(.success(cryptos.sorted { first, second -> Bool in
                    return first.id_icon ?? "" > second.id_icon ?? ""
                    //return (first.id_icon ?? "" > second.id_icon ?? "" && first.price_usd ?? 0 > second.price_usd ?? 0)
                }))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    public func getAllIcons() {
        guard let url = URL(string: "https://rest.coinapi.io/v1/assets/icons/55/?apikey=19C24B79-550A-494A-89B0-3DC44E4C8A2E") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                // Decode response
                self?.icons = try JSONDecoder().decode([Icon].self, from: data)
                
                if let completion = self?.whenReadyBlock {
                    self?.getAllCryptoData(completion: completion)
                }
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
}
