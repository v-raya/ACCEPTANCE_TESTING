# frozen_string_literal: true

module Address
  def self.all_types
    [
      'Common', 'Day Care', 'Home', 'Homeless', 'Other', 'Penal Institution',
      'Permanent Mailing Address', 'Residence 2', 'Work'
    ]
  end

  def self.street_address
    FFaker::AddressUS.street_address
  end

  def self.city
    FFaker::AddressUS.city
  end

  def self.state
    FFaker::AddressUS.state
  end

  def self.zip
    FFaker::AddressUS.zip_code[0...5]
  end

  def self.type
    Address.all_types.sample
  end

  def self.full_address
    {
      street_address: street_address || Address.street_address,
      city: city || Address.city,
      state: state || Address.state,
      zip: zip || Address.zip,
      type: type || Address.type
    }
  end
end
