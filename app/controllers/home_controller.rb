class HomeController < ApplicationController
  def index
    get_api
    render_output(@output)
  end

  def zipcode
    @zipcode = params[:zipcode]

    if @zipcode.empty? || !@zipcode
      @zip_text = 'You forgot to enter a zipcode or your zipcode is incorrect.'
      @api_color = 'gray'
      @zipcode = false
    else
      get_api(@zipcode)
      render_output(@output)
    end
  end

  private

  def render_output(output)
    if output.empty? || !output
      @final_output = 'Error'
      @api_color = 'gray'
      @api_description = 'An error occured or your zip code is incorrect.'
      @api_reporting_area = ''
      @zipcode = false
    else
      @final_output = output[0]['AQI']
      @api_reporting_area = output[0]['ReportingArea']
      if @final_output <= 50
        @api_color = 'green'
        @api_description =
          'Air quality is satisfactory, and air pollution poses little or no risk.'
      elsif @final_output >= 51 && @final_output <= 100
        @api_color = 'yellow'
        @api_description =
          'Air quality is acceptable. However, there may be a risk for some people, particularly those who are unusually sensitive to air pollution.'
      elsif @final_output >= 101 && @final_output <= 150
        @api_color = 'orange'
        @api_description =
          'Members of sensitive groups may experience health effects. The general public is less likely to be affected.'
      elsif @final_output >= 151 && @final_output <= 200
        @api_color = 'red'
        @api_description =
          '	Some members of the general public may experience health effects; members of sensitive groups may experience more serious health effects.'
      elsif @final_output >= 201 && @final_output <= 250
        @api_color = 'purple'
        @api_description =
          'Health alert: The risk of health effects is increased for everyone.'
      elsif @final_output >= 251 && @final_output <= 500
        @api_color = 'maroon'
        @api_description =
          'Health warning of emergency conditions: everyone is more likely to be affected.'
      end
    end
  end

  def get_api(zip = 11225)
    require 'net/http'
    require 'json'

    @url =
      "https://www.airnowapi.org/aq/observation/zipCode/current/?format=application/json&zipCode=#{zip}&distance=25&API_KEY=5DC71F4B-EE07-4F43-9E3B-26E90FDB744D"
    @uri = URI(@url)
    @response = Net::HTTP.get(@uri)
    @output = JSON.parse(@response)
  end
end
