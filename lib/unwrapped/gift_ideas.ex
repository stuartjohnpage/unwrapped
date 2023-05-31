defmodule Unwrapped.GiftIdeas do
  @moduledoc """
  The GiftIdeas context.
  """

  import Ecto.Query, warn: false
  alias Unwrapped.Repo

  alias Unwrapped.GiftIdeas.GiftIdea

  @doc """
  Returns the list of gift_idea.

  ## Examples

      iex> list_gift_idea()
      [%GiftIdea{}, ...]

  """
  def list_gift_idea do
    Repo.all(GiftIdea)
  end

  @doc """
  Gets a single gift_idea.

  Raises `Ecto.NoResultsError` if the Gift idea does not exist.

  ## Examples

      iex> get_gift_idea!(123)
      %GiftIdea{}

      iex> get_gift_idea!(456)
      ** (Ecto.NoResultsError)

  """
  def get_gift_idea!(id), do: Repo.get!(GiftIdea, id)

  @doc """
  Creates a gift_idea.

  ## Examples

      iex> create_gift_idea(%{field: value})
      {:ok, %GiftIdea{}}

      iex> create_gift_idea(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_gift_idea(attrs \\ %{}) do
    IO.inspect(attrs)
    %GiftIdea{}
    |> GiftIdea.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a gift_idea.

  ## Examples

      iex> update_gift_idea(gift_idea, %{field: new_value})
      {:ok, %GiftIdea{}}

      iex> update_gift_idea(gift_idea, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_gift_idea(%GiftIdea{} = gift_idea, attrs) do
    gift_idea
    |> GiftIdea.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a gift_idea.

  ## Examples

      iex> delete_gift_idea(gift_idea)
      {:ok, %GiftIdea{}}

      iex> delete_gift_idea(gift_idea)
      {:error, %Ecto.Changeset{}}

  """
  def delete_gift_idea(%GiftIdea{} = gift_idea) do
    Repo.delete(gift_idea)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking gift_idea changes.

  ## Examples

      iex> change_gift_idea(gift_idea)
      %Ecto.Changeset{data: %GiftIdea{}}

  """
  def change_gift_idea(%GiftIdea{} = gift_idea, attrs \\ %{}) do
    GiftIdea.changeset(gift_idea, attrs)
  end

  def get_gift_ideas_for_giver_and_recipient(giver_id, recipient_id) do
    from(g in Unwrapped.GiftIdeas.GiftIdea,
      where: g.giver_id == ^giver_id and g.recipient_id == ^recipient_id
    )
    |> Repo.all()
  end
end
