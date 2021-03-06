//
//  FIndPasswordViewController.swift
//  Knowing
//
//  Created by Jun on 2021/11/10.
//

import UIKit
import RxSwift
import RxCocoa
import Foundation

class FindPasswordViewController: UIViewController {

    let disposeBag = DisposeBag()
    let vm = FindPasswordViewModel()
    
    let backBt = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "backArrow"), for: .normal)
    }
    
    let titleLb = UILabel().then {
        $0.text = "비밀번호 재설정"
        $0.font = UIFont(name: "GodoM", size: 24)
        $0.textColor = UIColor.rgb(red: 101, green: 101, blue: 101)
    }
    
    let subView = UIImageView(image: UIImage(named: "findPw")!)
    
    let subTitle1 = UILabel().then {
        $0.text = "아래 항목을 입력하시면 비밀번호"
        $0.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
        $0.textColor = UIColor.rgb(red: 147, green: 147, blue: 147)
    }
    
    let subTitle2 = UILabel().then {
        $0.text = "재설정 메일을 보내드립니다."
        $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        $0.textColor = UIColor.rgb(red: 255, green: 136, blue: 84)
    }
    
    let nameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)
        $0.textColor = UIColor.rgb(red: 100, green: 98, blue: 94)
    }
    
    let nameTextField = CustomTextField(image: UIImage(named: "person")!, text: "닉네임 입력", state: .login).then {
        $0.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        
    }
    
    let emailLabel = UILabel().then {
        $0.text = "이메일"
        $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)
        $0.textColor = UIColor.rgb(red: 100, green: 98, blue: 94)
    }
    
    let emailTextField = CustomTextField(image: UIImage(named: "email")!, text: "이메일 주소 입력", state: .login).then {
        $0.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
    }
    
    let confirmBt = UIButton(type: .custom).then {
        $0.setTitle("재설정 메일 보내기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        $0.titleLabel?.textColor = .white
        $0.backgroundColor = UIColor.rgb(red: 210, green: 210, blue: 210)
        $0.layer.cornerRadius = 27.0
        $0.contentEdgeInsets = UIEdgeInsets(top: 15, left: 102, bottom: 15, right: 102)
        $0.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lightMode()
        setUI()
        bind()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

extension FindPasswordViewController {
    func setUI() {
        view.backgroundColor = .white
        
        safeArea.addSubview(backBt)
        backBt.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.leading.equalToSuperview().offset(19)
        }
        
        safeArea.addSubview(titleLb)
        titleLb.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25)
            $0.centerX.equalToSuperview()
        }
        
        safeArea.addSubview(subView)
        subView.snp.makeConstraints {
            $0.top.equalTo(titleLb.snp.bottom).offset(37)
            $0.leading.equalToSuperview().offset(25)
            $0.trailing.equalToSuperview().offset(-25)
        }
        
        subView.addSubview(subTitle1)
        subTitle1.snp.makeConstraints {
            $0.top.equalToSuperview().offset(17)
            $0.centerX.equalToSuperview()
        }
        subView.addSubview(subTitle2)
        subTitle2.snp.makeConstraints {
            $0.top.equalTo(subTitle1.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
        
        safeArea.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(subView.snp.bottom).offset(31)
            $0.leading.equalToSuperview().offset(25)
        }
        
        safeArea.addSubview(nameTextField)
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(25)
            $0.trailing.equalToSuperview().offset(-25)
        }
        
        safeArea.addSubview(emailLabel)
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(28)
            $0.leading.equalToSuperview().offset(25)
        }
        
        safeArea.addSubview(emailTextField)
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(25)
            $0.trailing.equalToSuperview().offset(-25)
        }
        
        safeArea.addSubview(confirmBt)
        confirmBt.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(35)
            $0.leading.equalToSuperview().offset(25)
            $0.trailing.equalToSuperview().offset(-25)
        }
        
    }
    
    func bind() {
        bindInput()
        bindOutput()
    }
    
    func bindInput() {
        
        backBt.rx.tap.subscribe(onNext: {
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        nameTextField.rx.controlEvent([.editingDidEnd])
            .map { self.nameTextField.text ?? "" }
            .bind(to: self.vm.input.nameObserver)
            .disposed(by: disposeBag)
        
        emailTextField.rx.controlEvent([.editingDidEnd])
            .map { self.emailTextField.text ?? "" }
            .bind(to: self.vm.input.emailObserver)
            .disposed(by: disposeBag)
        
        confirmBt.rx.tap
            .bind(to: self.vm.input.buttonObserver)
            .disposed(by: disposeBag)
        
    }
    
    func bindOutput() {
        
        vm.output.btValid.drive(onNext: {value in
            if value {
                self.confirmBt.backgroundColor = UIColor.rgb(red: 255, green: 136, blue: 84)
                self.confirmBt.isEnabled = true
            } else {
                self.confirmBt.backgroundColor = UIColor.rgb(red: 210, green: 210, blue: 210)
                self.confirmBt.isEnabled = false
            }
        }).disposed(by: disposeBag)
        
        vm.output.findPassword.asSignal()
            .emit(onNext:  { value in
            let vc = ConfirmPasswordViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true)
        }).disposed(by: disposeBag)
        
        vm.output.errorRelay.asSignal()
            .emit(onNext: { value in
            
            let alertController = UIAlertController(title: "에러", message: value.msg, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
            self.present(alertController, animated: true)
            
        }).disposed(by: disposeBag)
        
    }
}
