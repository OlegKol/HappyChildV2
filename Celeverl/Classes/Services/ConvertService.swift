//
//  ConvertService.swift
//  Cleverl
//
//  Created by Евгений on 2/20/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation

public class ConvertService {
    
    public class func converTo<T:Decodable>(_ data: Data) throws -> T? {
        var result: T? = nil
        do{
            let decoder = JSONDecoder()
            result = try decoder.decode(T.self, from: data)
        }
        catch let error {
            throw error
        }
        return result
    }
}
