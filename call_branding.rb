methods_for :dialplan do:

  #Brand the call, passing the a hash of
  # :callerid_number => '4155551212'
  # :callerid_name => 'John Doe'
  def brand_call(options)
    case COMPONENTS.call_branding[:branding_type]
    when 'CALLERID'
      #Set the CallerID varaibles of the channel
      execute("SET", "CALLERID(num)=#{options[:callerid_number]}")
      execute("SET", "CALLERID(name)=#{options[:callerid_name]}")
    when 'SIPADDHEADER'
      #Add the custom SIP header P-Asserted-Identity from the last 10 characters of the Service Name
      raw_response("EXEC SipAddHeader " + 
                   "P-Asserted-Identity:" +   
                   "#{options[:callerid_name]}<sip:#{options[:callerid_number]}@#{COMPONENTS.call_branding[:from_domain]}>")
    when 'VARIABLES'
      #Simply add 2 channel variables that may then be used in the dialplan/extensions.conf
      set_variable("ASSERTED_NAME", options[:callerid_name])
      set_variable("ASSERTED_NUMBER", options[:callerid_number])
    end
    ahn_log.call_branding.debug("Set CLI as " +
                                options[:callerid_name] + " " + 
                                options[:callerid_number])
  end

end