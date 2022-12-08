//
//  ViewController.swift
//  BITCOINPrice
//
//  Created by Marco Alonso Rodriguez on 03/12/22.
//

import UIKit

class ViewController: UIViewController, bitcoinDelegado, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    
    
    @IBOutlet weak var precioBitcoinLabel: UILabel!
    @IBOutlet weak var monedaPicker: UIPickerView!
    
    var manager = BitcoinManager()
    
    //DATOS DEL PICKER
    var tipoCambio = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegado = self
        
        monedaPicker.delegate = self
        monedaPicker.dataSource = self
        
//        manager.actualizarPrecio(moneda: "MXN")
        //escaping closures
        manager.actualizarPrecioClosure(moneda: "MXN") { [weak self] precio, error in
            
            if let precio = precio {
                DispatchQueue.main.async { [self] in
                    let precio = String(format: "%.2f", precio.rate)
                    self?.precioBitcoinLabel.text = "$ \(precio)"
                }
            }
        }
    }

    //MARK: Protocol UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tipoCambio.count
    }
    
    //Titulo
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tipoCambio[row]
    }
    
    //MARK: Protocol UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        manager.actualizarPrecio(moneda: "\(tipoCambio[row])") //delegate
        
        //escaping closure
        manager.actualizarPrecioClosure(moneda: "\(tipoCambio[row])") { [weak self] precio, error in
            
            if let precio = precio {
                DispatchQueue.main.async { [self] in
                    let precio = String(format: "%.2f", precio.rate)
                    self?.precioBitcoinLabel.text = "$ \(precio)"
                }
            }
        }
    }
    
    
    //MARK: Protocol bitcoinDelegado
    func actualizarPrecio(bitcon: Bitcoin) {
        
        //Main thread o hilo principal
        
        DispatchQueue.main.async { [self] in
            let precio = String(format: "%.2f", bitcon.rate)
            self.precioBitcoinLabel.text = "$ \(precio)"
        }
        
    }
}

