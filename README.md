# Unwrapped

We keep buying the same gifts for each other. To avoid gift collision, 
we present, 
unwrapped.

## Core loop

1. Sign-up to events
2. See people in that event
3. See what gifts those people are receiving
4. Don't see your own gift

## Road Map
### Home Screen

Pick an event, or find a person, to either sign up to an event or find a person to buy a gift for.

### Pick an event

List all events, and you can sign up to them. You have the option to create an event and invite people to that event.

### Event

Lists out all the people that have been invited to that event, you can add a person there as well

### Person

Click on a person, summary of gifts that that person is recieivng. You can add a gift that you are getting them. If you type the same thing as someone else, then gift collision pops up, and an explosion. 

### Find a person

Search your friends, once you click on that person, you can add gift ideas for that person. that person can add gift ideas for themselves.

## Setup

The only setup you should have to do (besides using asdf to install elixir and erlang using the correction versions in the `.tool-versions` is creating an `dev.secret.exs` file in the config direction, and filling it with:

```
import Config

config :super_secret_config,
  super_secret_access_password: "example_access_password",
  super_secret_admin_password: "example_admin_password"
```
