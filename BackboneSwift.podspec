Pod::Spec.new do |s|
s.name         = 'BackboneSwift'
s.version      = '2.0.0'
s.summary      = 'BackboneSwift'
s.requires_arc = true
s.platform = :ios, :tvos  
s.tvos.deployment_target = '9.0'
s.ios.deployment_target = '9.0'
s.license = { :type => 'MIT', :text => '@see README' }
s.author = {
'Fernando Canon' => 'canon.fernando@icloud.com'
}
s.homepage  = 'https://github.com/supersabbath/BackboneSwift3.0'
s.source = {
	:git => "https://github.com/supersabbath/BackboneSwift3.0.git" , :tag => s.version
}
s.source_files = 'BackboneSwift/src/**/*.swift'
s.frameworks = 'UIKit'
s.dependency 'SwiftyJSON'
s.dependency 'Alamofire'
s.dependency 'PromiseKit/CorePromise'
 
end
