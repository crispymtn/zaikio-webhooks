# Zaikio::Webhooks

Gem that enables you to easily subscribe to Zaikio's webhooks. It also enables other gems to subscribe to events.

## Installation

### 1. Add this line to your application's Gemfile:

```ruby
gem 'zaikio-webhooks'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install zaikio-webhook
```

### 2. Configure the gem:

```rb
# config/initializers/zaikio_webhooks.rb

Zaikio::Webhooks.configure do |config|
  config.register_client :my_app do |my_app|
    my_app.shared_secret = "test-secret"
  end

  config.register_client :my_other_app do |my_other_app|
    my_other_app.shared_secret = "test-secret"
  end
end
```

### 3. Mount Engine

```rb
mount Zaikio::Webhooks::Engine => "/zaikio/webhook"
```

The final webhook URL will be:

```
https://mydomain.de/zaikio/webhook/:client_name
```

### 4. Configure ActiveJob

It is recommended to configure background processing, if not all events are performed immediately. Read the [ActiveJob Rails Guide](https://guides.rubyonrails.org/active_job_basics.html) for more details.

### 5. Setup Custom Jobs

Every webhook callback expects one job. The job receives the event with useful attributes:

```rb
class AddMachineJob < ApplicationJob
  def perform(event)
    event.id # UUID
    event.name # directory.machine_added
    event.subject_type # Organization
    event.subject_id # UUID of the subject
    event.link # optional URL
    event.payload # Hash with the payload data
    event.created_at # DateTime
    event.received_at # DateTime
  end
end
```

### 6. Add Webhook URL to Zaikio Hub

Login to [Zaikio Hub](https://directory.zaikio.com/) and go to your Apps and go to Edit App and add your webhook URL e.g. `https://mydomain.de/zaikio/webhook/my_app_name`.

Now you should receive all events you subscribed to.

### 7. Usage

When everything is set up you can register events with custom jobs like this (you might add this to the `config/initializers/zaikio_webhooks.rb`):

```rb
# Perform job immediately, for all clients
Zaikio::Webhooks.on "directory.revoked_access_token", RevokeAccessTokenJob,
                    perform_now: true
# Only for a specific client
Zaikio::Webhooks.on "directory.machine_added", AddMachineJob,
                    client_name: :my_app
```
