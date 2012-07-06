# omniauth-tapjoy
[![Build
Status](https://secure.travis-ci.org/Tapjoy/omniauth-tapjoy.png)](http://travis-ci.org/Tapjoy/omniauth-tapjoy)

This is an omniauth plugin that can be used to connect to Tapjoy.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-tapjoy'
```

And then execute:

    $ bundle

Create `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :tapjoy, TAPJOY_KEY, TAPJOY_SECRET
end
```

Now when you hit the `/auth/tapjoy` on your server, it will redirect to `oauth.tapjoy.com` then back to `/auth/tapjoy/callback` with credentials.
We will now setup this callback route

Add this line to `config/routes.rb`:

```ruby
match '/auth/tapjoy/callback' => 'user_sessions#create'
```

Create the `app/controllers/user_sessions_controller.rb`

```ruby
class UserSessionsController < ApplicationController
  def create
    # This likely needs more logic to do things such as creating new users
    user = User.find(request.env['omniauth.auth']['uid'])
    session[:user_id] = user.id # or however you log a user in
  end
end
```

## Installation with Devise

If you are using Devise, this is how you can use Tapjoy as your OAUTH provider.

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-tapjoy'
```

And then execute:

    $ bundle


Add this line to `config/intializers/devise.rb`:

```ruby
config.omniauth :tapjoy, 'TAPJOY_KEY', 'TAPJOY_SECRET'
```

Add a callback controller to be run after the user is authenticated: `app/controllers/users/omniauth_callbacks_controller.rb`

```ruby
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def tapjoy
    user = request.env["omniauth.auth"]["info"]
    @user = User.find_or_initialize_by_email(user["email"].downcase)
    @user.first_name = user["first_name"]
    @user.last_name = user["last_name"]
    @user.save!

    flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: "Tapjoy"
    sign_in_and_redirect @user, :event => :authentication
    finished('sign_up_text')
  end
end
```

Set the route to use the callback you just created:

```ruby
devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
```

If you aren't using Devise, you can either connect to the oauth server directly,
or directly use omniauth: [https://github.com/intridea/omniauth](https://github.com/intridea/omniauth)

## Information available

```json
{
  "id": "63be812b-706d-44c9-9e47-742511c6f939",
  "email": "jeff@tapjoy.com",
  "first_name": "Jeff",
  "last_name": "Dickey",
  "created_at": "2012-02-08T05:36:09Z",
  "facebook_id": "42004440",
  "country": "United States",
  "time_zone": "Pacific Time (US & Canada)",
  "is_employee": true
}
```

## Example

For an example of this in use, check the wheeler board: [https://github.com/Tapjoy/wheeler_board](https://github.com/Tapjoy/wheeler_board)
