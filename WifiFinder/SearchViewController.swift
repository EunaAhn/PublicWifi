//
//  SearchViewController.swift
//  WifiFinder
//
//  Created by Euna Ahn on 2022/08/16.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonSearch: UIButton!
    @IBOutlet weak var statePicker: UITextField!
    @IBOutlet weak var cityPicker: UITextField!
    
    var statePickerView = UIPickerView()
    var cityPickerView = UIPickerView()
    var stateValue = ""
    var cityValue = ""
    var wifiTableList:Array<Dictionary<String, Any>> = []
    var delegate : ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statePicker.inputView = statePickerView
        cityPicker.inputView = cityPickerView
        
        statePicker.placeholder = "Select State"
        cityPicker.placeholder = "Select City"
        
        statePicker.textAlignment = .center
        cityPicker.textAlignment = .center
        
        statePickerView.delegate = self
        statePickerView.dataSource = self
        cityPickerView.delegate = self
        cityPickerView.dataSource = self
        
        statePickerView.tag = 1
        cityPickerView.tag = 2


        buttonSearch.setTitle("Search", for: .normal)
    }
    
    @IBAction func actionSearch(_ sender: Any) {
        
        wifiTableList.removeAll()
        
        WifiList.shared.opendb()
        //WifiList.shared.selectValue()
        
        let stateArr = WifiList.shared.getStateList()
        let cityArr = WifiList.shared.getCityList(state: stateValue)
        wifiTableList = WifiList.shared.getWifiList(state: stateValue, city: cityValue)
        
        for str in stateArr {
            print("state | \(str)")
        }
        for str in cityArr {
            print("city | \(str)")
        }
        for arrDic in wifiTableList {
            var tmpName = ""
            var tmpAddress = ""
            var tmpLatitude: Double = 0.0
            var tmpLogitude: Double = 0.0
            
            if let tempVal = arrDic["name"] as? String {
                tmpName = tempVal
            }
            if let tempVal = arrDic["name"] as? String {
                tmpAddress = tempVal
            }
            if let tempVal = arrDic["latitude"] as? Double {
                tmpLatitude = tempVal
            }
            if let tempVal = arrDic["longitude"] as? Double {
                tmpLogitude = tempVal
            }
            print("wifi | \(tmpName) | \(tmpAddress) | \(tmpLatitude) | \(tmpLogitude)")
        }
        
        
        self.tableView.reloadData()
    }

}

extension SearchViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        WifiList.shared.opendb()
        
        switch pickerView.tag {
        case 1:
            stateValue = ""
            let stateArr = WifiList.shared.getStateList()
            return stateArr.count
        case 2:
            cityValue = ""
            let cityArr = WifiList.shared.getCityList(state: stateValue)
            return cityArr.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        WifiList.shared.opendb()
        
        
        
        
        switch pickerView.tag {
        case 1:
            let stateArr = WifiList.shared.getStateList()
            return stateArr[row]
        case 2:
            let cityArr = WifiList.shared.getCityList(state: stateValue)
            return cityArr[row]
        default:
            return "Data not found."
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        WifiList.shared.opendb()
        
        
        switch pickerView.tag {
        case 1:
            let stateArr = WifiList.shared.getStateList()
            statePicker.text = stateArr[row]
            stateValue = stateArr[row]
            statePicker.resignFirstResponder()
        case 2:
            let cityArr = WifiList.shared.getCityList(state: stateValue)
            cityPicker.text = cityArr[row]
            cityValue = cityArr[row]
            cityPicker.resignFirstResponder()
        default:
            return
        }
    }
    
    
}

extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wifiTableList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WifiListCell", for: indexPath) as! WifiTableViewCell
        //cell.textLabel?.text = "위치"
        let tmpRow = indexPath.row
        
        let tmpWifiDic = wifiTableList[tmpRow]
        
        var tmpName = ""
        var tmpAddress = ""
        //var tmpLatitude: Double = 0.0
        //var tmpLogitude: Double = 0.0
        
        if let tempVal = tmpWifiDic["name"] as? String {
            tmpName = tempVal
        }
        if let tempVal = tmpWifiDic["name"] as? String {
            tmpAddress = tempVal
        }
        //if let tempVal = tmpWifiDic["latitude"] as? Double {
        //    tmpLatitude = tempVal
        //}
        //if let tempVal = tmpWifiDic["longitude"] as? Double {
        //    tmpLogitude = tempVal
        //}
        
        cell.labelName.text = tmpName
        cell.labelAddress.text = tmpAddress
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tmpRow = indexPath.row
        let tmpWifiDic = wifiTableList[tmpRow]
        var tmpName = ""
        var tmpAddress = ""
        var tmpLatitude: Double = 0.0
        var tmpLogitude: Double = 0.0
        
        if let tempVal = tmpWifiDic["name"] as? String {
            tmpName = tempVal
        }
        if let tempVal = tmpWifiDic["name"] as? String {
            tmpAddress = tempVal
        }
        if let tempVal = tmpWifiDic["latitude"] as? Double {
            tmpLatitude = tempVal
        }
        if let tempVal = tmpWifiDic["longitude"] as? Double {
            tmpLogitude = tempVal
        }
        //print("**\(tmpName) : \(tmpAddress)")
        self.dismiss(animated: true)
        self.delegate?.setWifiSelected(name: tmpName, address: tmpAddress, latitude: tmpLatitude, longitude: tmpLogitude)
        
        
    }
    
}
