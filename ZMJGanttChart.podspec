#
# Be sure to run `pod lib lint ZMJGanttChart.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZMJGanttChart'
  s.version          = '0.1.4'
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
  #s.screenshots      = 'https://github.com/keshiim/ZMJGanttChart/blob/master/Resource/GanttChart.png', 'https://github.com/keshiim/ZMJGanttChart/blob/master/Resource/Timetable.png','https://github.com/keshiim/ZMJGanttChart/blob/master/Resource/DailySchedule_portrait.png', 'https://github.com/keshiim/ZMJGanttChart/blob/master/Resource/classData_sort.png'

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zheng mingjun' => 'keshiim@163.com' }
  s.source           = { :git => 'https://github.com/keshiim/ZMJGanttChart.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/keshiim'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ZMJGanttChart/Classes/**/*'
  s.resource_bundles = {
    'ZMJGanttChart' => ['ZMJGanttChart/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
