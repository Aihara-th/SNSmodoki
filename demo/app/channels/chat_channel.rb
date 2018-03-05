class ChatChannel < ApplicationCable::Channel
def subscribed
  stream_from "chat_channel_#{params[:room_id]}"
end

def unsubscribed
end

def speak(data)
  from_person = Person.find_by(id: data['from_id'].to_s)
  to_person = Person.find_by(id: data['to_id'].to_s)
  from_person.send_message(to_person, data['room_id'], data['content'])
end
end
