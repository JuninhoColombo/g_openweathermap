require 'net/http'
require 'json'

class OpenWeatherMap

  def self.get_current_temperature(city_id, api_key)
  	valid = OpenWeatherMap.valid_request(city_id, api_key)
  	if valid != nil
    	return valid		
  	end

 		result = Net::HTTP.get_response(URI("https://api.openweathermap.org/data/2.5/weather?id=#{city_id}&units=metric&lang=pt_br&appid=#{api_key}"))
   	return OpenWeatherMap.valid_response(result)
  end

  def self.get_forecast_temperature(city_id, api_key)
  	valid = OpenWeatherMap.valid_request(city_id, api_key)
  	if valid != nil
    	return valid		
  	end

 		result = Net::HTTP.get_response(URI("https://api.openweathermap.org/data/2.5/forecast?id=#{city_id}&units=metric&lang=pt_br&appid=#{api_key}"))
   	return OpenWeatherMap.valid_response(result)
  end

  private

  def self.valid_request(city_id, api_key)
  	# raise ArgumentError, 'City_ID obrigatório' if City_ID.nil? || City_ID.strip.empty?
    return { "ok" => false, "code" => "400", "error_message" => 'O parametro city_id é obrigatório' } if city_id.nil? || city_id.strip.empty?
    # raise ArgumentError, 'API_KEY obrigatório' if API_KEY.nil? || API_KEY.strip.empty?
    return { "ok" => false, "code" => "400", "error_message" => 'O parametro API_KEY é obrigatório' } if api_key.nil? || api_key.strip.empty?
 	end 	

  def self.valid_response(result)
  	code = result.code

  	message = nil
    case result
    when Net::HTTPOK then
      message = JSON.parse(result.body)
    when Net::HTTPUnauthorized then
      message = 'API_KEY inválido'
    when Net::HTTPForbidden then
      message = 'Sem permissão para essa operação'
    when Net::HTTPNotFound then
      message = 'City_ID não encontrado'
    when Net::HTTPTooManyRequests then
      message = 'Limite de requisições atingido'
    when Net::HTTPInternalServerError then
      message = 'Erro inesperado no servidor'
    when Net::HTTPBadGateway then
      message = 'Resposta do gateway inválida'
    when Net::HTTPServiceUnavailable then
      message = 'Serviço indisponível no momento'
    when Net::HTTPGatewayTimeout then
      message = 'Gateway indisponível no momento'
    end

    return { "ok" => code == '200', "code" => code, "error_message" => code != '200' ? message : nil, "body" => code == '200' ? message : nil }
  end	
end
