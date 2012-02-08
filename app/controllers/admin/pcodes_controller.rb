#encoding:utf-8
class Admin::PcodesController < ApplicationController
  before_filter :authenticate
  # POST /pcodes
  # POST /pcodes.xml
  def create
    @pcode = Pcode.generate
    redirect_to admin_http_files_path, :notice => "生成特权码成功！"
  end

  # DELETE /pcodes/1
  # DELETE /pcodes/1.xml
  def destroy
    @pcode = Pcode.find(params[:id])
    @pcode.destroy
    redirect_to admin_http_files_path, :notice => "删除特权码成功！"
  end
end
