//
//  ViewController.swift
//  example-camera-photo
//
//  Created by Garpepi Aotearoa on 03/08/21.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var cameraButton: UIButton!
  @IBOutlet weak var imageViewer: UIImageView!
  @IBOutlet weak var galleryButton: UIButton!

  @IBOutlet weak var loadedImage: UIImageView!
  
  let picker = UIImagePickerController()
  let picker2 = UIImagePickerController()
  var flag = false

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    picker.delegate = self
    picker2.delegate = self

  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if(flag){
      let loadImage = loadImageFromDiskWith(fileName: "SHOULDbeRANDOMstringIguessHEHE")
      loadedImage.image = loadImage
    }
  }

  @IBAction func cameraClicked(_ sender: Any) {
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      picker.allowsEditing = false
      picker.sourceType = UIImagePickerController.SourceType.camera
      picker.cameraCaptureMode = .photo
      picker.modalPresentationStyle = .fullScreen
      present(picker,animated: true,completion: nil)
    } else {
        noCamera()
    }
  }
  func noCamera(){
      let alertVC = UIAlertController(
          title: "No Camera",
          message: "Sorry, this device has no camera",
          preferredStyle: .alert)
      let okAction = UIAlertAction(
          title: "OK",
          style:.default,
          handler: nil)
      alertVC.addAction(okAction)
      present(
          alertVC,
          animated: true,
          completion: nil)
  }

  @IBAction func galleryClicked(_ sender: Any) {
    picker2.allowsEditing = false
    picker2.sourceType = .savedPhotosAlbum
    present(picker2, animated: true, completion: nil)
  }

  func saveImage(imageName: String, image: UIImage) {
   guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

      let fileName = imageName
      let fileURL = documentsDirectory.appendingPathComponent(fileName)
      guard let data = image.jpegData(compressionQuality: 1) else { return }

      //Checks if file exists, removes it if so.
      if FileManager.default.fileExists(atPath: fileURL.path) {
          do {
              try FileManager.default.removeItem(atPath: fileURL.path)
              print("Removed old image")
          } catch let removeError {
              print("couldn't remove file at path", removeError)
          }

      }

      do {
          try data.write(to: fileURL)
      } catch let error {
          print("error saving file with error", error)
      }

  }



  func loadImageFromDiskWith(fileName: String) -> UIImage? {

    let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

      let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
      let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

      if let dirPath = paths.first {
          let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
          let image = UIImage(contentsOfFile: imageUrl.path)
          return image

      }
      return nil
  }

}

extension ViewController: UIImagePickerControllerDelegate{
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    var  chosenImage = UIImage()
    chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage //2
    imageViewer.contentMode = .scaleAspectFit //3
    imageViewer.image = chosenImage //4
    // SAVE THE IMAGESSSSS YYYUUUHHHUUUU
    saveImage(imageName: "SHOULDbeRANDOMstringIguessHEHE", image: chosenImage)
    flag = true
    dismiss(animated:true, completion: nil) //5
  }
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
         dismiss(animated: true, completion: nil)
      }
}

extension ViewController: UINavigationControllerDelegate{

}

