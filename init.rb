Redmine::Plugin.register :redmine_touban do
  name 'Redmine Touban plugin'
  author 'OZAWA Yasuhiro'
  description 'Manage member\'s tasks.'
  version '0.0.1'
  url 'https://github.com/ameya86/redmine_touban'
  author_url 'https://github.com/ameya86'

  # プロジェクトのモジュール
  project_module :touban do
    permission :view_touban, :toubans => [:index, :show]
    permission :edit_touban, :toubans => [:new, :edit, :destroy, :prev, :next]
  end

  # プロジェクトのメニュー
  menu :project_menu, :touban, {:controller => 'toubans', :action => 'index'}, :param => :project_id
end
