if defined?(Rails::Server)
  Thread.new do
    loop do
      sleep 24.hours
      ArquivarChamadosJob.perform_later
    end
  end
end
