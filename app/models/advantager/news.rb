module Advantager::News
  extend ActiveSupport::Concern
  included do
  end

  module ClassMethods
    def news_types
      %w[news incidents]
    end
  end
end