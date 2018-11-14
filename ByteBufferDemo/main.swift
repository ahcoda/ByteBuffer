//
//  main.swift
//  ByteBufferDemo
//
//  Created by ruglcc on 2018/11/14.
//  Copyright © 2018 ruglcc. All rights reserved.
//

import Foundation

var bytes = [UInt8]()

let bf = ByteBuffer.init()
bf.put(111.0 as Float)
bf.put(1111.0 as Double)

print(bf.description)

let f: Float? = bf.get()
let d: Double? =  bf.get()

print("\(String(describing: f)), \(String(describing: d))")
