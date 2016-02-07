class RealtimeDocumentStatusController < FayeRails::Controller
  observe Document, :after_save do |document|
    Rails.logger.info('------------------AFTER CREATE NOTIF SESSION ------------------')
    RealtimeDocumentStatusController.publish('/document-status', document.received_at)
  end
  channel '/document-status' do
    monitor :subscribe do
      puts "Client #{client_id} subscribed to #{channel}."
    end
    monitor :unsubscribe do
      puts "Client #{client_id} unsubscribed from #{channel}."
    end
    monitor :publish do
      puts "Client #{client_id} published #{data.inspect} to #{channel}."
    end
  end
end
