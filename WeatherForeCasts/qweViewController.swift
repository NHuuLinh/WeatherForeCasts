//
//  qweViewController.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 31/10/2023.
//

let names = ["linh","lam","nam","tram"]
func onweard(_ s1:String,_ s2:String) -> Bool {
    return s1 > s2
}
var reverName = names.sorted(by: onweard(_:_:))
