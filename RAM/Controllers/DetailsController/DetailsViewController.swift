//
//  Untitled.swift
//  RAM
//
//  Created by Aaa on 26.10.2024.
//

import UIKit
import AVFoundation
import Photos

final class DetailsViewController: UIViewController {
    
    //MARK: Private properties
    private let characterImage = UIImageView()
    private let cameraButton = UIButton()
    private let nameLabel = UILabel()
    private let infoTableView = DetailsInfoTableView()
    
    var viewModel: EpisodesCellViewModel! {
        didSet {
            infoTableView.character = viewModel.character
            viewModel.imageURL = viewModel.character.image
            viewModel.getImage {[weak self] in
                guard let imageData = self?.viewModel.imageData else {return}
                self?.characterImage.image = UIImage(data: imageData)
            }
            nameLabel.text = viewModel.nameCharacter
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
    }
    
    
    //MARK: Private objc-c Methods
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func cameraButtonTapped() {
        let alert = UIAlertController(title:"Загрузить изображение", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Камера", style: .default) { _ in
            self.checkCameraPermissions()
        }
        
        let galleryAction = UIAlertAction(title: "Галерея", style: .default) { _ in
            self.checkPhotoLibraryPermissons()
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
}

//MARK: UI
private extension DetailsViewController {
    func setupUI() {
        view.backgroundColor = .backGround
        setupCharacterImage()
        setupCameraButton()
        setupNameCharacter()
        setupInfoTableView()
    }
    
    func setupNavigationBar() {
        ///swipe left - go back
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "goback"), for: .normal)
        backButton.setAttributedTitle(NSAttributedString(string: " GO BACK ",
                                                         attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .semibold)]), for: .normal)
        //costomize content inside in button
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.tintColor = .black
        backButton.contentHorizontalAlignment = .leading
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for:.touchUpInside )
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let rightImage = UIImageView(image: UIImage(named: "characterTitleImage"))
        rightImage.contentMode = .scaleAspectFit
        rightImage.clipsToBounds = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightImage)
        
        navigationController?.navigationBar.tintColor = UIColor(named: "navTintColor")
        
    }
    
    func setupCharacterImage() {
        view.addSubview(characterImage)
        characterImage.translatesAutoresizingMaskIntoConstraints = false
        characterImage.contentMode = .scaleAspectFit
        characterImage.clipsToBounds = true
        
        characterImage.layer.cornerRadius = 75
        characterImage.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        characterImage.layer.borderWidth = 4
        setupCharacterImageConstraint()
    }
    
    func setupCameraButton() {
        view.addSubview(cameraButton)
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        cameraButton.setImage(UIImage(named: "camera"), for: .normal)
        cameraButton.tintColor = UIColor(named: "cameraColor")
        
        cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        
        setupCameraButtonConstraint()
    }
    
    func setupNameCharacter() {
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 32)
        nameLabel.textColor = UIColor(named: "cameraColor")
        nameLabel.textAlignment = .center
        nameLabel.sizeToFit()
        setupNameLabelConstraint()
    }
    
    func setupInfoTableView() {
        view.addSubview(infoTableView)
        infoTableView.translatesAutoresizingMaskIntoConstraints = false
        setupTableConstraint()
    }
    
    //MARK: Setup Constraint Methods
    func setupCharacterImageConstraint() {
        NSLayoutConstraint.activate([
            characterImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            characterImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            characterImage.widthAnchor.constraint(equalToConstant: 147),
            characterImage.heightAnchor.constraint(equalTo: characterImage.widthAnchor)
        ])
    }
    
    func setupCameraButtonConstraint() {
        NSLayoutConstraint.activate([
            cameraButton.centerYAnchor.constraint(equalTo: characterImage.centerYAnchor),
            cameraButton.leadingAnchor.constraint(equalTo: characterImage.trailingAnchor, constant: 8),
            cameraButton.widthAnchor.constraint(equalToConstant: 24),
            cameraButton.heightAnchor.constraint(equalToConstant: 21)
            
        ])
    }
    
    func setupNameLabelConstraint(){
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: characterImage.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: characterImage.bottomAnchor, constant: 49)
        ])
    }
    
    func setupTableConstraint() {
        NSLayoutConstraint.activate([
            infoTableView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 18),
            infoTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoTableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            infoTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }
    
}

//MARK: Gesture Recognizer Delegate
//swipe left - go back
extension DetailsViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}

//MARK: Alert Methods
extension DetailsViewController: UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    private func checkCameraPermissions() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)//проверяет текущее разрешение
        
        switch cameraAuthorizationStatus {
        case .notDetermined: //если разрешение еще не запрашивалось делается запрос. Если разрешилось(true) открывается камера
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async{
                        self.openCamera()
                    }
                }
            }
        case .restricted, .denied: // если доступ запрещен, открывается метод ->
            showSettingsAlert(for: "Камера") //отображение сообщения о необходимости разрешения
        case .authorized: // если доступ есть - открывается камера
            openCamera()
        @unknown default:
            break
        }
    }
    
    private func checkPhotoLibraryPermissons() {
        // проверяет доступ к фотогалерее
        let photoAutorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAutorizationStatus {
        case .notDetermined : // запрашивается разрешение если его нет. Если разрешение получено - открывается галерея
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    DispatchQueue.main.async {
                        self.openPhotoLibrary()
                    }
                }
            }
        case .restricted, .denied: //если доступ запрещен открывается ->
            showSettingsAlert(for: "Галерея")
        case .authorized, .limited: // если доступ есть открывается галерея
            openPhotoLibrary()
        @unknown default:
            break
        }
    }
    
    private func showSettingsAlert(for feature: String) {
        //сообщает, что доступ к камере или галереи запрещен и предлагает открыть настройки
        let alert = UIAlertController (
            title: "\(feature) недоступна",
            message: "Разрешите доступ в настройках.",
            preferredStyle: .alert
            )
        
        //кнопка: открыть системные настройки приложения
        alert.addAction(UIAlertAction(title: "Открыть настройки", style: .default) { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        })
        //кнопка: закрыть предупреждение
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func openCamera() {
        //проверяет доступна ли камера.
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            //если камера доступна открывает ->
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .camera //Устанавливает источник как камеру(.camera)
            picker.allowsEditing = true // возможность
            present(picker, animated: true)
        } else { //показывает ошибку
            showErrorAlert(message: "Камера не доступна на этом устройстве")
        }
    }
    
    private func openPhotoLibrary() {
        //аналогично камере открывает галерея
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            present(picker, animated: true)
        }
    }
    
    private func showErrorAlert(message: String) {
        //показывает сообщение об ошибке, если камера недоступна или другие проблемы
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        //кнопка ОК
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //устанавливает отредактированное
        if let editedImage = info[.editedImage] as? UIImage {
            characterImage.image = editedImage
        // выбранное изображение
        } else if let originalImage = info[.originalImage] as? UIImage {
            characterImage.image = originalImage
        }
        //закрывает контроллер
        picker.dismiss(animated: true)
    }
    
    //закрывает UIImagePickerController если пользователь ничего не выбрал
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}
