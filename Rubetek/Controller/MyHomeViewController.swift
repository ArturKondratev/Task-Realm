//
//  MyHomeViewController.swift
//  Rubetek
//
//  Created by Артур Кондратьев on 10.07.2022.
//

import UIKit
import RealmSwift

class MyHomeViewController: UIViewController {
    
    // MARK: - Vars
    var refrControl = UIRefreshControl()
    var networkService = NetworkService()
    
    var realmService = RealmCashService()
    var realmNotificationCamera: NotificationToken?
    var realmNotificationDoor: NotificationToken?
    
    var cameras = [CamerasRealmModel]()
    var doors = [DoorsRealmModel]()
    
    lazy var filtredCameras = [CameraSection]()
    
    var roomsName = [String]()
    
    lazy var camerasButton: UIButton = {
        let camerasButton = UIButton(type: .system)
        camerasButton.translatesAutoresizingMaskIntoConstraints = false
        camerasButton.setTitle("Камеры", for: .normal)
        camerasButton.backgroundColor = .clear
        camerasButton.addTarget(self, action: #selector(showCameras), for: .touchUpInside)
        return camerasButton
    }()
    
    lazy var doorsButton: UIButton = {
        let doodsButton = UIButton(type: .system)
        doodsButton.translatesAutoresizingMaskIntoConstraints = false
        doodsButton.setTitle("Двери", for: .normal)
        doodsButton.backgroundColor = .clear
        doodsButton.addTarget(self, action: #selector(showDoors), for: .touchUpInside)
        return doodsButton
    }()
    
    lazy var segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["", ""])
        segment.selectedSegmentTintColor = .systemBlue
        segment.backgroundColor = .white
        segment.selectedSegmentIndex = 0
        segment.isEnabled = false
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    lazy var myTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 290
        return tableView
    }()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        self.title = "Мой дом"
        view.backgroundColor = .white
        setupViews()
        setupRefreshControl()
        
        loadDataCameras()
        loadDataDoors()
        loadCameraNames()
        
        makeObserverCameras(realm: realmService.realm)
        makeObserverDoors(realm: realmService.realm)
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            myTableView.register(CamerasCell.self, forCellReuseIdentifier: "CameraCell")
        default:
            myTableView.register(DoorsCell.self, forCellReuseIdentifier: "DoorCell")
        }
        
        myTableView.reloadData()
    }
}

extension MyHomeViewController {
    
