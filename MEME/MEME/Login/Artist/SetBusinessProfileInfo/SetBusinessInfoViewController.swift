//
//  SetBusinessInfoViewController.swift
//  MEME
//
//  Created by 이동현 on 1/28/24.
//

import UIKit
import PhotosUI

final class SetBusinessInfoViewController: UIViewController {

    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var navigationBar: NavigationBarView!
    @IBOutlet private weak var progressBar: RegisterProgressBar!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var warningLabel: UILabel!
    @IBOutlet private weak var femaleButton: UIButton!
    @IBOutlet private weak var maleButton: UIButton!
    @IBOutlet private weak var introduceTextView: UITextView!
    @IBOutlet private weak var careerLabel: UILabel!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var careerView: UIView!
    @IBOutlet private weak var careerButton: UIButton!
    @IBOutlet private weak var verificationButton: UIButton!
    
    private lazy var pickerView = UIPickerView()
    private var phpPicker: PHPickerViewController?
    private var imagePicker: UIImagePickerController?
    private var isGenderSelected = false
    private var isVerified = true
    private var career: String?
    private var builder = ArtistProfileInfoBuilder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        navigationBar.delegate = self
        navigationBar.configure(title: "프로필 입력")
        progressBar.configure(progress: 0)
        nextButton.layer.cornerRadius = 10
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        
        [
            nameTextField,
            femaleButton,
            maleButton,
            introduceTextView,
            careerView
        ].forEach {
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.gray400.cgColor
            $0?.layer.cornerRadius = 9
        }

        setUpPhpPicker()
        setUpimagePicker()
        setCareerButton()
        scrollView.delegate = self
        verificationButton.layer.cornerRadius = 10
        verificationButton.layer.borderColor = UIColor.mainBold.cgColor
        verificationButton.layer.borderWidth = 1
        nameTextField.delegate = self
        
        setNextButton()
    }
    
    private func setCareerButton() {
        var careerActions: [UIAction] = []

        for experience in WorkExperience.allCases {
            let action = UIAction(
                title: experience.description,
                image: nil,
                handler: { [weak self] _ in
                    self?.careerLabel.text = experience.description
                    self?.career = experience.rawValue
                    self?.setNextButton()
                }
            )
            careerActions.append(action)
            careerButton.showsMenuAsPrimaryAction = true
        }

        careerButton.menu = UIMenu(
            title: "",
            image: nil,
            identifier: nil,
            options: .displayInline,
            children: careerActions
        )
    }
    
    private func setNextButton() {
        guard
            nameTextField.text != nil,
            career != nil,
            isVerified
        else {
            nextButton.backgroundColor = .gray300
            nextButton.isEnabled = false
            return
        }
        
        if let text = introduceTextView.text {
            builder = builder.introduction(text)
        }

        nextButton.backgroundColor = .mainBold
        nextButton.isEnabled = true
    }
    
    @IBAction private func genderButtonTapped(_ sender: UIButton) {
        isGenderSelected = true
        let buttons = [maleButton, femaleButton]
        
        buttons.forEach {
            if sender.tag == $0?.tag {
                $0?.layer.borderColor = UIColor.mainBold.cgColor
                $0?.tintColor = .mainBold
            } else {
                $0?.layer.borderColor = UIColor.gray300.cgColor
                $0?.tintColor = .black
            }
        }
        
        if sender.tag == 0 {
            builder = builder.gender(.FEMALE)
        } else {
            builder = builder.gender(.MALE)
        }
        
        setNextButton()
    }
    
    @IBAction private func profileImageButtonTapped(_ sender: Any) {
        guard
            let phpPicker = self.phpPicker,
            let imagePicker = self.imagePicker
        else { return }
        
        let alert = UIAlertController(title: "프로필 사진 설정", message: nil, preferredStyle: .actionSheet)
        let albumAction = UIAlertAction(title: "앨범에서 사진 선택", style: .default) { _ in
            self.present(phpPicker, animated: true)
        }
        let cameraAction = UIAlertAction(title: "사진 촬영", style: .default) { _ in
            self.present(imagePicker, animated: true)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(albumAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }    
    
    @IBAction private func nextButtonTapped(_ sender: Any) {
        guard
            let nickName = nameTextField.text,
            let career = career,
            isVerified
        else {
            nextButton.backgroundColor = .gray300
            nextButton.isEnabled = false
            return
        }
        
        builder = builder.nickName(nickName)
        builder = builder.workExperience(career)
        
        if let text = introduceTextView.text {
            builder = builder.introduction(text)
        }
        
        let nextVC = SetBusinessLocationViewController()
        nextVC.configure(builder: builder)
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction private func verificationButtonTapped(_ sender: Any) {
        isVerified = true
        setNextButton()
    }
    
}

// MARK: - 사진 선택 설정
extension SetBusinessInfoViewController: PHPickerViewControllerDelegate {
    
    func picker(
        _ picker: PHPickerViewController,
        didFinishPicking results: [PHPickerResult]
    ) {
        picker.dismiss(animated: true, completion: nil)
        guard
            let itemProvider = results.first?.itemProvider,
            itemProvider.canLoadObject(ofClass: UIImage.self)
        else { return }
        
        itemProvider.loadObject(ofClass: UIImage.self) { image, error in
            DispatchQueue.main.async {
                guard let selectedImage = image as? UIImage else { return }
                self.profileImageView.image = selectedImage
            }
        }
    }
    
    private func setUpPhpPicker() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        phpPicker = PHPickerViewController(configuration: configuration)
        phpPicker?.delegate = self
    }
}

extension SetBusinessInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        if let image = info[.originalImage] as? UIImage {
            profileImageView.image = image
        }
        imagePicker?.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker?.dismiss(animated: true)
    }
    
    private func setUpimagePicker() {
        imagePicker = UIImagePickerController()
        imagePicker?.sourceType = .camera
        imagePicker?.delegate = self
    }
}

// MARK: - 뒤로가기 delegate
extension SetBusinessInfoViewController: BackButtonTappedDelegate {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension SetBusinessInfoViewController: UIScrollViewDelegate {
    
}


extension SetBusinessInfoViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isVerified = false
        warningLabel.isHidden = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            if text.count > 15 {
                warningLabel.text = "닉네임은 최대 15자 작성가능합니다."
                warningLabel.textColor = .red
                warningLabel.isHidden = false
            }
        }
    }
}
