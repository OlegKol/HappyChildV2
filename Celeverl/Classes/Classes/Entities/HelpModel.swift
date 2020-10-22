import Foundation

public class HelpModel: BaseModel {
    
    public var Phone: String? = nil
    public var HelpPage: String? = nil
    
    override public init() {
        super.init()
    }
    
    convenience init(_ dic:[String:Any]){
        self.init()
        self.Phone = dic["Phone"] as? String ?? nil
        self.HelpPage = dic["HelpPage"] as? String ?? nil
    }
}
