class ToubansController < ApplicationController
  menu_item :touban

  before_filter :find_project_by_project_id
  before_filter :authorize
  before_filter :find_touban, :only => [:show, :edit, :destroy, :prev, :next]

  # 一覧
  def index
    @toubans = Touban.find_all_by_project_id(@project.id)
  end

  # 詳細
  def show
  end

  # 新規
  def new
    @touban = Touban.new
    @touban.project = @project

    if request.post? && params[:touban]
      params[:touban][:tasks] = params[:touban][:tasks].split(/\r?\n/) if params[:touban][:tasks]
      @touban.safe_attributes = params[:touban]
      if @touban.save
        redirect_to  :controller => 'toubans', :action => 'index', :project_id => @project
#        redirect_to :controller => 'toubans', :action => 'show', :id => @touban.id, :project_id => @project
      end
    end
  end

  # 編集
  def edit
    if request.post? && params[:touban]
      params[:touban][:tasks] = params[:touban][:tasks].split(/\r?\n/) if params[:touban][:tasks]
      @touban.safe_attributes = params[:touban]
      if @touban.save
        redirect_to  :controller => 'toubans', :action => 'index', :project_id => @project
#        redirect_to :controller => 'toubans', :action => 'show', :id => @touban.id, :project_id => @project
      end
    end
  end

  # 削除
  def destroy
    @touban.destroy
    redirect_to  :controller => 'toubans', :action => 'index', :project_id => @project
  end

  # 当番を1つ前に戻す
  def prev
    @touban.prev_touban!
    redirect_to  :controller => 'toubans', :action => 'index', :project_id => @project
  end

  # 当番を次に進める
  def next
    @touban.next_touban!
    redirect_to  :controller => 'toubans', :action => 'index', :project_id => @project
  end

  private
  # 当番情報を取得
  def find_touban
    render_404 unless params[:id]
    @touban = Touban.find_by_id(params[:id])
    render_404 unless @touban
  end
end
