//
//  DoorsCell.swift
//  Rubetek
//
//  Created by Артур Кондратьев on 10.07.2022.
//

import UIKit

class DoorsCell: UITableViewCell {
    
    static let identifier: String = "DoorsCell"
    
    lazy var doorImage: UIImageView = {
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
    
    lazy var lockView: LockView = {
        let lock = LockView()
        lock.translatesAutoresizingMaskIntoConstraints = false
        lock.backgroundColor = .white
        return lock
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    let image = "https://www.industrialempathy.com/img/remote/ZiClJf-1920w.jpg"
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
       // iconFrame()
    }
}

extension DoorsCell {
    
    func setupViews() {
        contentView.backgroundColor = .lightGrayBackground
        
        contentView.addSubview(doorImage)
        NSLayoutConstraint.activate([
            doorImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            doorImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30),
            doorImage.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30),
            doorImage.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        doorImage.addSubview(favoriteImage)
        NSLayoutConstraint.activate([
            favoriteImage.topAnchor.constraint(equalTo: doorImage.topAnchor, constant: 10),
            favoriteImage.rightAnchor.constraint(equalTo: doorImage.rightAnchor, constant: -10),
            favoriteImage.heightAnchor.constraint(equalToConstant: 25),
            favoriteImage.widthAnchor.constraint(equalToConstant: 25)
        ])
        
        contentView.addSubview(whiteBottomView)
        NSLayoutConstraint.activate([
            whiteBottomView.topAnchor.constraint(equalTo: doorImage.bottomAnchor),
            whiteBottomView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30),
            whiteBottomView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30),
            whiteBottomView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        whiteBottomView.addSubview(cameraName)
        NSLayoutConstraint.activate([
            cameraName.centerYAnchor.constraint(equalTo: whiteBottomView.centerYAnchor),
            cameraName.leftAnchor.constraint(equalTo: whiteBottomView.leftAnchor, constant: 20)
        ])
        
        whiteBottomView.addSubview(lockView)
        NSLayoutConstraint.activate([
            lockView.centerYAnchor.constraint(equalTo: whiteBottomView.centerYAnchor),
            lockView.rightAnchor.constraint(equalTo: whiteBottomView.rightAnchor),
            lockView.heightAnchor.constraint(equalToConstant: 50),
            lockView.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configure(model: DoorsRealmModel) {
        self.cameraName.text = model.name
       // favoriteState(state: model.favorites)
       
       // if ((model.snapshot?.isEmpty) != nil) {
        
            self.doorImage.downloadImage(link: model.snapshot ?? image)
            favoriteState(state: model.favorites)
          //  iconFrame()
      //  }
    }
    
    func favoriteState(state: Bool) {
        self.favoriteImage.isHidden = state ? false : true
    }
    
    
//    func iconFrame() {
//
//        let iconSideLinght: CGFloat = 100
//
//        let iconSize = CGSize(width: iconSideLinght,
//                              height: iconSideLinght)
//        let iconOrigin = CGPoint(x: bounds.midX - iconSideLinght / 2,
//                                 y: bounds.midY - iconSideLinght / 2)
//
//        doorImage.frame = CGRect(origin: iconOrigin, size: iconSize)
//    }
    
    
//    func iconFrame() {
//    let iconSideLinght: CGFloat = 200
//        let iconSize = CGSize(width: bounds.width - 60, height:
//    iconSideLinght)
//    let iconOrigin = CGPoint(x: bounds.midX - iconSideLinght / 2, y:
//    bounds.midY - iconSideLinght / 2)
//        doorImage.frame = CGRect(origin: iconOrigin, size: iconSize)
//    }
}
