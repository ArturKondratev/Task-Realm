//
//  ExtensionUIImageView.swift
//  Rubetek
//
//  Created by Артур Кондратьев on 10.07.2022.
//

import UIKit

extension UIImageView {
    
    func downloadImage(link:String) {
        guard let url = URL(string: link) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) -> Void in
            guard let data = data , error == nil, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async { () -> Void in
                self.image = image
            }
        }).resume()
    }
}
