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
      if gift_ideas != [] do
        List.first(gift_ideas).idea
      else
        "A great gift please"
      end

    IO.inspect(gift_context, label: "context inside of index")

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
        giver_id: giver_id,
        recipient_id: recipient_id
      })

    render(conn, "new.html", changeset: changeset, recipient: recipient, giver: giver)
  end

  def generate(conn, %{"gift_idea" => gift_idea_params}) do
    recipient_id = gift_idea_params["recipient_id"]
    giver_id = gift_idea_params["giver_id"]
    context = gift_idea_params["gift_context"]
    IO.inspect(context, label: "context inside of generate")

    case OpenAI.generate_gift_idea(context) do
      {:ok, %{item: item, description: description}} ->
        conn
        |> put_flash(:info, "AI gift idea generated successfully: #{item}")
        |> redirect(to: Routes.gift_idea_path(conn, :index, recipient_id, giver_id))

      {:error, _, _} ->
        conn
        |> put_flash(:error, "Failed to generate AI gift idea.")
        |> redirect(to: Routes.gift_idea_path(conn, :index, recipient_id, giver_id))
    end
  end

  def create(conn, %{
        "gift_idea" =>
          %{"recipient_id" => recipient_id, "giver_id" => giver_id, "idea" => idea} = params
      }) do
    case GiftIdeas.create_gift_idea(params) do
      {:ok, gift_idea} ->
        conn
        |> put_flash(:info, "Gift idea created successfully.")
        |> redirect(to: Routes.gift_idea_path(conn, :show, recipient_id, giver_id, gift_idea.id))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"recipient_id" => recipient_id, "giver_id" => giver_id, "id" => id}) do
    gift_idea = GiftIdeas.get_gift_idea!(id)

    render(conn, "show.html", gift_idea: gift_idea, giver_id: giver_id, recipient_id: recipient_id)
  end

  def edit(conn, %{"id" => id}) do
    gift_idea = GiftIdeas.get_gift_idea!(id)
    changeset = GiftIdeas.change_gift_idea(gift_idea)
    render(conn, "edit.html", gift_idea: gift_idea, changeset: changeset)
  end

  def delete(conn, %{"recipient_id" => recipient_id, "giver_id" => giver_id, "id" => id}) do
    gift_idea = GiftIdeas.get_gift_idea!(id)
    {:ok, _gift_idea} = GiftIdeas.delete_gift_idea(gift_idea)

    gift_ideas = GiftIdeas.get_gift_ideas_for_giver_and_recipient(giver_id, recipient_id)
    giver = Accounts.get_user!(giver_id)
    recipient = Accounts.get_user!(recipient_id)

    gift_context =
      if gift_ideas != [],
        do: List.first(gift_ideas).idea,
        else: "A great gift please"

    conn
    |> put_flash(:info, "Gift idea deleted successfully.")
    |> redirect(
      to:
        Routes.gift_idea_path(
          conn,
          :index,
          recipient_id,
          giver_id
        )
    )
  end

  def update(conn, %{"id" => id, "gift_idea" => gift_idea_params}) do
    gift_idea = GiftIdeas.get_gift_idea!(id)

    case GiftIdeas.update_gift_idea(gift_idea, gift_idea_params) do
      {:ok, updated_gift_idea} ->
        conn
        |> put_flash(:info, "Gift idea updated successfully.")
        |> redirect(
          to:
            Routes.gift_idea_path(
              conn,
              :show,
              updated_gift_idea.recipient_id,
              updated_gift_idea.giver_id,
              updated_gift_idea.id
            )
        )

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", gift_idea: gift_idea, changeset: changeset)
    end
  end
end