    func setupViews() {
        view.addSubview(camerasButton)
        NSLayoutConstraint.activate([
            camerasButton.topAnchor.constraint(equalTo: view.topAnchor, constant:  100),
            camerasButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            camerasButton.heightAnchor.constraint(equalToConstant: 50),
            camerasButton.widthAnchor.constraint(equalToConstant: view.frame.width/2)
        ])
        
        view.addSubview(doorsButton)
        NSLayoutConstraint.activate([
            doorsButton.topAnchor.constraint(equalTo: view.topAnchor, constant:  100),
            doorsButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            doorsButton.heightAnchor.constraint(equalToConstant: 50),
            doorsButton.widthAnchor.constraint(equalToConstant: view.frame.width/2)
        ])
        
        view.addSubview(segmentControl)
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: camerasButton.bottomAnchor, constant: 10),
            segmentControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            segmentControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            segmentControl.heightAnchor.constraint(equalToConstant: 3),
            segmentControl.widthAnchor.constraint(equalToConstant: view.frame.width)
        ])
        
        view.addSubview(myTableView)
        NSLayoutConstraint.activate([
            myTableView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 5),
            myTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            myTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            myTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension MyHomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let camera = filtredCameras[indexPath.section]
        let favCamera = camera.data[indexPath.row]
        let door = doors[indexPath.row]
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            print(favCamera)
        default:
            print(door)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            return filtredCameras.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            return filtredCameras[section].data.count
        default:
            return doors.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            let section = filtredCameras[section]
            return section.key
        default:
            return nil
        }
    }
    
    //    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    //        return roomsName
    //    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "CameraCell", for: indexPath) as? CamerasCell else { return UITableViewCell() }
            let section = filtredCameras[indexPath.section]
            cell.configure(model: section.data[indexPath.row])
            return cell
            
        default:
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "DoorCell", for: indexPath) as? DoorsCell else { return UITableViewCell() }
            let door = doors[indexPath.row]
            cell.configure(model: door)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //MARK: - Add favorite camera
        if segmentControl.selectedSegmentIndex == 0 {
            
            let camera = filtredCameras[indexPath.section]
            let favCamera = camera.data[indexPath.row]
            
            let addFavorite = UIContextualAction(style: .normal, title: .none) { _, _, _ in
                
                favCamera.favorites = !favCamera.favorites
                self.realmService.update([favCamera])
            }
            addFavorite.backgroundColor = .lightGrayBackground
            addFavorite.image = {
                //let homeSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)
                let config = UIImage.SymbolConfiguration(paletteColors: [.systemYellow])
                let homeImage = UIImage(systemName: "star.circle", withConfiguration: config)
                return homeImage
            }()
            
            let swipeConfiguration = UISwipeActionsConfiguration(actions: [addFavorite])
            return swipeConfiguration
            
        } else {
            
            let door = doors[indexPath.row]
            
            //MARK: - Rename door
            let edit = UIContextualAction(style: .normal, title: .none) { _, _, _ in
                self.renameModel(name: door.name) { newName in
                    if door.name != newName {
                        let realm = try! Realm()
                        try! realm.write {
                            door.name = newName
                        }
                    } else {
                        return
                    }
                }
            }
            edit.backgroundColor = .lightGrayBackground
            edit.image = {
                let config = UIImage.SymbolConfiguration(paletteColors: [.systemBlue])
                let image = UIImage(systemName: "pencil.circle", withConfiguration: config)
                image?.withTintColor(.yellow)
                return image
            }()
            
            //MARK: - Add Favorite door
            let addFavorite = UIContextualAction(style: .normal, title: .none) { _, _, _ in
                let realm = try! Realm()
                try! realm.write {
                    door.favorites = !door.favorites
                }
            }
            addFavorite.backgroundColor = .lightGrayBackground
            addFavorite.image = {
                //let homeSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)
                let config = UIImage.SymbolConfiguration(paletteColors: [.systemYellow])
                let homeImage = UIImage(systemName: "star.circle", withConfiguration: config)
                return homeImage
            }()
            
            let swipeConfiguration = UISwipeActionsConfiguration(actions: [edit, addFavorite])
            return swipeConfiguration
        }
    }
    
    //MARK: - Pull-to-refresh
    func setupRefreshControl() {
        refrControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        refrControl.tintColor = .systemBlue
        refrControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        myTableView.refreshControl = refrControl
    }
    
    @objc func refreshData(_ sender: UIRefreshControl) {
        defer { sender.endRefreshing()}
        
        switch segmentControl.selectedSegmentIndex {
        case 0 :
            networkService.loadCameras { cameras in
                self.realmService.update(cameras)
            }
        default:
            networkService.loadDoors { doors in
                self.realmService.update(doors)
            }
        }
    }
    
    //MARK: - Functions
    func loadDataCameras() {
        let camerasRealm = realmService.read(CamerasRealmModel.self)
        if camerasRealm.isEmpty {
            networkService.loadCameras { cameras in
                self.realmService.create(cameras)
            }
        }
    }
    
    func loadDataDoors() {
        let doorsRealm =  realmService.read(DoorsRealmModel.self)
        if doorsRealm.isEmpty {
            networkService.loadDoors { doors in
                self.realmService.create(doors)
            }
        }
    }
    
    @objc func showCameras(sender: UIButton) {
        self.segmentControl.selectedSegmentIndex = 0
        myTableView.register(CamerasCell.self, forCellReuseIdentifier: "CameraCell")
        DispatchQueue.main.async {
            self.myTableView.reloadData()
        }
    }
    
    @objc func showDoors(sender: UIButton) {
        self.segmentControl.selectedSegmentIndex = 1
        myTableView.register(DoorsCell.self, forCellReuseIdentifier: "DoorCell")
        DispatchQueue.main.async {
            self.myTableView.reloadData()
        }
    }
    
    func renameModel(name: String, completinHandler: @escaping (String) -> Void) {
        
        let alertController =  UIAlertController(title: "Введите новое имя",
                                                 message: name,
                                                 preferredStyle: .alert)
        let allertOK = UIAlertAction(title: "Сохранить", style: .default) { (action) in
            let tftext = alertController.textFields?.first
            guard let text = tftext?.text else { return }
            completinHandler(text)
        }
        alertController.addTextField { (tf) in
            tf.text = name
        }
        let alertCancel = UIAlertAction(title: "Отмена",
                                        style: .default) { (_) in }
        alertController.addAction(allertOK)
        alertController.addAction(alertCancel)
        present(alertController, animated: true, completion: nil)
    }
    
    func makeObserverCameras(realm: Realm) {
        let objs = realmService.realm.objects(CamerasRealmModel.self)
        realmNotificationCamera = objs.observe({ changes in
            
            switch changes {
            case let .initial(objs):
                // self.cameras = Array(objs)
                self.filtredCameras = Factory.filterCameras(cameras: Array(objs))
                self.myTableView.reloadData()
            case .error(let error): print(error)
            case .update(let cameras, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                
                DispatchQueue.main.async { [self] in
                    // self.cameras = Array(cameras)
                    self.filtredCameras = Factory.filterCameras(cameras: Array(cameras))
                    
                    let deletionIndexSet = deletions.reduce(into: IndexSet(), { $0.insert($1) })
                    let insertIndexset = insertions.reduce(into: IndexSet(), { $0.insert($1) })
                    let modificationIndexSet = modifications.reduce(into: IndexSet(), { $0.insert($1) })
                    
                    self.myTableView.beginUpdates()
                    
                    self.myTableView.deleteSections(deletionIndexSet, with: .automatic)
                    self.myTableView.insertSections(insertIndexset, with: .automatic)
                    self.myTableView.reloadSections(modificationIndexSet, with: .automatic)
                    
                    self.myTableView.endUpdates()
                }
            }
        })
    }
    
    func makeObserverDoors(realm: Realm) {
        let objs = realmService.realm.objects(DoorsRealmModel.self)
        realmNotificationDoor = objs.observe({ changes in
            
            switch changes {
            case let .initial(objs):
                self.doors = Array(objs)
                self.myTableView.reloadData()
            case .error(let error): print(error)
            case .update(let doors, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                
                DispatchQueue.main.async { [self] in
                    self.doors = Array(doors)
                    
                    self.myTableView.beginUpdates()
                    
                    self.myTableView.insertRows(at: insertions.map ({ IndexPath(row: $0, section: 0)}), with: .automatic)
                    self.myTableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
                    self.myTableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
                    
                    self.myTableView.endUpdates()
                }
            }
        })
    }
    
    func loadCameraNames() {
        for camera in filtredCameras {
            roomsName.append(String(camera.key))
        }
    }
    
}
