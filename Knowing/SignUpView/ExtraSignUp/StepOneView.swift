//
//  ExtraSignOne.swift
//  Knowing
//
//  Created by Jun on 2021/11/03.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class StepOneView: UIView {
    
    let vm = ExtraSignUpViewModel.instance
    var disposeBag = DisposeBag()
    
    let starImg = UIImageView(image: UIImage(named: "star")!)
    
    let residenceLb = UILabel().then {
        $0.text = "거주지"
        $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        $0.textColor = UIColor.rgb(red: 102, green: 102, blue: 102)
    }
    
    let subLb = UILabel().then {
        $0.text = "아래 사항 해당 시 체크해주세요."
        $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        $0.textColor = UIColor.rgb(red: 102, green: 102, blue: 102)
    }
    
    let cityBt = CustomPicker("시/도 선택")
    let guBt = CustomPicker("시/군/구 선택")
    
    let cityAlertLb = UILabel().then {
        $0.text = ""
        $0.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 11)
        $0.textColor = UIColor.rgb(red: 255, green: 108, blue: 0)
    }
    
    let checkBox = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "checkbox_unselected")!, for: .normal)
    }
    
    let cbLabel = UILabel().then {
        $0.attributedText = NSAttributedString(string: "가장, 다문화가정, 한부모가정,\n군인의 자녀, 장애인, 다자녀,\n북한이탈주민자녀, 국자유공자자녀").withLineSpacing(2)
        $0.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        $0.textColor = UIColor.rgb(red: 115, green: 115, blue: 115)
        $0.numberOfLines = 3
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        addSubview(starImg)
        starImg.snp.makeConstraints {
            $0.top.equalToSuperview().offset(55)
            $0.leading.equalToSuperview().offset(26)
        }
        
        
        addSubview(residenceLb)
        residenceLb.snp.makeConstraints {
            $0.top.equalToSuperview().offset(52)
            $0.leading.equalTo(starImg.snp.trailing).offset(4)
        }
        
       addSubview(cityBt)
        cityBt.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(25)
            $0.top.equalTo(residenceLb.snp.bottom).offset(20)
        }
        
        addSubview(guBt)
        guBt.snp.makeConstraints {
            $0.top.equalTo(residenceLb.snp.bottom).offset(20)
            $0.leading.equalTo(cityBt.snp.trailing).offset(26)
        }
        
        addSubview(cityAlertLb)
        cityAlertLb.snp.makeConstraints {
            $0.top.equalTo(cityBt.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(25)
        }
        
        addSubview(subLb)
        subLb.snp.makeConstraints {
            $0.top.equalTo(cityAlertLb.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(25)
        }
        
        addSubview(checkBox)
        checkBox.snp.makeConstraints {
            $0.top.equalTo(subLb.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(17)
        }
        
        addSubview(cbLabel)
        cbLabel.snp.makeConstraints {
            $0.top.equalTo(subLb.snp.bottom).offset(16)
            $0.leading.equalTo(checkBox.snp.trailing).offset(3)
        }
    }
    
    func bind() {
        bindInput()
        bindOutput()
    }
    
    func bindInput() {
        cityBt.rx.tap
            .bind(to: self.vm.stepOne.input.cityObserver)
            .disposed(by: disposeBag)
        
        guBt.rx.tap
            .map { self.cityBt.label.text ?? ""}
            .bind(to: self.vm.stepOne.input.guObserver)
            .disposed(by: disposeBag)
    }
    
    func bindOutput() {
        vm.stepOne.output.cityValue
            .drive(onNext:{ value in
                self.cityBt.label.text = value
                self.cityBt.label.textColor = UIColor.rgb(red: 194, green: 194, blue: 194)
                self.cityAlertLb.text = ""
            })
            .disposed(by: disposeBag)
        
        vm.stepOne.output.goGuView
            .drive(onNext: { value in
                if value == "시/도 선택" {
                    self.cityAlertLb.text = "[시/도]를 먼저 선택해주세요."
                    self.cityBt.label.textColor = UIColor.rgb(red: 255, green: 108, blue: 0)
                } else {
                    self.cityAlertLb.text = ""
                    self.cityBt.label.textColor = UIColor.rgb(red: 194, green: 194, blue: 194)
                }
            })
            .disposed(by: disposeBag)
        
        vm.stepOne.output.guValue
            .drive(onNext: { value in
                self.guBt.label.text = value
            }).disposed(by: disposeBag)
    }
    
    
}

