class HomeController < ApplicationController
  include ActionView::Helpers::NumberHelper
  
  def show
    if session[:downloading]
      @file = HttpFile.where("id=?", session[:downloading]).first
      if @file
        @json = {:id=>@file.id, :filename=>@file.filename, :size=>number_to_human_size(@file.size)}
      else
        session[:downloading]=nil
      end
    end
    @his_files = []
    if cookies[:history]
      arr = []
      cookies[:history].split("&").each do |id|
        file = HttpFile.where("id=?",id).first
        if file
          arr << file.id
          @his_files << file
        end
      end
      cookies.permanent[:history] = arr
    end
  end

end
