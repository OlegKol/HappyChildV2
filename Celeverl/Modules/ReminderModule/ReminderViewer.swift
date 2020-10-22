import Foundation
import UIKit

public class ReminderViewer: UIViewController, UIScrollViewDelegate, ReminderViewerProtocol, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //MARK: - ReminderViewerProtocol implementation
    public var interactor: ReminderInteractorProtocol?
    
    public func updateView(_ state: Bool) {
        if state {
            self.freezePage()
        }
        else {
            self.freePage()
        }
    }
    
    public func updateSettings(_ settings: ReminderModel) {
        DispatchQueue.main.async {
            self.createSettingItem(settings)
        }
    }
    
    public func setDataForPicker(_ data: [String],_ index: Int) {
        self.dataPicker = data
        if self.selectedPropertyName != nil {
            self.showPanel(arrays: data, indexCurrentValue: index)
        }
    }
    
    
    private let kPickerViewHeight: CGFloat = 240.0
          
          
    func showPicker(_ pickerView: UIPickerView) {
        let customView:UIView = UIView (frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: kPickerViewHeight))
        customView.backgroundColor = UIColor.white
        customView.addSubview(pickerView)

        self.textField.inputView = customView
        self.textField.becomeFirstResponder()
    }

    func showPanel(arrays:[ElementToPickerDialog], indexCurrentValue: Int) {

        if self.currentPickerView == nil {
            let picker = CommonPickerDialogView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: kPickerViewHeight), arrays: arrays)
            self.currentPickerView = picker
            if (arrays[indexCurrentValue] as? ElementToPickerDialog) != nil {
                picker.selectElement(arrays[indexCurrentValue])
            }
           picker.onSelected = {(data) in
               if let element = data as? String {
                    self.temporaryIndexValue = self.dataPicker.firstIndex(of: element)
                DispatchQueue.global().async {
                        self.interactor?.selectValue(self.temporaryIndexValue)
                        DispatchQueue.main.async {
                            self.currentButton?.title = self.dataPicker[self.temporaryIndexValue as! Int]
                            self.temporaryIndexValue = 0
                        }
                    }
                }
           }
           self.showPicker(picker)
        }
        else {
            self.currentPickerView?.SetPickerElements(arrays)
            self.currentPickerView?.selectElement(arrays[indexCurrentValue])
            self.textField.becomeFirstResponder()
        }
    }
    
    //MARK: - Properties
    lazy var scrollView : UIScrollView = {
        var scroll = UIScrollView()
        scroll.isScrollEnabled = true
        scroll.showsVerticalScrollIndicator = true
        scroll.alwaysBounceVertical = true
        scroll.alwaysBounceHorizontal = false
        return scroll
    }()
    
    lazy var containerView: UIView = {
        var scroll = UIView()
        return scroll
    }()
    lazy var listSettingItems: [UIView] = []
    
    lazy var settingTitle: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: AppConstants.APP_ROBOTO_BOLD, size: 24)
        label.text = "Настройки уведомлений"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = AppConstants.APP_DEFAULT_TEXT_COLOR
        return label
    }()
    
    lazy var saveButton : AppCustomButton = {
        var button = AppCustomButton()
        button.title = "Сохранить"
        button.titleLabel?.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 16)
        button.tintColor = .white
        button.backgroundColor = AppConstants.APP_DEFAULT_DARK_BLUE_COLOR
        return button
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
    
    lazy var acitivitiIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .large
        view.color = .white
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.35)
        return view
    }()
    
    var textField: UITextField = UITextField()
    
    var currentPickerView: CommonPickerDialogView?
    
    
    //MARK: - PickerView implementation
    var selectedPropertyName: String? = nil
    var temporaryIndexValue: Any = ""
    var dataPicker: [String] = []
    
    lazy var customPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    private var currentButton: AppCustomButton? = nil
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.dataPicker.count
    }
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.dataPicker[row]
    }
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.temporaryIndexValue = row
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = UILabel()
        label.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 35)
        label.textColor = .black
        label.text = self.dataPicker[row]
        label.textAlignment = .center
        
        return label
    }
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 70
    }
    
    //MARK: - Main function override
    override public func loadView() {
        super.loadView()
        self.view.backgroundColor = .white
        self.configuareSettingView()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.interactor?.loadData()
    }
    
    //MARK: - Configuare Functions
    private func configuareSettingView(){
        self.configuareTitleView()
        self.configuareSaveButton()
        self.configuareScrollView()
        self.configuareDataPicker()
        self.configuareIndicator()
        self.configuareToolbarButtons()
        
        self.view.addSubview(self.textField)
        self.textField.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250)
        self.textField.isHidden = true
    }
    
    private func configuareScrollView(){
        
        self.view.addSubview(self.scrollView)

        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.scrollView.topAnchor.constraint(equalTo: self.settingTitle.bottomAnchor, constant: 10).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.saveButton.topAnchor, constant: -10).isActive = true
        self.scrollView.alwaysBounceVertical = true
        self.scrollView.alwaysBounceHorizontal = false
        self.scrollView.isDirectionalLockEnabled = true
        self.scrollView.showsVerticalScrollIndicator = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 1
        self.scrollView.addGestureRecognizer(tap)
        
    }
          
    @objc func doubleTapped() {
       self.view.endEditing(true)
    }
    
    private func configuareTitleView(){
        
        self.view.addSubview(self.settingTitle)
        
        self.settingTitle.translatesAutoresizingMaskIntoConstraints = false
        self.settingTitle.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.settingTitle.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.settingTitle.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 32).isActive = true
        self.settingTitle.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
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
            self.closeToolBar()
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
    
    private func showToolBar(){
        self.customPicker.selectRow(0, inComponent: 0, animated: false)
        self.customPicker.reloadAllComponents()
        self.customPicker.isHidden = false
        self.closeButton.isHidden = false
        self.updateButton.isHidden = false
    }
    
    private func updateData(){
        DispatchQueue.global().async {
            self.interactor?.selectValue(self.temporaryIndexValue)
            DispatchQueue.main.async {
                self.currentButton?.title = self.dataPicker[self.temporaryIndexValue as! Int]
                self.closeToolBar()
                self.temporaryIndexValue = 0
            }
        }
    }
    
    private func closeToolBar(){
        self.customPicker.isHidden = true
        self.closeButton.isHidden = true
        self.updateButton.isHidden = true
    }
    
    private func configuareSaveButton(){
        
        self.view.addSubview(self.saveButton)
        self.saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.saveButton.widthAnchor.constraint(equalToConstant: 174).isActive = true
        self.saveButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        self.saveButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.saveButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.saveButton.layer.cornerRadius = 5
        self.saveButton.Action = {(_) in
            self.interactor?.updateValue()
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
    
    private func configuareIndicator(){
        
        self.view.addSubview(self.acitivitiIndicator)
        
        self.acitivitiIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.acitivitiIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.acitivitiIndicator.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.acitivitiIndicator.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        self.acitivitiIndicator.topAnchor.constraint(equalTo: self.settingTitle.bottomAnchor, constant: 10).isActive = true
        self.acitivitiIndicator.bottomAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
    }
    
    
    //MARK: - Create SettingsItems function
    private func createSettingItem(_ settings: ReminderModel) {
        
        self.clearListSettingsItems()
        let properties = settings.getPropertiesList()
        
        for prop in properties {
            if let data = self.convertValueToString(prop.propertyName, prop.value) {
                self.createFiled(data.title, data.value, prop.propertyName, prop.index)
            }
            if let data = self.convertValueToCheckBox(prop.propertyName, prop.value) {
                self.createCheckBoxField(data.title, data.value , prop.propertyName)
            }
        }
        self.scrollView.updateContentSize()
    }
    
    private func clearListSettingsItems(){
        self.listSettingItems.removeAll()
        self.scrollView.subviews.map { $0.removeFromSuperview() }
    }
    
    
    private func convertValueToString(_ propertyName: String, _ value: Any) -> (title:String, value:String)? {
        
        var string: (String,String)? = nil
        if let data = value as? Int {
            if propertyName == "WarningNotificationMinutes" {
                string = ("Интервал уведомлений о тревожной ситуации", String(data) + "мин.")
            }
            else if propertyName == "WarningEventsFrequencyForInterval" {
                string = ("Частота повторений", String(data) + "%")
            }
            else if propertyName == "HappinessNotificationMinutes" {
                string = ("Интервал уведомлений о позитивной ситуации" ,String(data) + "мин.")
            }
            else if propertyName == "HappinessEventsFrequencyForInterval" {
                string = ("Частота повторений", String(data) + "%")
            }
            else if propertyName == "NormalSituationNotificationMinutes" {
                string = ("Интервал уведомлений о нормальной ситуации", String(data) + "мин.")
            }
            else if propertyName == "NormalEventsFrequencyForInterval" {
                string = ("Частота повторений", String(data) + "%")
            }
        }
        return string
    }
    
    private func convertValueToCheckBox(_ propertyName: String, _ value: Any) -> (title:String, value:Bool)? {
           
           var result: (String,Bool)? = nil
           if let data = value as? Bool {
               if propertyName == "InterpretUnknownAsNormal" {
                   result = ("Интерпретировать неизвестное событие как нормальное", data)
               }
               else if propertyName == "SendOnlinePushNotifications" {
                   result = ("Отправлять пуш-уведомления онлайн", data)
               }
           }
           return result
       }
    
    //MARK: - Function Create Setting Item
    private func createFiled(_ title:String,_ value: String, _ propName: String, _ index: Int) {
        
        let component = ViewButtomLine()
        component.heightLine = 1
        component.colorLine = UIColor.init(hex: "#CCCCCC", alpha: 1)
        self.scrollView.addSubview(component)

        component.translatesAutoresizingMaskIntoConstraints = false
        component.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor, constant: 0).isActive = true
        component.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor, constant: 0).isActive = true
        
        if self.listSettingItems.count == 0 {
           component.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 20).isActive = true
        }
        else {
            if self.listSettingItems.count % 2 == 0 {
                component.topAnchor.constraint(equalTo: self.listSettingItems[self.listSettingItems.count-1].bottomAnchor, constant: 32).isActive = true
            }
            else{
                component.topAnchor.constraint(equalTo: self.listSettingItems[self.listSettingItems.count-1].bottomAnchor, constant: 10).isActive = true
            }
        }
        self.listSettingItems.append(component)
        
        let label = UILabel()
        label.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 14)
        label.textColor = AppConstants.APP_DEFAULT_TEXT_COLOR
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = title
        
        component.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.leftAnchor.constraint(equalTo: component.leftAnchor, constant: 25).isActive = true
        label.widthAnchor.constraint(equalTo: component.widthAnchor, multiplier: 0.55).isActive = true
        label.topAnchor.constraint(equalTo: component.topAnchor, constant: 5).isActive = true
        label.bottomAnchor.constraint(equalTo: component.bottomAnchor, constant: -20).isActive = true
        
        component.addSubview(label)
        
        let button = AppCustomButton()
        button.title = value
        button.titleLabel?.font = UIFont(name: AppConstants.APP_ROBOTO_BOLD, size: 16)
        button.setTitleColor(AppConstants.APP_DEFAULT_DARK_BLUE_COLOR, for: .normal)
        button.layer.backgroundColor  = UIColor.init(red: 0.196, green: 0.255, blue: 0.498, alpha: 0.05).cgColor
        button.layer.cornerRadius = 5
        component.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 50).isActive = true
        button.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor, multiplier: 0.2).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
        button.Action = {(_) in
            self.selectedPropertyName = propName
            self.currentButton = button
            self.interactor?.getValueToProperty(propName)
        }
    }
    
    //MARK: - Function Create Setting CheckBoxItem
    private func createCheckBoxField(_ title:String, _ value: Bool, _ propName: String){
        
        let component = ViewButtomLine()
        component.heightLine = 0
        self.scrollView.addSubview(component)
        
        component.translatesAutoresizingMaskIntoConstraints = false
        component.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor, constant: 0).isActive = true
        component.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor, constant: 0).isActive = true
        if self.listSettingItems.count == 0 {
            component.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 20).isActive = true
        }
        else {
            if self.listSettingItems.count % 2 == 0 {
                component.topAnchor.constraint(equalTo: self.listSettingItems[self.listSettingItems.count-1].bottomAnchor, constant: 40).isActive = true
            }
            else{
                component.topAnchor.constraint(equalTo: self.listSettingItems[self.listSettingItems.count-1].bottomAnchor, constant: 10).isActive = true
            }
        }
        
        self.listSettingItems.append(component)
        
        let label = UILabel()
        label.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 14)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = AppConstants.APP_DEFAULT_TEXT_COLOR
        label.text = title
        
        component.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor, multiplier: 0.55).isActive = true
        label.leftAnchor.constraint(equalTo: component.leftAnchor, constant: 25).isActive = true
        label.topAnchor.constraint(equalTo: component.topAnchor, constant: 5).isActive = true
        label.bottomAnchor.constraint(equalTo: component.bottomAnchor, constant: -10).isActive = true
        
        let button = AppCustomCheckBox()
        button.strokeColor = AppConstants.APP_DEFAULT_DARK_BLUE_COLOR
        button.fillColor = UIColor.init(red: 0, green:0, blue: 0, alpha: 0.05)
        button.state = value
        component.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: component.centerXAnchor, constant: self.scrollView.frame.width * 0.325).isActive = true
        button.OnChanged = { (value) in
            self.interactor?.changedBoolValue(propName, value)
        }
    }
    
    private func freezePage(){
        DispatchQueue.main.async {
            self.saveButton.isBusy = true
            self.acitivitiIndicator.startAnimating()
        }
    }
    
    private func freePage(){
        DispatchQueue.main.async{
             self.saveButton.isBusy = false
             self.acitivitiIndicator.stopAnimating()
        }
    }
}

extension String: ElementToPickerDialog {
    public func PickerDialogElement() -> String {
        return self
    }
}
