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
    var networkService = NetworkService()
    var realmService = RealmCashService()
    
    var realmNotificationCameraRoom: NotificationToken?
    var realmNotificationDoor: NotificationToken?
    
    var rooms = [CamerasRealmRoom]()
    var doors = [DoorsRealmModel]()
    
    lazy var camerasButton: UIButton = {
        let camerasButton = UIButton(type: .system)
        camerasButton.translatesAutoresizingMaskIntoConstraints = false
        camerasButton.setTitle("Камеры", for: .normal)
        camerasButton.tintColor = .black
        camerasButton.backgroundColor = .clear
        camerasButton.addTarget(self, action: #selector(showCameras), for: .touchUpInside)
        return camerasButton
    }()
    
    lazy var doorsButton: UIButton = {
        let doodsButton = UIButton(type: .system)
        doodsButton.translatesAutoresizingMaskIntoConstraints = false
        doodsButton.setTitle("Двери", for: .normal)
        doodsButton.tintColor = .black
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
    
    lazy var cameraTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.isHidden = false
        let cameraRefControl: UIRefreshControl = {
            let refControl = UIRefreshControl()
            refControl.attributedTitle = NSAttributedString(string: "Refreshing...")
            refControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
            return refControl
        }()
        tableView.refreshControl = cameraRefControl
        return tableView
    }()
    
    lazy var doorTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.isHidden = true
        let doorRefControl: UIRefreshControl = {
            let refControl = UIRefreshControl()
            refControl.attributedTitle = NSAttributedString(string: "Refreshing...")
            refControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
            return refControl
        }()
        tableView.refreshControl = doorRefControl
        return tableView
    }()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Мой дом"
        view.backgroundColor = .lightGrayBackground
        setupViews()
        
        loadDataCameras()
        loadDataDoors()
        makeObserverCamerasRooms(realm: realmService.realm)
        makeObserverDoors(realm: realmService.realm)
        
        cameraTableView.register(CamerasCell.self, forCellReuseIdentifier: CamerasCell.identifier)
        doorTableView.register(DoorsCell.self, forCellReuseIdentifier: DoorsCell.identifier)
        doorTableView.register(DoorsImageCell.self, forCellReuseIdentifier: DoorsImageCell.identifier)
        
        if segmentControl.selectedSegmentIndex == 0 {
            cameraTableView.delegate = self
            cameraTableView.dataSource = self
            cameraTableView.reloadData()
            
        } else {
            doorTableView.delegate = self
            doorTableView.dataSource = self
            doorTableView.reloadData()
        }
    }
    
    
    func setupViews() {
        view.addSubview(camerasButton)
        view.addSubview(doorsButton)
        view.addSubview(segmentControl)
        view.addSubview(cameraTableView)
        view.addSubview(doorTableView)
        
        NSLayoutConstraint.activate([
            camerasButton.topAnchor.constraint(equalTo: view.topAnchor, constant:  100),
            camerasButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            camerasButton.heightAnchor.constraint(equalToConstant: 50),
            camerasButton.widthAnchor.constraint(equalToConstant: view.frame.width/2),
            
            doorsButton.topAnchor.constraint(equalTo: view.topAnchor, constant:  100),
            doorsButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            doorsButton.heightAnchor.constraint(equalToConstant: 50),
            doorsButton.widthAnchor.constraint(equalToConstant: view.frame.width/2),
            
            segmentControl.topAnchor.constraint(equalTo: camerasButton.bottomAnchor, constant: 10),
            segmentControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            segmentControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            segmentControl.heightAnchor.constraint(equalToConstant: 3),
            segmentControl.widthAnchor.constraint(equalToConstant: view.frame.width),
            
            cameraTableView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 5),
            cameraTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            cameraTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            cameraTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            doorTableView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 20),
            doorTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            doorTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            doorTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension MyHomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if segmentControl.selectedSegmentIndex == 0 {
            return 290
            
        } else {
            guard doors[indexPath.row].snapshot != nil else { return 70
            }
            
            return 290
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            return rooms[section].roomName
        default:
            return nil
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            return rooms.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            let currentRoom = rooms[section]
            let count = currentRoom.cameras.count
            return currentRoom.cameras.isEmpty ? 0 : count
        default:
            return doors.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segmentControl.selectedSegmentIndex == 0 {
            
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: CamerasCell.identifier, for: indexPath) as? CamerasCell else { return UITableViewCell() }
            let currentRoom = rooms[indexPath.section]
            let currentCamera = currentRoom.cameras[indexPath.row]
            cell.configure(model: currentCamera)
            return cell
            
        } else {
            
            let door = doors[indexPath.row]
            
            if door.snapshot == nil {
                
                let cell = doorTableView.dequeueReusableCell(withIdentifier: DoorsCell.identifier, for: indexPath) as! DoorsCell
                cell.configure(model: door)
                return cell
                
            } else {
                let cell = doorTableView.dequeueReusableCell(withIdentifier: DoorsImageCell.identifier, for: indexPath) as! DoorsImageCell
                cell.configure(model: door)
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //MARK: - Add favorite camera
        if segmentControl.selectedSegmentIndex == 0 {
            
            let currentRoom = rooms[indexPath.section]
            let currentCamera = currentRoom.cameras[indexPath.row]
            
            let addFavorite = UIContextualAction(style: .normal, title: .none) { _, _, _ in
                
                let realm = try! Realm()
                try! realm.write {
                    currentCamera.favorites = !currentCamera.favorites
                }
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
            
            let swipeConfiguration = UISwipeActionsConfiguration(actions: [addFavorite, edit])
            return swipeConfiguration
        }
    }
    
    //MARK: - Pull-to-refresh
    @objc func refreshData(_ sender: UIRefreshControl) {
        defer { sender.endRefreshing()}
        
        switch segmentControl.selectedSegmentIndex {
        case 0 :
            networkService.loadCameras { cameras, rooms  in
                self.realmService.update(cameras)
                self.realmService.update(rooms)
            }
        default:
            networkService.loadDoors { doors in
                self.realmService.update(doors)
            }
        }
    }
    
    //MARK: - Functions
    func loadDataCameras() {
        let roomsWithCameras = realmService.read(CamerasRealmRoom.self)
        if roomsWithCameras.isEmpty {
            networkService.loadCameras { cameras, rooms in
                self.realmService.create(cameras)
                self.realmService.create(rooms)
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
        self.doorTableView.isHidden = true
        self.cameraTableView.isHidden = false
        doorTableView.delegate = nil
        doorTableView.dataSource = nil
        cameraTableView.delegate = self
        cameraTableView.dataSource = self
        DispatchQueue.main.async {
            self.cameraTableView.reloadData()
        }
    }
    
    @objc func showDoors(sender: UIButton) {
        self.segmentControl.selectedSegmentIndex = 1
        self.cameraTableView.isHidden = true
        self.doorTableView.isHidden = false
        cameraTableView.delegate = nil
        cameraTableView.dataSource = nil
        doorTableView.delegate = self
        doorTableView.dataSource = self
        DispatchQueue.main.async {
            self.doorTableView.reloadData()
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
    
    func makeObserverCamerasRooms(realm: Realm) {
        let objs = realmService.realm.objects(CamerasRealmRoom.self)
        realmNotificationCameraRoom = objs.observe({ changes in
            
            switch changes {
            case let .initial(objs):
                self.rooms = Array(objs)
                self.cameraTableView.reloadData()
            case .error(let error): print(error)
            case .update(let rooms, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                
                DispatchQueue.main.async { [self] in
                    self.rooms = Array(rooms)
                    
                    let deletionIndexSet = deletions.reduce(into: IndexSet(), { $0.insert($1) })
                    let insertIndexset = insertions.reduce(into: IndexSet(), { $0.insert($1) })
                    let modificationIndexSet = modifications.reduce(into: IndexSet(), { $0.insert($1) })
                    
                    self.cameraTableView.beginUpdates()
                    
                    self.cameraTableView.deleteSections(deletionIndexSet, with: .automatic)
                    self.cameraTableView.insertSections(insertIndexset, with: .automatic)
                    self.cameraTableView.reloadSections(modificationIndexSet, with: .automatic)
                    
                    self.cameraTableView.endUpdates()
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
                self.doorTableView.reloadData()
            case .error(let error): print(error)
            case .update(let doors, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                
                DispatchQueue.main.async { [self] in
                    self.doors = Array(doors)
                    
                    self.doorTableView.beginUpdates()
                    
                    self.doorTableView.insertRows(at: insertions.map ({ IndexPath(row: $0, section: 0)}), with: .automatic)
                    self.doorTableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
                    self.doorTableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
                    
                    self.doorTableView.endUpdates()
                }
            }
        })
    }
}

