class CalculatorController < ApplicationController
  def index
    number1 = params[:number1].blank? ? "" : params[:number1]
    number2 = params[:number2].blank? ? "" : params[:number2]
    method = params[:method]
    @result = case method
              when "+"
                one.to_i + two.to_i
              when "-"
                one.to_i - two.to_i
              when "*"
                one.to_i * two.to_i
              when "/"
                one.to_i / two.to_i
              else
                "unknow method"
              end
  end
end
