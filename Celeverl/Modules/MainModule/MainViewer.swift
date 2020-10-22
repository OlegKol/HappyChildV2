//
import UIKit
import Foundation

class MainViewer: UIViewController, MainViewerProtocol, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //MARK: - MainViewerProtocol implementation
    var interactor: MainInteractorProtocol?
    var router: MainRouterProtocol?

    func showError(error: String) {
        self.mainQueue.async {
            self.panel.errorLabel.text = error
        }
    }

    func hideError() {
       self.mainQueue.async {
           self.panel.errorLabel.text = ""
       }
    }

    func changePhoneField(mobile: String){
        self.mainQueue.async {
            self.panel.field.placeholder = mobile
        }
    }

    func changeCodeCountry(_ countryCode: String){
        self.mainQueue.async {
            self.panel.button.title = countryCode
        }
    }
    
    func changedBusyState(_ state: Bool) {
        self.mainQueue.async {
            self.panel.codeButton.isBusy = state
        }
    }
    
    func updateCountryData(_ data: [CountryCodeModel]) {
        self.mainQueue.async {
            self.dataCountryList = data
            self.customPicker.reloadAllComponents()
        }
    }
    
    func setCurrentCountryData(_ country: CountryCodeModel) {
        self.mainQueue.async {
            self.currentCountry = country
            self.panel.button.title = "+\(country.Code)"
        }
    }
    
    //MARK: - Properrties
    lazy var mainTitle: UILabel = {
        var label = UILabel()
        return label
    }()
    lazy var bottomPanel: UIView = {
        var panel = UIView()
        return panel
    }()
    
    lazy var panel: LognInPanel = {
        var panel = LognInPanel()
        return panel
    }()
    lazy var closeButton: AppCustomButton = {
           var close = AppCustomButton()
           close.title = "Отмена"
           close.titleLabel?.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 22)
           close.titleLabel?.textColor = .black
           close.setTitleColor(.black, for: .normal)
           close.backgroundColor = UIColor.init(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
           return close
    }()
    lazy var updateButton: AppCustomButton = {
          var close = AppCustomButton()
          close.title = "Обновить"
          close.titleLabel?.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 22)
          close.titleLabel?.textColor = .black
          close.setTitleColor(.black, for: .normal)
          close.backgroundColor = UIColor.init(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
          return close
    }()
    
    var textField: UITextField = {
        var field = UITextField()
        field.returnKeyType = .next
        field.keyboardType = .namePhonePad
        return field
    }()
    
    var currentCountry: CountryCodeModel? = nil
    var dataCountryList: [CountryCodeModel] = []

    lazy var customPicker: UIPickerView = {
       let picker = UIPickerView()
       return picker
    }()
    
    lazy var mainQueue = DispatchQueue.main
    lazy var backQueue = DispatchQueue.global(qos: .background)
    
    
    override func loadView(){
        super.loadView()
        self.configureController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactor?.loadDefaultData()
        self.registerForKeyboardNotifications()
    }
    
    //MARK: - Configaure Views
    func configureController(){
        self.configuareMainTitle()
        self.configuareLogInPanel()
        self.configuareDataPicker()
        self.configuareToolbarButtons()
        
        self.view.addSubview(self.textField)
    }

    func configuareMainTitle(){
        
        let image = UIImage(named: "main_picture")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        self.view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.44).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1.68).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -14).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: -29).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true

        let radius: CGFloat = 10
        bottomPanel.backgroundColor = UIColor.white
        bottomPanel.layer.cornerRadius = radius
        bottomPanel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.view.addSubview(bottomPanel)
        bottomPanel.translatesAutoresizingMaskIntoConstraints = false
        bottomPanel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -radius).isActive = true
        bottomPanel.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        bottomPanel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        bottomPanel.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        bottomPanel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        
    }

    func configuareLogInPanel(){
        
        self.view.addSubview(panel)

        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.topAnchor.constraint(equalTo: self.bottomPanel.topAnchor, constant: 32).isActive = true
        panel.leftAnchor.constraint(equalTo: self.bottomPanel.leftAnchor, constant: 43).isActive = true
        panel.rightAnchor.constraint(equalTo: self.bottomPanel.rightAnchor , constant: -45).isActive = true
        
        panel.title.text = "На указанный номер мы вышлем код подтверждения"
        panel.title.textColor = AppConstants.APP_DEFAULT_TEXT_COLOR
        panel.title.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 18)
        panel.title.textAlignment = .center
        
        panel.codeButton.title = "Отправить код"
        panel.codeButton.backgroundColor = AppConstants.APP_DEFAULT_TEXT_COLOR
        panel.codeButton.titleLabel?.font = UIFont(name: AppConstants.APP_OPENSANS_REGULAR, size: 18)
        panel.codeButton.Action = {(button) in
            self.interactor?.checkPhone()
        }
        
        panel.field.placeholder = "номер телефона"
        panel.field.delegate = self
        panel.field.keyboardType = .phonePad
        panel.field.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 16)
        panel.field.addTarget(self, action: #selector(changedPhoneField), for: .editingChanged)
        panel.field.backgroundColor = UIColor.white
        panel.field.layer.borderWidth = 1
        panel.field.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        panel.button.Action = {(_) in
            self.showCountriesPhonesPanel()
            //self.showPicker()
        }
        panel.button.backgroundColor = AppConstants.APP_DEFAULT_TEXT_COLOR
        panel.button.titleLabel?.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 18)
        
        panel.agreementTitleView.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 10)
        panel.agreementTitleView.lineBreakMode = .byWordWrapping
        panel.agreementTitleView.textColor = UIColor.init(hex: "#868686", alpha: 1)
        panel.agreementTitleView.textAlignment = .justified
        panel.agreementTitleView.text = "Авторизуясь или регистрируясь, вы соглашаетесь с условиями обработки ваших персональных данных"
        let tapRecognizier = UITapGestureRecognizer(target: self, action: #selector(openAgreementView))
        panel.agreementTitleView.addGestureRecognizer(tapRecognizier)
        
        panel.errorLabel.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 10)
        
        
        let companyImageView = UIImageView(image: UIImage(named: "company_picture"))
        self.view.addSubview(companyImageView)
        companyImageView.translatesAutoresizingMaskIntoConstraints = false
        companyImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        companyImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        companyImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        companyImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 43).isActive = true
        
        
        let titleCompanyName = UILabel()
        self.view.addSubview(titleCompanyName)
        titleCompanyName.translatesAutoresizingMaskIntoConstraints = false
        titleCompanyName.numberOfLines = 0
        titleCompanyName.font = UIFont(name: AppConstants.APP_ROBOTO_BOLD, size: 32)
        titleCompanyName.textColor = AppConstants.APP_DEFAULT_TEXT_COLOR
        titleCompanyName.text = "HappyChild\nGeneration"
        
        titleCompanyName.widthAnchor.constraint(equalToConstant: 187).isActive = true
        titleCompanyName.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 41).isActive = true
        titleCompanyName.bottomAnchor.constraint(equalTo: self.panel.topAnchor, constant: -55).isActive = true
    }
    
    
    @objc private func openAgreementView(){
        self.interactor?.openAgreement()
    }
    
    private func configuareToolbarButtons(){
           
       self.view.addSubview(self.closeButton)
       
       self.closeButton.translatesAutoresizingMaskIntoConstraints = false
       self.closeButton.bottomAnchor.constraint(equalTo: self.customPicker.topAnchor, constant: 0).isActive = true
       self.closeButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
       self.closeButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
       self.closeButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
       self.closeButton.isHidden = true
       self.closeButton.Action = {(_) in
           self.closePicker()
       }
       
       self.view.addSubview(self.updateButton)
       self.updateButton.translatesAutoresizingMaskIntoConstraints = false
       self.updateButton.bottomAnchor.constraint(equalTo: self.customPicker.topAnchor, constant: 0).isActive = true
       self.updateButton.leftAnchor.constraint(equalTo: self.closeButton.rightAnchor, constant: 0).isActive = true
       self.updateButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
       self.updateButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
       self.updateButton.isHidden = true
       self.updateButton.Action = {(_) in
           self.updateData()
       }
    }
    
    private func configuareDataPicker(){
        
        self.view.addSubview(self.customPicker)
        self.customPicker.translatesAutoresizingMaskIntoConstraints = false
        
        self.customPicker.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.customPicker.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.customPicker.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.customPicker.heightAnchor.constraint(equalToConstant: 200).isActive = true
        self.customPicker.backgroundColor = UIColor.init(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        self.customPicker.tintColor = .white
        self.customPicker.dataSource = self
        self.customPicker.delegate = self
        self.customPicker.isHidden = true
        
    }
    
   
    private func showPicker(){
       self.customPicker.isHidden = false
       self.closeButton.isHidden = false
       self.updateButton.isHidden = false
    }
    
    private func updateData(){
        self.closePicker()
        guard let country = self.currentCountry else { return }
        self.interactor?.changeCountry(country)
        self.panel.button.title = "+\(country.Code)"
    }
    
    private func closePicker(){
        self.customPicker.isHidden = true
        self.closeButton.isHidden = true
        self.updateButton.isHidden = true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    

    private let kPickerViewHeight: CGFloat = 240.0
    
    
    func showPicker(_ pickerView: UIPickerView) {
        let customView:UIView = UIView (frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: kPickerViewHeight))
        customView.backgroundColor = UIColor.white
        customView.addSubview(pickerView)
        
        self.textField.inputView = customView
        self.textField.becomeFirstResponder()
    }
    
    
    @objc func showCountriesPhonesPanel() {
        
        let countryPicker = CommonPickerDialogView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: kPickerViewHeight), arrays: (self.interactor?.listCountryCodes)!)
        
        if let current = self.interactor?.currentCountryCode {
            countryPicker.currentElement = current
        }
        
        countryPicker.onSelected = {(element) in
            if let country = element as? CountryCodeModel {
                self.currentCountry = country
                self.interactor?.changeCountry(country)
                self.panel.button.title = "+\(country.Code)"
            }
        }
        
        showPicker(countryPicker)
    }
    
    
    //MARK: - data picker functions
    
    @objc func changedPhoneField(textField: UITextField) {
       let text = textField.text!
       self.interactor?.changePhoneFeild(string: text)
    }


    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return self.dataCountryList.count
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       let index = row
       self.currentCountry = self.dataCountryList[index]
    }

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
      
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
       
       let label = UILabel()
       label.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 25)
       label.textColor = .black
       label.textAlignment = .center
       
       if self.dataCountryList.count > 0 {
           label.text = "\(self.dataCountryList[row].Title) +\(self.dataCountryList[row].Code)"
       }
       return label
    }
      
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
       return 70
    }
    
    
    //MARK: - TextField functions
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }

    @objc func handleKeyboardNotification( notification: NSNotification){
       
       var pointY:CGFloat = 0.0
       
       if notification.name == UIResponder.keyboardWillShowNotification, let userInfo = notification.userInfo {
            let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            pointY = -frame.height
       }
       else if notification.name == UIResponder.keyboardWillHideNotification {
           pointY = 0
       }
       
       UIView.animate(withDuration: 0.2, animations: {
           self.view.frame.origin.y = pointY
       })
    }

    func registerForKeyboardNotifications(){
//       NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
//       NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unregisterForKeyboardNotifications(){
//       NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//       NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }


    deinit {
       self.unregisterForKeyboardNotifications()
    }
   
}
