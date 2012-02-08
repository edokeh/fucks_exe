#encoding:utf-8
class Admin::HttpFilesController < ApplicationController
  USERS = {"geliang"=>"1985"}
  before_filter :authenticate

  def index
    @files = HttpFile.all
    @pcodes = Pcode.all
  end

  def destroy
    @file = HttpFile.find(params[:id])
    @file.destroy
    redirect_to admin_http_files_path, :notice=>"删除成功！"
  end

  #清理，将文件不存在的记录删掉
  def clean
    ids = []
    Dir.foreach(Rails.root.join("tmp", "download")) do |f|
      ids << f if f =~ /\d+/
    end
    if ids.empty?
      HttpFile.delete_all
    else
      HttpFile.delete_all(["id NOT IN (?)", ids])
    end
    redirect_to admin_http_files_path, :notice=>"清理完成！"
  end
end
