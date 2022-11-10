//
//  WifiList.swift
//  WifiFinder
//
//  Created by Euna Ahn on 2022/08/16.
//

import Foundation
import SQLite3

class WifiList {
    
    static let shared = WifiList()
    
    var db: OpaquePointer?
    var list:Array = [[String:Any]]()
    
    func getDBPath() -> String {
            
            //데이터베이스 파일의 경로를 읽어오는 내용
            //urls(for:in:) 메서드는 배열 형태로 반환하기 때문에 인덱스를 사용해서 접근해야 합니다.
            //문서 디렉터리는 하나만 존재하기 때문에 first 속성을 사용하면 됩니다.
            
            let fileMgr = FileManager()
            let docPathURL = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first!
            let dbPath = docPathURL.appendingPathComponent("publicWifi.sqlite3").path
        
            //dbPath 경로에 파일이 없다면, 앱 번들의 db.sqlite를 가져와 복사
            if fileMgr.fileExists(atPath: dbPath) == false {
                
                do {
                    //번들 경로
                    guard let dbSource = Bundle.main.path(forResource: "publicWifi", ofType: "sqlite3")
                    else{
                        print("Bundle에 publicWifi.sqlite3 파일이 존재하지 않습니다.")
                        return "error"
                    }
                    
                    try  fileMgr.copyItem(atPath: dbSource, toPath: dbPath)
                } catch {
                    print("fail.. copying file...")
                }
            }
            
            print("publicWifi.sqlite3 파일 경로 : \(dbPath)")
            return dbPath
        }
    
    
    func opendb(){
        let dbFilePath = getDBPath()
        if sqlite3_open(dbFilePath, &db) == SQLITE_OK {
            print("db file found")
        }
        else {
            print("db file not found : \(dbFilePath as String)")
        }
    }
    
    // SELECT state FROM wifiList  GROUP BY state ORDER BY state
    // SELECT * FROM wifiList WHERE state =  '서울특별시' GROUP BY city ORDER BY city
    // SELECT * FROM wifiList WHERE city =  '가평군'
    
    func getStateList() -> Array<String> {
        var stateArray: Array<String> = []
        
        let SELECT_QUERY = "SELECT state FROM wifiList GROUP BY state ORDER BY state"
        var stmt:OpaquePointer?
        
        if sqlite3_prepare(db, SELECT_QUERY, -1, &stmt, nil) != SQLITE_OK{
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: v1\(errMsg)")
            return []
        }
                    
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let state = String(cString: sqlite3_column_text(stmt, 0))
            stateArray.append(state)
        }
        return stateArray
    }
    
    func getCityList(state: String) -> Array<String> {
        var cityArray: Array<String> = []
        
        let SELECT_QUERY = "SELECT * FROM wifiList WHERE state =  '\(state)' GROUP BY city ORDER BY city"
        var stmt:OpaquePointer?
        
        if sqlite3_prepare(db, SELECT_QUERY, -1, &stmt, nil) != SQLITE_OK{
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: v1\(errMsg)")
            return []
        }
                    
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let city = String(cString: sqlite3_column_text(stmt, 2))
            cityArray.append(city)
        }
        return cityArray
    }
    
    func getWifiList(state: String, city: String) -> Array<Dictionary<String, Any>>  {
        var wifiArray: Array<Dictionary<String, Any>>  = []
        
        let SELECT_QUERY = "SELECT * FROM wifiList WHERE state = '\(state)' and city = '\(city)'"
        var stmt:OpaquePointer?
        
        if sqlite3_prepare(db, SELECT_QUERY, -1, &stmt, nil) != SQLITE_OK{
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: v1\(errMsg)")
            return []
        }
                    
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let address = String(cString: sqlite3_column_text(stmt, 3))
            let wifi = String(cString: sqlite3_column_text(stmt, 4))
            let latitude = sqlite3_column_double(stmt, 5)
            let longitude = sqlite3_column_double(stmt, 6)
            
            let tempDic: Dictionary<String, Any> = ["name": wifi, "address": address, "latitude" : latitude, "longitude" : longitude]
            
            wifiArray.append(tempDic)
        }
        return wifiArray
    }
    
    func selectValue(){
            let SELECT_QUERY = "SELECT * FROM wifiList where address like '%등촌동%'"
            var stmt:OpaquePointer?
            
            
            if sqlite3_prepare(db, SELECT_QUERY, -1, &stmt, nil) != SQLITE_OK{
                let errMsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: v1\(errMsg)")
                return
            }
        
        list.removeAll()
            
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let state = String(cString: sqlite3_column_text(stmt, 1))
            
            var city = ""
            if let tempCity = sqlite3_column_text(stmt, 2) {
                city = String(cString: tempCity)
            }
            var address = ""
            if let tmpAddress = sqlite3_column_text(stmt, 3) {
                address = String(cString: tmpAddress)
            }
            let apname = String(cString: sqlite3_column_text(stmt, 4))
            
            let latitude = sqlite3_column_double(stmt,5)
            let logitude = sqlite3_column_double(stmt,6)
            
            //print("read value id : \(id) state : \(state) city : \(city) address : \(address) apname : \(apname) latitude : \(latitude) longitude : \(logitude)")
            
            let dic: [String: Any] = ["id":id, "state": state, "city":city, "address":address, "apname": apname, "latitude": latitude, "longitude": logitude]
            list.append(dic)
        }
      
        for wifi in list {
            print("-- \(wifi.debugDescription)")
        }
    }
}
