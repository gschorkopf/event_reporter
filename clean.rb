module Clean
  def self.last_name(last_name)
    last_name.nil? ? "" : last_name.downcase
  end

  def self.first_name(first_name)
    first_name.nil? ? "" : first_name.downcase
  end

  def self.email(email)
    email.nil? ? "" : email.downcase
  end

  def self.zipcode(zipcode)
    zipcode.to_s.rjust(5,"0")[0..4]
  end

  def self.city(city)
    city.nil? ? "" : city.downcase
  end

  def self.state(state)
    state.nil? ? "" : state.downcase
  end

  def self.address(address)
    address.nil? ? "" : address.downcase
  end

  def self.phone_number(phone_number)
    no_symbols = phone_number.gsub(/\D/, "")
    if no_symbols.length < 10
      no_symbols = "0"*10
    elsif no_symbols.length == 10
      no_symbols
    elsif no_symbols.length == 11 and no_symbols[0] == 1
      no_symbols = no_symbols[1..-1]
    else
      no_symbols = "0"*10
    end
  end
end