//
//  BitcoinManager.swift
//  BITCOINPrice
//
//  Created by Marco Alonso Rodriguez on 03/12/22.
//

import Foundation

protocol bitcoinDelegado {
    func actualizarPrecio(bitcon: Bitcoin)
}

struct BitcoinManager {
    var delegado: bitcoinDelegado?
    
    func actualizarPrecio(moneda: String) {
        let urlString = "https://rest.coinapi.io/v1/exchangerate/BTC/\(moneda)/?apikey=762DEF17-B7CD-49B7-96EC-57D995E9E339"
        
        if let url = URL(string: urlString){
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else { return }
                
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode(Bitcoin.self, from: data)
//                    print(decodedData.rate)
                    delegado?.actualizarPrecio(bitcon: decodedData)
                }catch {
                    print("Debug: Error parsing data \(error.localizedDescription)")
                }
            }
            .resume()
        }
    }
    
    func actualizarPrecioClosure(moneda: String, completionHandler: @escaping(_ precio: Bitcoin?, _ error: Error?) -> () ) {
        
        let urlString = "https://rest.coinapi.io/v1/exchangerate/BTC/\(moneda)/?apikey=762DEF17-B7CD-49B7-96EC-57D995E9E339"
        
        if let url = URL(string: urlString){
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else { return }
                
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode(Bitcoin.self, from: data)
                    print(decodedData.rate)
                    completionHandler(decodedData, nil)
                }catch {
                    print("Debug: Error parsing data \(error.localizedDescription)")
                    completionHandler(nil, error)
                }
            }.resume()
        }
    }
    
}


