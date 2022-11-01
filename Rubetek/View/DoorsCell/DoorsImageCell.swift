//
//  DoorsImageCell.swift
//  Rubetek
//
//  Created by Артур Кондратьев on 05.08.2022.
//

import UIKit

class DoorsImageCell: UITableViewCell {
    
    static let identifier: String = "DoorsImageCell"
    
    lazy var doorsImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 15
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
    
    lazy var whiteBottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        return view
    }()
    
    var cameraName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.backgroundColor = .white
        return label
    }()
    
    lazy var lockView: LockView = {
        let lock = LockView()
        lock.translatesAutoresizingMaskIntoConstraints = false
        lock.backgroundColor = .white
        return lock
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        contentView.backgroundColor = .lightGrayBackground
        contentView.addSubview(doorsImage)
        contentView.addSubview(whiteBottomView)
        doorsImage.addSubview(favoriteImage)
        whiteBottomView.addSubview(cameraName)
        whiteBottomView.addSubview(lockView)
        
        NSLayoutConstraint.activate([
            
            doorsImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            doorsImage.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            doorsImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30),
            doorsImage.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30),
            
            favoriteImage.topAnchor.constraint(equalTo: doorsImage.topAnchor, constant: 10),
            favoriteImage.rightAnchor.constraint(equalTo: doorsImage.rightAnchor, constant: -10),
            favoriteImage.heightAnchor.constraint(equalToConstant: 25),
            favoriteImage.widthAnchor.constraint(equalToConstant: 25),
            
            whiteBottomView.topAnchor.constraint(equalTo: doorsImage.bottomAnchor),
            whiteBottomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            whiteBottomView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            whiteBottomView.widthAnchor.constraint(equalTo: doorsImage.widthAnchor),
            whiteBottomView.heightAnchor.constraint(equalToConstant: 50),
            
            cameraName.centerYAnchor.constraint(equalTo: whiteBottomView.centerYAnchor),
            cameraName.leftAnchor.constraint(equalTo: whiteBottomView.leftAnchor, constant: 20),
            
            lockView.centerYAnchor.constraint(equalTo: whiteBottomView.centerYAnchor),
            lockView.rightAnchor.constraint(equalTo: whiteBottomView.rightAnchor),
            lockView.heightAnchor.constraint(equalToConstant: 50),
            lockView.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func favoriteState(state: Bool) {
        self.favoriteImage.isHidden = state ? false : true
    }
    
    func configure(model: DoorsRealmModel) {
        doorsImage.downloadImage(link: model.snapshot!)
        favoriteState(state: model.favorites)
        cameraName.text = model.name
    }
}
