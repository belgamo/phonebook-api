module ApiException
  EXCEPTIONS = {
    #400
    "ActiveRecord::RecordInvalid" => { status: 400 },
    "BadRequest" => { status: 400 },
    "ActionDispatch::Http::Parameters::ParseError" => { status: 400 },

    #401
    "Unauthorized" => { status: 401 },

    #403
    "Forbidden" => { status: 403 },

    #404
    "ActiveRecord::RecordNotFound" => { status: 404 },
    "NotFound" => { status: 404 }
  }

  class BaseError < StandardError
    attr_reader :status_code, :error_code
  end

  module Handler
    def self.included(klass)
      klass.class_eval do
        EXCEPTIONS.each do |exception_name, context|
          unless ApiException.const_defined?(exception_name)
            ApiException.const_set(exception_name, Class.new(BaseError))
            exception_name = "ApiException::#{exception_name}"
          end

          rescue_from exception_name do |exception|
            render status: context[:status], json: { error_code: context[:error_code], message: (exception.message) }.compact
          end
        end
      end
    end
  end
end
