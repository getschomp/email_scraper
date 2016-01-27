require 'valid_email'

class EmailCollection

  attr_reader :all

  def initialize
    @all = []
  end

  def all=(collection)
    @all = collection
    validate_email_domains
  end

  def validate_email_domains
    @all.select! do |email|
      ValidateEmail.valid?(email)
      ValidateEmail.mx_valid?(email)
    end
  end

end
