Pod::Spec.new do |s|
  # 项目的名称，注意要和项目名一致，而不是和Github仓库名一致！
  s.name             = “YECycleScrollView”
  # 项目的版本号，要保持和git上的版本号一致哦
  s.version          = "0.0.1"
  # 项目的摘要信息
  s.summary          = "一个头图轮播图。”
  # 项目的介绍
  s.description      = <<-DESC
                       一个iOS平台iOS始终保持一样的UI用户体验！
                       DESC
  # 项目的主页
  s.homepage         = "https://github.com/muyang00/YECycleScrollView"
  # 所遵守的协议，比如MIT或Apache等
  s.license          = ‘MIT’
  # 作者信息哦
  s.author           = { “yangyongen” => “280798744@qq.com” }
  # 项目托管地址，因为我的项目在github上，所以下面这么写
  s.source           = { :git => "https://github.com/muyang00/YECycleScrollView.git", :tag => s.version.to_s }
  # 最低支持的iOS版本
  s.platform     = :ios, '8.0'
  # 是否使用ARC了
  s.requires_arc = true
  # 源代码目录，以podspec文件为相对根目录进行填写！
  s.source_files = 'YECycleScrollView/YECycleScrollView/*'
  # 需要引入的框架
  s.frameworks = 'Foundation', 'CoreData', 'UIKit'

end