defmodule OpenAI do
  require HTTPoison
  alias HTTPoison.{Response, Error}

  def generate_gift_idea(gift_context) do
    system_context =
      "You are an AI assistant who generates gift ideas based on the context given. Please format your responses thusly: `ITEM: the item you would suggest,  DESCRIPTION: A short description"

    generate_chat_message(system_context, gift_context)
  end

  defp generate_chat_message(system_message, user_message) do
    url = "https://api.openai.com/v1/chat/completions"

    headers = [
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer #{Application.get_env(:unwrapped, :openai_api_key)}"}
    ]

    body =
      %{
        "model" => "gpt-3.5-turbo",
        "messages" => [
          %{"role" => "system", "content" => system_message},
          %{"role" => "user", "content" => user_message}
        ],
        "temperature" => 0.7
      }
      |> Jason.encode!()

    options = [timeout: 30_000, recv_timeout: 30_000]

    case HTTPoison.post(url, body, headers, options) do
      {:ok, %Response{status_code: 200, body: body}} ->
        {:ok, Jason.decode!(body)}
        |> IO.inspect()

      {:ok, %Response{status_code: status_code, body: body}} ->
        {:error, "Received status #{status_code}, body: #{body}"}
        |> IO.inspect()

      {:error, %Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
