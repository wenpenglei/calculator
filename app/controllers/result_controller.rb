class ResultController < ApplicationController
  def index
    number1 = params[:number1].blank? ? "" : params[:number1]
    number2 = params[:number2].blank? ? "" : params[:number2]
    method = params[:method]
    @result = case method
              when "+"
                number1.to_i + number2.to_i
              when "-"
                number1.to_i - number2.to_i
              when "*"
                number1.to_i * number2.to_i
              when "/"
                number1.to_i / number2.to_i
              else
                "unknow method"
              end
  end


  def edit
  end
end
