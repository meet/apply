module ExportHelper
  
  def app_export_columns(call)
    call.app_class.content_columns.reject { |c| [ :text, :binary ].include? c.type }
  end
  
end
