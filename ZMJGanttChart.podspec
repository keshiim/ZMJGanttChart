#
# Be sure to run `pod lib lint ZMJGanttChart.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZMJGanttChart'
  s.version          = '0.1.2'
  s.summary          = 'Full configurable sheet view user interfaces for iOS applications. eg:GanttChart, Schedul, TimeAble etc.'
  s.description      = <<-DESC
Full configurable sheet view user interfaces for iOS applications. With this framework,
you can easily create complex layouts like schedule, gantt chart or timetable as if you are using Excel.

Features
- Fixed column and row headers
- Merge cells
- Circular infinite scrolling automatically
- Customize grids and borders for each cell
- Customize inter cell spacing vertically and horizontally
- Fast scrolling, memory efficient
- `UICollectionView` like API
                       DESC

  s.homepage         = 'https://github.com/keshiim/ZMJGanttChart'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'keshiim' => 'keshiim@163.com' }
  s.source           = { :git => 'https://github.com/keshiim/ZMJGanttChart.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ZMJGanttChart/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ZMJGanttChart' => ['ZMJGanttChart/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
