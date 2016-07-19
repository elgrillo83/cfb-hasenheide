//= require action_cable
//= require_self
//= require_tree .

this.App = {};

App.cable = ActionCable.createConsumer();

App.messages = App.cable.subscriptions.create('MessagesChannel', {
  received: function(data) {
    console.log(data)
    $('#messages').removeClass('hidden')
    // append message
    $('#messages').append(data.message);
  }
});
