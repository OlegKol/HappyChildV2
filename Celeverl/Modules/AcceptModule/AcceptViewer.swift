import UIKit

//MARK: - AcceptViewer
class AcceptViewer: UIViewController, AcceptViewerProtocol, UITextFieldDelegate {
    
    lazy var mainTitle: UILabel = {
        var label = UILabel()
        return label
    }()
    lazy var bottomPanel: UIView = {
        var layer = UIView()
        return layer
    }()
    lazy var firstTitle: UILabel  = {
           var label = UILabel()
           return label
    }()
    lazy var secondTitle: UILabel  = {
           var label = UILabel()
           return label
    }()
    
    lazy var backView: UIImageView = {
        var image = UIImageView(image: UIImage(named: "arrow_back"))
        return image
    }()
    
    lazy var panel: AppAcceptCodePanel = {
        var panel = AppAcceptCodePanel()
        return panel
    }()
    
    override func loadView() {
        super.loadView()
        self.configuareController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerForKeyboardNotifications()
    }

    func configuareController(){
        self.createMainTitle()
        self.createFirstTitleView()
        self.createLogInPanelView()
    }
    
    func createMainTitle(){
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
        self.view.addSubview(bottomPanel)
        bottomPanel.translatesAutoresizingMaskIntoConstraints = false
        bottomPanel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -radius).isActive = true
        bottomPanel.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        bottomPanel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        bottomPanel.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        bottomPanel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
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
        titleCompanyName.bottomAnchor.constraint(equalTo: self.bottomPanel.topAnchor, constant: -55).isActive = true
    }
    
    func createFirstTitleView(){
        
        let padding: CGFloat = 43
        
        self.firstTitle.textColor = AppConstants.APP_DEFAULT_TEXT_COLOR
        self.firstTitle.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 20)
        self.firstTitle.text = "Подтверждение авторизации"
        self.firstTitle.font.withSize(20)
        
        view.addSubview(self.firstTitle)
        self.firstTitle.translatesAutoresizingMaskIntoConstraints = false
        self.firstTitle.topAnchor.constraint(equalTo:self.bottomPanel.topAnchor, constant: 32).isActive = true
        self.firstTitle.leftAnchor.constraint(equalTo:self.bottomPanel.leftAnchor, constant: padding).isActive = true
        self.firstTitle.rightAnchor.constraint(equalTo:self.bottomPanel.rightAnchor, constant: -padding).isActive = true
        
        self.secondTitle.textColor = UIColor(red: 0.567, green: 0.567, blue: 0.567, alpha: 1)
        self.secondTitle.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 12)
        self.secondTitle.text = "Введите код из СМС"
        self.secondTitle.font.withSize(12)
        
        view.addSubview(self.secondTitle)
        self.secondTitle.translatesAutoresizingMaskIntoConstraints = false
        self.secondTitle.topAnchor.constraint(equalTo:firstTitle.bottomAnchor, constant: 0).isActive = true
        self.secondTitle.leftAnchor.constraint(equalTo:self.bottomPanel.leftAnchor, constant: padding).isActive = true
        self.secondTitle.rightAnchor.constraint(equalTo:self.bottomPanel.rightAnchor, constant: -padding).isActive = true
    }
    
    func createLogInPanelView(){
        
        self.panel = AppAcceptCodePanel()
        self.view.addSubview(panel)
        
        panel.titleText = "Код из СМС:"
        panel.placeHolderText = "Код"
        panel.buttonText = "Подтвердить"
        
        panel.title.textColor = AppConstants.APP_DEFAULT_TEXT_COLOR
        panel.title.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 18)
        
        panel.field.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 14)
        panel.errorLabel.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 14)
        
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.topAnchor.constraint(equalTo: self.secondTitle.bottomAnchor, constant: self.view.frame.height * 0.05).isActive = true
        panel.leftAnchor.constraint(equalTo: self.bottomPanel.leftAnchor, constant: 43).isActive = true
        panel.rightAnchor.constraint(equalTo: self.bottomPanel.rightAnchor, constant: -43).isActive = true
        panel.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        panel.sendCodeButton.Action = self.checkCode
        panel.sendCodeButton.backgroundColor = AppConstants.APP_DEFAULT_TEXT_COLOR
        
        panel.field.addTarget(self, action: #selector(changedPhoneField), for: .editingChanged)
        panel.field.delegate = self
        
        self.view.addSubview(self.backView)
        
        self.backView.translatesAutoresizingMaskIntoConstraints = false
        self.backView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.backView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.backView.centerXAnchor.constraint(equalToSystemSpacingAfter: self.view.centerXAnchor, multiplier: 0).isActive = true
        
        self.backView.topAnchor.constraint(equalTo: self.panel.bottomAnchor, constant: 0).isActive = true
        self.backView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(backCommand))
        tap.numberOfTapsRequired = 1
        self.backView.addGestureRecognizer(tap)
    }
    
    @objc private func backCommand(){
        self.interactor?.back()
    }
    
    @objc private func changedPhoneField(textField: UITextField){
        let text = textField.text!
        self.interactor?.changeCodeField(code: text)
    }
    
    private func checkCode(button: UIButton) {
        self.interactor?.checkCode()
    }
    
    //MARK: -  AcceptViewerProtocol implementation
    
    var interactor: AcceptInteractorProtocol?
    var router: AcceptRouterProtocol?
    
    func showError(error: String) {
        DispatchQueue.main.async {
            self.panel.errorText = error
        }
    }
    
    func hideError() {
        DispatchQueue.main.async {
            self.panel.errorText = ""
        }
    }
    
    func changedBusyState(_ state: Bool) {
        DispatchQueue.main.async {
            self.panel.sendCodeButton.isBusy = state
        }
    }
    
    func showResentCodeButton() {
        
    }
    
    func hideResentCodeButton() {
        
    }
    
    func toggleBusyState(_ state: Bool) {
        
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
       NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unregisterForKeyboardNotifications(){
       NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
       NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
       self.unregisterForKeyboardNotifications()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
}
