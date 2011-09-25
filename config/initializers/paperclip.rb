Paperclip.interpolates(:app_identity) do |attachment, style|
  attachment.instance.class.call.identify(attachment.instance, '-')
end
