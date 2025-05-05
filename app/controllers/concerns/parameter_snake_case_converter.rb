module ParameterSnakeCaseConverter
  extend ActiveSupport::Concern

  included do
    before_action :convert_params_to_snake_case!
  end

  private

  # transform other case keys to snake case
  def convert_params_to_snake_case!
    request.parameters.deep_transform_keys! do |key|
      key.to_s.underscore.to_sym
    end
  end
end
