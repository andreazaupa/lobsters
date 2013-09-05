  class << Rails.application
    def domain
      "dlobster.herokuapp.com"
    end

    def name
      "Dlobster"
    end
  end

  Rails.application.routes.default_url_options[:host] = Rails.application.domain