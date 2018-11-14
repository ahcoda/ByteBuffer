//
// Created by YangZhiyong on 16/6/16.
// Copyright (c) 2016 YangZhiyong. All rights reserved.
//
import Foundation

class ByteBuffer: CustomStringConvertible {
    
    var buffer: [UInt8]
    var position = 0
    
    init() {
        buffer = [UInt8]()
    }
    
    init(size: Int) {
        buffer = Array<UInt8>(repeating: 0, count: size)
    }
    
    init(bytes: [UInt8]) {
        buffer = bytes
    }
    
    init(data: Data) {
        buffer = Array(repeating: 0, count: data.count)
        //        data.copyBytes(to: &buffer)
        data.copyBytes(to: &buffer, count: buffer.count)
    }
    
    
    func hexStringToBytes(_ string: String) -> [UInt8] {
        
        let hexTable:[Character:UInt8] =
            [
                "0":0x00, "1":0x01, "2":0x02, "3":0x03, "4":0x04,
                "5":0x05, "6":0x06, "7":0x07, "8":0x08, "9":0x09,
                "a":0x0A, "b":0x0B, "c":0x0C, "d":0x0D, "e":0x0E, "f":0x0F,
                "A":0x0A, "B":0x0B, "C":0x0C, "D":0x0D, "E":0x0E, "F":0x0F
        ]
        
        var bytes = [UInt8]()
        var byte: UInt8 = 0
        var highNibbleReady = false
        
        for ch in string {
            
            if let nibble = hexTable[ch] {
                if highNibbleReady {
                    highNibbleReady = false
                    byte |= nibble
                    bytes.append(byte)
                } else {
                    highNibbleReady = true
                    byte = nibble << 4
                }
            }
        }
        
        return bytes
        
    }
    
    
    func bytesToHexString(_ bytes: [UInt8]) -> String {
        let ascTable: [Character] =
            [
                "0", "1", "2", "3", "4", "5", "6", "7",
                "8", "9", "A", "B", "C", "D", "E", "F"
        ]
        var hexString = ""
        var count:UInt = 0
        
        for byte in bytes {
            let hi = Int(byte>>4)
            let lo = Int(byte&0x0F)
            
            count += 1
            
            hexString.append(ascTable[hi])
            hexString.append(ascTable[lo])
        }
        
        return hexString
    }
    
    
    
    
    func bytesToHexString(_ bytes: [UInt8], start: Int, length: Int) -> String {
        var newBytes = [UInt8](repeating: 0, count: length)
        newBytes[0..<length] = bytes[start..<(start+length)]
        return bytesToHexString(newBytes)
    }
    
    var description: String {
        
        
        return bytesToHexString(buffer)
    }
    
    func put(_ value: [UInt8]) {
        buffer.append(contentsOf: value)
    }
    
    func get(_ length: Int) -> [UInt8]? {
        if (buffer.count - position) < length {
            return nil
        }
        
        let value = Array(buffer[position..<(position+length)])
        position += length
        return value
    }
    
    func put(_ value: UInt8) {
        buffer.append(value)
    }
    
    
    func get() -> UInt8? {
        if (buffer.count - position) < 1 {
            return nil
        }
        
        let value = buffer[position]
        position += 1
        return value
    }
    
    
    func get() -> Character? {
        if (buffer.count - position) < 1 {
            return nil
        }
        
        let value = buffer[position]
        position += 1
        
        return Character(UnicodeScalar(value))
    }
    
    
    func put(_ value: UInt16) {
        buffer.append(UInt8((value>>0)&0xFF))
        buffer.append(UInt8((value>>8)&0xFF))
    }
    
    func put(_ value: Int16) {
        put(UInt16(bitPattern: value))
    }
    
    func get() -> UInt16? {
        
        if (buffer.count - position) < 2 {
            return nil
        }
        
        var value = UInt16(0)
        value |= UInt16(buffer[position])
        value |= UInt16(buffer[position+1])<<8
        
        position += 2
        return value
    }
    
    
    func get() -> Int16? {
        if (buffer.count - position) < 2 {
            return nil
        }
        
        var value = UInt16(0)
        value |= UInt16(buffer[position])
        value |= UInt16(buffer[position+1])<<8
        
        position += 2
        return Int16(bitPattern: value)
    }
    
    
    
    func put(_ value: UInt32) {
        buffer.append(UInt8((value>>0)&0xFF))
        buffer.append(UInt8((value>>8)&0xFF))
        buffer.append(UInt8((value>>16)&0xFF))
        buffer.append(UInt8((value>>24)&0xFF))
    }
    
    
    func put(_ value: UInt64) {
        buffer.append(UInt8((value>>0)&0xFF))
        buffer.append(UInt8((value>>8)&0xFF))
        buffer.append(UInt8((value>>16)&0xFF))
        buffer.append(UInt8((value>>24)&0xFF))
        buffer.append(UInt8((value>>32)&0xFF))
        buffer.append(UInt8((value>>40)&0xFF))
        buffer.append(UInt8((value>>48)&0xFF))
        buffer.append(UInt8((value>>56)&0xFF))
    }
    
    
    func put(_ value: Int32) {
        let u = UInt32(bitPattern: value)
        put(u)
    }
    
    func get() -> UInt32? {
        if (buffer.count - position) < 4 {
            return nil
        }
        
        var value = UInt32(0)
        value |= UInt32(buffer[position])
        value |= UInt32(buffer[position+1])<<8
        value |= UInt32(buffer[position+2])<<16
        value |= UInt32(buffer[position+3])<<24
        
        position += 4
        return value
    }
    
    
    //    func put(value: Float32) {
    //        guard var buffer = buffer else {
    //            return
    //        }
    //
    //
    //    }
    
    func get() -> Int32? {
        if (buffer.count - position) < 4 {
            return nil
        }
        
        var value = UInt32(0)
        value |= UInt32(buffer[position])
        value |= UInt32(buffer[position+1])<<8
        value |= UInt32(buffer[position+2])<<16
        value |= UInt32(buffer[position+3])<<24
        
        position += 4
        
        return Int32(bitPattern: value)
    }
    
    
    func put(_ value: Float) {
        self.put(value.bitPattern)
    }
    
    
    func put(_ value: Double) {
        put(value.bitPattern)
    }
    
    
    func get() -> Float32? {
        if (buffer.count - position) < 4 {
            return nil
        }
        
        var value = UInt32(0)
        value |= UInt32(buffer[position])
        value |= UInt32(buffer[position+1])<<8
        value |= UInt32(buffer[position+2])<<16
        value |= UInt32(buffer[position+3])<<24
        
        position += 4
        
        return Float32(bitPattern: value)
    }
    
    
    
    
    func get() -> Double? {
        if (buffer.count - position) < 8 {
            return nil
        }
        var value = UInt64(0)
        value |= UInt64(buffer[position])
        value |= UInt64(buffer[position+1])<<8
        value |= UInt64(buffer[position+2])<<16
        value |= UInt64(buffer[position+3])<<24
        value |= UInt64(buffer[position+4])<<32
        value |= UInt64(buffer[position+5])<<40
        value |= UInt64(buffer[position+6])<<48
        value |= UInt64(buffer[position+7])<<56
        
        position += 8
        
        return Double(bitPattern: value)
    }
    
}
