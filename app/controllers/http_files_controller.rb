#encoding:utf-8
class HttpFilesController < ApplicationController
  include ActionView::Helpers::NumberHelper

  def show
    @file = HttpFile.find(params[:id])
    if @file.percent >= 100
      send_file Rails.root.join("tmp", "download", @file.id.to_s), :filename => @file.filename
    else
      render :text => "Download not complete!"
    end
  end

  def create
    url = params[:url]
    pcode = params[:pcode]
    @file = HttpFile.create(:url=>url)
    session[:downloading] = @file.id
    Thread.new do
      HttpDownload.download(@file.url, @file.id, pcode) do |curr, total|
        if HttpFile.exists?(@file.id)
          @file.update_percent(curr, total)
        else
          break
        end
      end
      #如果管理台删除了，则删除文件
      File.delete(Rails.root.join("tmp", "download", @file.id.to_s)) unless HttpFile.exists?(@file.id)
    end
    render :json => @file.id
  end

  def percent
    @file = HttpFile.find(params[:id])
    #下载完成时，记录到cookie中，并将session中的标志位去掉
    if @file.percent >= 100
      session[:downloading] = nil
      if cookies[:history]
        arr = cookies[:history].split("&")
        arr << @file.id
      else
        arr = [@file.id]
      end
      cookies.permanent[:history] = arr
    end
    render :json => @file.percent
  end

  #获取url指定文件大小的action
  def size
    url = params[:url]
    pcode = params[:pcode]
    @size, @error = HttpDownload.get_url_size(url, pcode)
    unless @error
      path = URI.parse(url).path
      filename = path[path.rindex("/") + 1..-1]
    end
    render :json=>{:size=>number_to_human_size(@size), :filename=>filename, :error=>@error}
  end

end
