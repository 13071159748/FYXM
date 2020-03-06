//
//  UIImage+Extension.swift
//  CQSC
//
//  Created by moqing on 2019/12/18.
//  Copyright © 2019 _CHK_. All rights reserved.
//
import CoreImage

extension UIImage {

    func grayImage(image: UIImage) -> UIImage {
        //        获得原图像的尺寸属性
        let imageSize = image.size
        //        获得宽度和高度数值
        let width = Int(imageSize.width)
        let height = Int(imageSize.height)

        //        创建灰度色彩空间对象，各种设备对待颜色的方式都不一样，颜色必须有一个相关的色彩空间
        let spaceRef = CGColorSpaceCreateDeviceGray()
        //        参数data指向渲染的绘制内存的地址，bitsOerComponent表示内存中像素的每个组件的位数,bytesPerRow表示每一行在内存中占的比特数，space表示使用的颜色空间，bitmapInfo表示是否包含alpha通道
        let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0, space: spaceRef, bitmapInfo: CGBitmapInfo().rawValue)!
        //        然后创建一个和原视图同样尺寸的空间
        let rect = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)

        //        在灰度上下文中画入图片
        context.draw(image.cgImage!, in: rect)
        //        从上下文中获取并生成专为灰度的图片
        let grayImage = UIImage(cgImage: context.makeImage()!)

        return grayImage

    }

    func getGrayImage() -> UIImage {
        let ciImage = CIImage(image: self)
        if let filter = CIFilter(name: "CIPhotoEffectMono") {
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            if let outputImage = filter.outputImage, let cgImage = CIContext().createCGImage(outputImage, from: outputImage.extent) {
                let image = UIImage(cgImage: cgImage)
                return image
            }
        }

        return grayImage(image: self)
    }
}
