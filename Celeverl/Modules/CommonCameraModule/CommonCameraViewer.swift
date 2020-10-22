


import Foundation
import UIKit


//MARK: - CommonCameraViewer
class CommonCameraViewer: UIViewController , CommonCameraViewerProtocol, SelectItemCollectionDelegateProtocol, UITableViewDelegate, UITableViewDataSource {
    
    
    //MARK: - SelectItemCollectionDelegateProtocol
    func selectItem(_ item: BaseModel) {
        self.interactor?.selectCamera(item)
    }
    
    //MARK: - CommonCameraViewerProtocol
    var interactor: CommonCameraInteractorProtocol?
    var documents: [DocumentModel] = []
    
    func updateCameraListView(_ list: [BaseModel]) {
        self.cameraListView.BindingContext = list
    }
    
    func updateDocument(_ documents: [DocumentModel]) {
        self.documents = documents
        DispatchQueue.main.async {
            self.documetsTableView.reloadData()
        }
    }
    
    //MARK: - Properties
    var camerasTitleView: UILabel = {
           let label = UILabel()
           label.font = UIFont(name: AppConstants.APP_ROBOTO_BOLD, size: 20)
           label.textColor = .black
           return label
    }()
    
    var cameraListView: AppCameraCollectionView = {
        var list = AppCameraCollectionView()
        list.layer.masksToBounds = true
        list.layer.cornerRadius = 10
        list.backgroundColor = .white
        return list
    }()
    
    var documentsTitleView: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: AppConstants.APP_ROBOTO_BOLD, size: 20)
        label.textColor = .black
        return label
    }()
    
    var documetsTableView: UITableView = {
        var table = UITableView()
        table.register(DocumentViewCell.self, forCellReuseIdentifier: DocumentViewCell.resueseId)
        table.separatorStyle = .none
        table.backgroundColor = .clear
        return table
    }()
    
    override func loadView(){
        super.loadView()
        self.view.backgroundColor = .lightGray
        self.configureController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.interactor?.loadDefaultData()
    }

    //MARK: - Configaure functions
    func configureController(){
        self.configuareCameraTitleView()
        self.configuareCameraList()
    }
    
    func configuareBackgroundImage(){
        let backgroundImage = UIImageView(image: UIImage(named: "detail_picture"))
        self.view.addSubview(backgroundImage)
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.contentMode = .scaleToFill
        backgroundImage.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        backgroundImage.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        backgroundImage.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    func configuareCameraList(){
        
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: self.camerasTitleView.bottomAnchor, constant: 20).isActive = true
        view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        view.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.35).isActive = true
        
        view.addSubview(self.cameraListView)
        let margin: CGFloat = 15
        self.cameraListView.translatesAutoresizingMaskIntoConstraints = false
        self.cameraListView.topAnchor.constraint(equalTo: view.topAnchor, constant: margin).isActive = true
        self.cameraListView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: margin).isActive = true
        self.cameraListView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -margin).isActive = true
        self.cameraListView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -margin).isActive = true
        cameraListView.selectDelegate = self
        
    }
    
    func configuareDocumentsTitleView(){
        
        self.view.addSubview(self.documentsTitleView)
        self.documentsTitleView.translatesAutoresizingMaskIntoConstraints = false
        self.documentsTitleView.text = "Отчеты"
        
        self.documentsTitleView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.documentsTitleView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.documentsTitleView.topAnchor.constraint(equalTo: self.cameraListView.bottomAnchor, constant: 20).isActive = true
        self.documentsTitleView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func configuareDocumentsListView(){
        self.view.addSubview(self.documetsTableView)
        self.documetsTableView.translatesAutoresizingMaskIntoConstraints = false
        self.documetsTableView.delegate = self
        self.documetsTableView.dataSource = self
        self.documetsTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant:10).isActive = true
        self.documetsTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        self.documetsTableView.topAnchor.constraint(equalTo: self.documentsTitleView.bottomAnchor, constant: 0).isActive = true
        self.documetsTableView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func configuareCameraTitleView(){
        self.view.addSubview(self.camerasTitleView)
        self.camerasTitleView.translatesAutoresizingMaskIntoConstraints = false
        self.camerasTitleView.text = "Камеры"
        
        self.camerasTitleView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.camerasTitleView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.camerasTitleView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
    }
    
    
    
    //MARK: - Table protocols implementation
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.documetsTableView.dequeueReusableCell(withIdentifier: DocumentViewCell.resueseId, for: indexPath) as? DocumentViewCell
        cell?.BindingContext = self.documents[indexPath.item]
        cell?.backgroundColor = .clear
        cell?.selectionStyle = .none
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openDocumentInBrowser(self.documents[indexPath.item])
    }
    
    private func openDocumentInBrowser(_ document: DocumentModel) {
     
        DispatchQueue.main.async {
            guard let url = document.UrlToWatch else { return }
            let page = WebViewController()
            page.url = url
            self.present(page, animated: true, completion: nil)
        }
    }
    
}

