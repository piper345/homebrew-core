class Eject < Formula
  desc "Generate swift code from Interface Builder xibs"
  homepage "https://github.com/Raizlabs/Eject"
  url "https://github.com/Raizlabs/Eject/archive/0.1.12.tar.gz"
  sha256 "a4dae3d37f780d274f53ed25d9dc1a27d5245289f9b8cbaaf8be71bc9334de18"

  depends_on :xcode => :build

  def install
    xcodebuild
    bin.install "build/Release/eject.app/Contents/MacOS/eject"
    frameworks_path = "build/Release/eject.app/Contents/Frameworks"
    mv frameworks_path, frameworks
  end

  test do
    xib = File.open "view.xib", "a+" do |file|
      file.write <<-XML.undent
        <?xml version="1.0" encoding="UTF-8" standalone="no"?>
        <document type="com.apple.InterfaceBuilder3.CocoaTouch.XIB" version="3.0" toolsVersion="11134" systemVersion="15F34" targetRuntime="iOS.CocoaTouch" propertyAccessControl="none" useAutolayout="YES" useTraitCollections="YES" colorMatched="YES">
            <dependencies>
                <plugIn identifier="com.apple.InterfaceBuilder.IBCocoaTouchPlugin" version="11106"/>
                <capability name="documents saved in the Xcode 8 format" minToolsVersion="8.0"/>
            </dependencies>
            <objects>
                <placeholder placeholderIdentifier="IBFilesOwner" id="-1" userLabel="File's Owner"/>
                <placeholder placeholderIdentifier="IBFirstResponder" id="-2" customClass="UIResponder"/>
                <view contentMode="scaleToFill" id="iN0-l3-epB">
                    <rect key="frame" x="0.0" y="0.0" width="375" height="667"/>
                    <autoresizingMask key="autoresizingMask" widthSizable="YES" heightSizable="YES"/>
                    <color key="backgroundColor" red="1" green="1" blue="1" alpha="1" colorSpace="custom" customColorSpace="sRGB"/>
                </view>
            </objects>
        </document>
      XML
    end

    swift = <<-SWIFT.undent
      // Create Views
      let view = UIView()
      view.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
      view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
      view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    SWIFT

    assert_equal swift, shell_output("#{bin}/eject --file view.xib")
  end
end
