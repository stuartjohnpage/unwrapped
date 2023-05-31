defmodule UnwrappedWeb.GiftIdeaController do
  use UnwrappedWeb, :controller
  alias Unwrapped.Accounts
  alias Unwrapped.GiftIdeas
  alias Unwrapped.GiftIdeas.GiftIdea

  def index(conn, %{"recipient_id" => recipient_id, "giver_id" => giver_id}) do
    giver = Accounts.get_user!(giver_id)
    recipient = Accounts.get_user!(recipient_id)

    gift_ideas = GiftIdeas.get_gift_ideas_for_giver_and_recipient(giver_id, recipient_id)

    gift_context =
      if gift_ideas != [],
        do: List.first(gift_ideas).idea,
        else:
          "A great gift please"
          |> IO.inspect(label: "asdf")

    render(conn, "index.html",
      gift_ideas: gift_ideas,
      giver: giver,
      recipient: recipient,
      gift_context: gift_context
    )
  end

  def new(conn, %{"recipient_id" => recipient_id, "giver_id" => giver_id}) do
    giver = Accounts.get_user!(giver_id)
    recipient = Accounts.get_user!(recipient_id)

    changeset =
      GiftIdeas.change_gift_idea(%GiftIdea{
        giver_id: giver.id,
        recipient_id: recipient.id
      })

    render(conn, "new.html", changeset: changeset, recipient: recipient, giver: giver)
  end

  def create(conn, %{"gift_idea" => gift_idea_params}) do
    case GiftIdeas.create_gift_idea(gift_idea_params) do
      {:ok, gift_idea} ->
        conn
        |> put_flash(:info, "Gift idea created successfully.")
        |> redirect(to: Routes.gift_idea_path(conn, :show, gift_idea))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    gift_idea = GiftIdeas.get_gift_idea!(id)
    render(conn, "show.html", gift_idea: gift_idea)
  end

  def edit(conn, %{"id" => id}) do
    gift_idea = GiftIdeas.get_gift_idea!(id)
    changeset = GiftIdeas.change_gift_idea(gift_idea)
    render(conn, "edit.html", gift_idea: gift_idea, changeset: changeset)
  end

  def update(conn, %{"id" => id, "gift_idea" => gift_idea_params}) do
    gift_idea = GiftIdeas.get_gift_idea!(id)

    case GiftIdeas.update_gift_idea(gift_idea, gift_idea_params) do
      {:ok, gift_idea} ->
        conn
        |> put_flash(:info, "Gift idea updated successfully.")
        |> redirect(to: Routes.gift_idea_path(conn, :show, gift_idea))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", gift_idea: gift_idea, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    gift_idea = GiftIdeas.get_gift_idea!(id)
    {:ok, _gift_idea} = GiftIdeas.delete_gift_idea(gift_idea)

    conn
    |> put_flash(:info, "Gift idea deleted successfully.")
    |> redirect(to: Routes.gift_idea_path(conn, :index))
  end

  def generate(conn, %{
        "gift_idea" => %{
          "recipient_id" => recipient_id,
          "giver_id" => giver_id,
          "gift_context" => gift_context
        }
      }) do
    # {:ok, generated_idea} = OpenAI.generate_gift_idea(gift_context)

    # |> put_flash(:info, "Generated Gift Idea: #{generated_idea}")
    query_string =
      Plug.Conn.Query.encode(%{"recipient_id" => recipient_id, "giver_id" => giver_id})

    redirect(conn, to: Routes.gift_idea_path(conn, :index) <> "?" <> query_string)
  end
end
