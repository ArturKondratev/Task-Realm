//
//  CamerasCell.swift
//  Rubetek
//
//  Created by Артур Кондратьев on 10.07.2022.
//

import UIKit

class CamerasCell: UITableViewCell {
    
    static let identifier: String = "CamerasCell"
    
    lazy var cameraImage: UIImageView = {
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
        
    lazy var recLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "•REC"
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var whiteBottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        return view
    }()
    
    lazy var cameraName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.backgroundColor = .white
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
}

extension CamerasCell {
    
    func setupViews() {
        contentView.backgroundColor = .lightGrayBackground
        
        contentView.addSubview(cameraImage)
        NSLayoutConstraint.activate([
            cameraImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            
            cameraImage.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            
            cameraImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30),
            
            cameraImage.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30),
           // cameraImage.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        cameraImage.addSubview(recLable)
        NSLayoutConstraint.activate([
            recLable.topAnchor.constraint(equalTo: cameraImage.topAnchor, constant: 10),
            recLable.leftAnchor.constraint(equalTo: cameraImage.leftAnchor, constant: 10)
        ])
        
        cameraImage.addSubview(favoriteImage)
        NSLayoutConstraint.activate([
            favoriteImage.topAnchor.constraint(equalTo: cameraImage.topAnchor, constant: 10),
            favoriteImage.rightAnchor.constraint(equalTo: cameraImage.rightAnchor, constant: -10),
            favoriteImage.heightAnchor.constraint(equalToConstant: 25),
            favoriteImage.widthAnchor.constraint(equalToConstant: 25)
        ])
        
        contentView.addSubview(whiteBottomView)
        NSLayoutConstraint.activate([
            whiteBottomView.topAnchor.constraint(equalTo: cameraImage.bottomAnchor),
            whiteBottomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            whiteBottomView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30),
            whiteBottomView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30),
            whiteBottomView.heightAnchor.constraint(equalToConstant: 50)
            
        ])
        
        whiteBottomView.addSubview(cameraName)
        NSLayoutConstraint.activate([
            cameraName.centerYAnchor.constraint(equalTo: whiteBottomView.centerYAnchor),
            cameraName.leftAnchor.constraint(equalTo: whiteBottomView.leftAnchor, constant: 20)
        ])
    }
    
    func configure(model: CamerasRealmModel) {
        self.cameraName.text = model.name
        self.cameraImage.downloadImage(link: model.snapshot)
        
        recState(state: model.rec)
        favoriteState(state: model.favorites)
    }
    
    func recState(state: Bool) {
        self.recLable.isHidden = state ? false : true
    }
    
    func favoriteState(state: Bool) {
        self.favoriteImage.isHidden = state ? false : true
    }
}

