//
//  Services.swift
//  SlideMail
//
//  Created by Asim on 10/03/2021.
//

import Foundation
import Alamofire
import SwiftUI
import Combine

protocol serverResponse {
    func onSuccess(json:JSON, val:String)
    func onFailure(message: String)
}


protocol serverResponseData {
    func onSuccess(data:Data, val:String)
    func onFailure(message: String)
    
}

//@available(iOS 13.0, *)
class MVP : BaseViewConroller {
    
    private var task: Cancellable? = nil
    
    var delegate:serverResponse!
    var dataDelegate : serverResponseData!
    
    let headers: HTTPHeaders = [
        "Accept": "application/json"
    ]
    
    // MARK: Request with body and header
    func requestWithHeaderandBody(vc:UIViewController , url:String , params:[String:Any] , method:HTTPMethod , type:String , loading:Bool){
        
        
        if CheckInternet.Connection(){
            if loading{
                
            }
            AF.request(API.baseURL + url , method: method, parameters: params , encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                
                switch response.result{
                
                case .success(let value):
                    let json = JSON(value)
                    
                    // if API hits with no error i.e status 200
                    if json["status"] == 200{
                        
                        if let del = self.delegate{
                            del.onSuccess(json: json["user"], val: type)
                        }
                    }
                    // If any error occurs
                    else if json["status"] == 400 {
                       
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.showAlert(message: "", title: json["message"].stringValue, action: .none, secondAction: .none, sender: vc)
                        }
                        
                    }
                case .failure:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.showAlert(message: "Service Failure", sender: vc)
                    }
                    break
                    
                }
            }
        }else{
            self.showAlert(message: "No Internet Connection", sender: vc)
            
           
        }
    }
    
    
    
    
    // MARK: Request GET API
    func requestGETAPI(url : String, method: HTTPMethod, type: String, loading: Bool) {
        
        
        if CheckInternet.Connection() {
           
            
            AF.request(API.baseURL + url, headers: headers).responseJSON { (response) in
                
                switch response.result{
                
                case .success(let value):
                    let json = JSON(value)
                    
                    if json["status"] == 200{
                        if let del = self.delegate{
                            del.onSuccess(json: json["user"], val: type)
                        }
                    }
                case .failure:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                        self.showAlert(message: "Service Failure", sender: vc)
                        
                    }
                    break
                }
                
            }
        }
        else {
            
        }
    }
    
    
    // MARK: Request with body and header
    func requestWithHeaderandBodyWithoutBaseURL(vc:UIViewController , url:String , params:[String:Any] , method:HTTPMethod , type:String , loading:Bool){
        
        //        let loaderVC : LoaderVC = UIStoryboard.controller()
        
        if CheckInternet.Connection(){
            if loading{
  
            }
            AF.request(url , method: method, parameters: params , encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                
                switch response.result{
                
                case .success(let value):
                    let json = JSON(value)
                    
                    
                    // if API hits with no error i.e status 200
                    if json["status"] == 200{
                        //                        loaderVC.dismiss(animated: false, completion: nil)
                        if let del = self.delegate{
                            del.onSuccess(json: json, val: type)
                        }
                    }
                    // If any error occurs
                    else if json["status"] == 400{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.showAlert(message: json["message"].stringValue, sender: vc)
                        }
                        
                    }
                    
                    
                    
                case .failure:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.showAlert(message: "Service Failure", sender: vc)
                    }
                    break
                    
                }
            }
        } else {
            self.showAlert(message: "No Internet Connection" , sender: vc)
            
            
        }
    }
    
    
    
    
    
    
    // MARK: requestAndReturnData
    func requestAndReturnData(
        url:String ,
        params:[String:Any] ,
        method:HTTPMethod,
        type:String
    ) {
        
        if CheckInternet.Connection() {
            
            
            self.task = AF.request(API.baseURL + url,
                                   method: method,
                                   parameters: params,
                                   encoding: URLEncoding.default,  // JSONEncoding for query Paramters
                                   headers: headers)
                .publishDecodable(type: JSON.self)
                .sink(receiveCompletion: {(completion) in
                    switch completion {
                    case .finished:
                        ()
                    case .failure(let error):
                        
                        print(error.localizedDescription)
                        
                    }
                    
                }, receiveValue: {(response) in
                    switch response.result {
                    
                    case .success(let value):
                        let json = JSON(value)
                        
                        print(json.stringValue)
                        if json["status"] == 200 {
                            DispatchQueue.main.async {
                                if let del = self.dataDelegate {
                                    del.onSuccess(data: response.data!, val: type)
                                }
                            }

                        } else  {
                            DispatchQueue.main.async {
                                if let del = self.dataDelegate {
                                    del.onFailure(message: "\(json["message"])")
                                    
                                }
                            }
                        }
                    case .failure(let error):
                        
                        DispatchQueue.main.async {
                            if let del = self.dataDelegate{
                                del.onFailure(message: "Service Failure : \(error.localizedDescription)")
                                
                            }
                        }
                        
                        break
                        
                    }
                })
            
        } else {
            
            DispatchQueue.main.async {
                if let del = self.dataDelegate{
                    del.onFailure(message: "Please check your internet connectivity.")
                    
                }
            }
            
            print("No Internet")
        }
    }
    
    
    
    
    //GET WITH DATA
    func requestGETWithData(url : String, type: String) {
        
        
        if CheckInternet.Connection() {
           
            
            AF.request(API.baseURL + url, headers: headers).responseJSON { (response) in
                
                switch response.result{
                
                case .success(let value):
                    let json = JSON(value)
                    
                    if json["data"] != "" {
                        
                        DispatchQueue.main.async {
                            if let del = self.dataDelegate {
                                del.onSuccess(data: response.data!, val: type)
                            }
                        }
                        
                        

                    }
                    else  {
                        DispatchQueue.main.async {
                            if let del = self.dataDelegate{
                                del.onFailure(message: "\(json["message"])")
                                
                            }
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        if let del = self.dataDelegate{
                            del.onFailure(message: "Service Failure : \(error.localizedDescription)")
                            
                        }
                    }
                    break
                }
                
            }
        }
        else {
            DispatchQueue.main.async {
                if let del = self.dataDelegate{
                    del.onFailure(message: "Please check your internet connectivity.")
                    
                }
            }
        }
    }
    
    
    // MARK: requestGETWithDataQueryParam

    func requestGETWithDataQueryParam(url : String, type: String , params: [String:Any]) {
        
//        var baseURL = "http://epl.umistone.com/"
        
        if CheckInternet.Connection() {
           
            
            AF.request(API.baseURL + url, parameters: params, headers: headers).responseJSON { (response) in
                
                switch response.result{
                
                case .success(let value):
                    let json = JSON(value)
                    
                    if json["status"] == 200 {
                        if json["data"] != "" {
                            
                            DispatchQueue.main.async {
                                if let del = self.dataDelegate{
                                    del.onSuccess(data: response.data!, val: type)
                                }
                            }
                            
                            

                        } else  {
                            DispatchQueue.main.async {
                                if let del = self.dataDelegate{
                                    del.onFailure(message: "\(json["message"])")
                                    
                                }
                            }
                        }
                    } else  {
                        DispatchQueue.main.async {
                            if let del = self.dataDelegate{
                                del.onFailure(message: "\(json["message"])")
                                
                            }
                        }
                    }
                   
                case .failure(let error):
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        if let del = self.dataDelegate{
                            del.onFailure(message: "Service Failure : \(error.localizedDescription)")
                            
                        }
                    }
                    break
                }
                
            }
        }
        else {
            DispatchQueue.main.async {
                if let del = self.dataDelegate{
                    del.onFailure(message: "Please check your internet connectivity.")
                    
                }
            }
        }
    }
    
    
    // MARK: MULTIPART FORM UPlOAD
    func apiRequestWithMultiparts (
                                  url:String ,
                                  params:[String:Any] ,
                                  method:HTTPMethod ,
                                  type : String
                                  ) {
        
        if CheckInternet.Connection(){
           
            
            AF.upload(multipartFormData: { (multipartdata) in
                // add any additional parameters first
                //multipartdata.append(<data>, withName: <Param Name>)
                for (key, value) in params {
                    
                    switch value{
                    
                    case let someValue as String:
                        multipartdata.append(someValue.data(using: .utf8)!, withName: key)
                    case let images as [UIImage]:
                        for (index, image) in images.enumerated(){
                            let imageData = image.jpegData(compressionQuality: 0.7)!
                            print(imageData)
                            multipartdata.append(imageData,withName: key, fileName: "image" + "\(index)" + ".png",mimeType: "image/png")
                        }
                        
                    case let arrayValue as NSArray:
                        arrayValue.forEach({ element in
                            let keyObj = key + "[]"
                            print(keyObj)
                            switch element{
                            case let someString as String:
                                multipartdata.append(someString.data(using: .utf8)!, withName: keyObj)
                            case let image as UIImage:
                                let imageData = image.jpegData(compressionQuality: 0.7)!
                                
                                multipartdata.append(imageData,withName: keyObj, fileName: "circle.png",mimeType: "image/png")
                                break
                                
                            default:
                                break
                            }
                        })
                    default:
                        break
                    }
                }
            }, to: API.baseURL + url, method: method,headers: headers).responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    
                    //  SVProgressHUD.dismiss()
                    let json = JSON(value)
                    print(json)
                    let message = json["message"].stringValue
                    // SVProgressHUD.dismiss()
                    print(message)
                    if json["status"] == 200 {
                        if let del = self.delegate{
                            del.onSuccess(json: json["data"], val: type)
                        }
                    } else {
                        DispatchQueue.main.async {
                            if let del = self.dataDelegate{
                                del.onFailure(message: "\(json["message"])")
                                
                            }
                        }
                    }
                 
                    
                    
                    
                    
                case .failure(let err):
                    print(err.localizedDescription)
                    
                    DispatchQueue.main.async {
                        if let del = self.dataDelegate{
                            del.onFailure(message: err.localizedDescription)
                            
                        }
                    }
                    // AlertHelper.showErrorAlert(WithTitle: "Error!", Message: "Someting Wrong", Sender: self)
                    break
                }
            }
        } else {
            DispatchQueue.main.async {
                if let del = self.dataDelegate{
                    del.onFailure(message: "Please check your internet connectivity.")
                    
                }
            }
            
            
            print("No Internet")
        }
    }
    
    
    // MARK: apiRequestWithBase64Images

    func apiRequestWithBase64Images(
                                    url: String ,
                                    params: [String:Any] ,
                                    method: HTTPMethod ,
                                    type : String
                                    ){
        
        if CheckInternet.Connection() {
            
            
            self.task = AF.request(API.baseURL + url,
                                   method: method,
                                   parameters: params,
                                   encoding: URLEncoding.default,
                                   headers: headers)
                .publishDecodable(type: JSON.self)
                .sink(receiveCompletion: {(completion) in
                    switch completion {
                    case .finished:
                        ()
                    case .failure(let error):
                        print(error.localizedDescription)
                        
                    }
                    
                }, receiveValue: {(response) in
                    switch response.result {
                    
                    case .success(let value):
                        let json = JSON(value)
                        
                        let status = json["status"]
                        let message = json["message"].stringValue
                        
                        print(message)
                        
                        
                        if status == 400 {
                            DispatchQueue.main.async {
                                if let del = self.dataDelegate {
                                    del.onFailure(message: "\(json["message"])")
                                    
                                }
                            }
                            return
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            
                            if let del = self.dataDelegate{
                                del.onSuccess(data: response.data!, val: type)
                            }
                        }
                        // if API hits with no error i.e status 200
                        

                    case .failure(let error):
                        
                       
                        
                        DispatchQueue.main.async {
                            if let del = self.dataDelegate {
                                del.onFailure(message: "Service Failure : \(error.localizedDescription)")
                                
                            }
                        }
                        break
                        
                    }
                })
            
            
        } else {
            DispatchQueue.main.async {
                if let del = self.dataDelegate{
                    del.onFailure(message: "Please check your internet connectivity.")
                    
                }
            }
        }
    }
}
