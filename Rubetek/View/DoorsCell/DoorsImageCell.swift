//
//  DoorsImageCell.swift
//  Rubetek
//
//  Created by Артур Кондратьев on 05.08.2022.
//

import Foundation
import UIKit

class DoorsImageCell: UITableViewCell {
    
    static let identifier: String = "DoorsImageCell"
    
    private let doorsImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        image.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        return image
    }()
    
    lazy var favoriteImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        let symbolConfiguration = UIImage.SymbolConfiguration(paletteColors: [.systemYellow])
        let imageStar = UIImage(systemName: "star.fill", withConfiguration: symbolConfiguration)
        image.image = imageStar
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraints()
        contentView.addSubview(doorsImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        doorsImage.image = nil
    }
    
    private func setConstraints() {
        
        contentView.backgroundColor = .lightGrayBackground
        
        contentView.addSubview(doorsImage)
        NSLayoutConstraint.activate([
            
            doorsImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            doorsImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            doorsImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30),
            doorsImage.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30)
        ])
        
        doorsImage.addSubview(favoriteImage)
             NSLayoutConstraint.activate([
                 favoriteImage.topAnchor.constraint(equalTo: doorsImage.topAnchor, constant: 10),
                 favoriteImage.rightAnchor.constraint(equalTo: doorsImage.rightAnchor, constant: -10),
                 favoriteImage.heightAnchor.constraint(equalToConstant: 25),
                 favoriteImage.widthAnchor.constraint(equalToConstant: 25)
             ])
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        doorsImage.frame = contentView.bounds
    }
    
    
    func configure(url: String, fState: Bool ) {
        doorsImage.downloadImage(link: url)
        favoriteState(state: !fState)
    }
    
    func favoriteState(state: Bool) {
        self.favoriteImage.isHidden = state ? false : true
    }
}



