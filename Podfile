# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'caloriedonate' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for caloriedonate
  pod 'Charts'
  pod 'Alamofire', '~> 4.5'
  pod 'SwiftyJSON'
  pod 'Alamofire-SwiftyJSON', :git => "https://github.com/SwiftyJSON/Alamofire-SwiftyJSON.git"
 pod 'AWSAutoScaling'
    pod 'AWSCloudWatch'
    pod 'AWSCognito'
    pod 'AWSCognitoIdentityProvider'
    pod 'AWSDynamoDB'
    pod 'AWSEC2'
    pod 'AWSElasticLoadBalancing'
    pod 'AWSIoT'
    pod 'AWSKinesis'
    pod 'AWSLambda'
    pod 'AWSLex'
    pod 'AWSMachineLearning'
    pod 'AWSMobileAnalytics'
    pod 'AWSPinpoint'
    pod 'AWSPolly'
    pod 'AWSRekognition'
    pod 'AWSS3'
    pod 'AWSSES'
    pod 'AWSSimpleDB'
    pod 'AWSSNS'
    pod 'AWSSQS'

  target 'caloriedonateTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'caloriedonateUITests' do
    inherit! :search_paths
    # Pods for testing
  end

  post_install do |installer|
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			config.build_settings['SWIFT_VERSION'] = '3.0'
		end
	end
 end

end
