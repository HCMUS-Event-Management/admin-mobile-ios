import UIKit

class PasswordTextField: UITextField {
    
    let showPasswordButton = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        // Set the image for the show password button
        let showImage = UIImage(systemName: "eye.fill")?.resize(toWidth: 25, toHeight: 10)
        showPasswordButton.setImage(showImage, for: .normal)
        showPasswordButton.tintColor = .lightGray
        
        
        showPasswordButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)

        showPasswordButton.frame = CGRect(x: 0, y: 0, width: 25, height: 10)
        showPasswordButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        // Set the display style for the password text field
        isSecureTextEntry = true
        rightView = showPasswordButton
        rightViewMode = .always
    }
    
    @objc private func togglePasswordVisibility() {
        isSecureTextEntry = !isSecureTextEntry
        let showImage = UIImage(systemName: isSecureTextEntry ? "eye.fill" : "eye.slash.fill")?.resize(toWidth: 25, toHeight: 10)
        showPasswordButton.setImage(showImage, for: .normal)
    }
}

extension UIImage {
    func resize(toWidth width: CGFloat, toHeight height: CGFloat) -> UIImage? {
        let size = CGSize(width: width, height: height)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
